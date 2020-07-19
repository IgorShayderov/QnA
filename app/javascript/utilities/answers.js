document.addEventListener('turbolinks:load', function (e) {
  const $answers = $('.answers');

  if ($answers) {
    $answers.on('click', '.edit-answer-link', (event) => {
      const answerId = $(event.target).parents('[data-answer-id]').data('answerId');
  
      event.preventDefault();
      $(event.target).hide();
      $(`form#edit-answer-${answerId}`).removeClass('hidden');
    });
  }

  $('form.new-answer')
  .on('ajax:success', (event) => {
    const { answer, is_author, links } = event.detail[0];
    const $answerNode = $(document.createElement('li')).attr('data-answer-id', answer.id).addClass('answer');
    const $answerContent = $('<div></div>', { class: 'answer-content' });

    $answerContent.append(`<p>${answer.body}</p>`);

    if (answer.best) {
      $($answerNode).addClass('best');
    }

    const $voteNode = $('<div></div>', { class: 'answer-vote mr-2' });

    if (is_author) {
      $voteNode.append("<span>Votes:</span><span class='mr-2 ml-1 answer-votes-total'>0</span");
    } else if (!is_author){
      $($answerNode).append("<a class='vote-for vote-for-answer'></a>")
    }

    if (links.length) {
      const linksNode = $("<ul class='links'></ul>");

      links.forEach((link) => {
        linksNode.append(`<li data-link="${link.id}" href="${link.url}"></li>`);
      })
    }

    $answerContent.append(`<a class="choose-best-answer" data-remote="true" ref="nofollow" data-method="patch" href="/answers/${answer.id}/best">Choose as best answer</a><br><hr>`);
    $answerContent.append("<a class='edit-answer-link' href='#'>Edit answer</a>");

    const formNode = document.createElement('form');
    
    formNode.classList.add('hidden');
    $(formNode).attr('id', `edit-answer-${answer.id}`);
    $(formNode).attr('enctype', 'multipart/form-data');
    $(formNode).attr('action', `/answers/${answer.id}`);
    $(formNode).attr('accept-charset', 'UTF-8');
    $(formNode).attr('data-remote', 'true');
    $(formNode).attr('method', 'post');

    $(formNode).append('<input>', { type: 'hidden', name: '_method', value: 'patch' });
    $(formNode).append("<label for='answer_body'>Edited answer:</label><br>");
    $(formNode).append(`<textarea cols='40' name='answer[body]' id='answer_body'>${answer.body}</textarea><br>`);
    $(formNode).append("<label for='answer_files>Files</label><br>");

    $answerContent.append(formNode);
    $answerContent.append(`<br><a data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/answers/${answer.id}">Delete answer</a>`);

    $answerNode.append($voteNode, $answerContent);
    $('.answers').append($answerNode);
    $('#answer_body').html('');
  })
  .on('ajax:error', (event) => {
    const erorrs = event.detail[0];

    $('.answer-errors').empty();
    $('.answer-errors').append('<p><b>Error(s) detected:</b></p');

    $(erorrs).each((index, value) => {
      $('.answer-errors').append(`<p class="alert alert-danger">${value}</p>`);
    });

  });
});
