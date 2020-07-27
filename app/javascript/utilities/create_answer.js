export default function(answer, links, files) {
  const $answerNode = $(document.createElement('li')).attr('data-answer-id', answer.id).addClass('answer');
  const $answerContent = $('<div></div>', { class: 'answer-content' });

  $answerContent.append(`<p>${answer.body}</p>`);

  if (answer.best) {
    $($answerNode).addClass('best');
  }

  const $voteNode = $('<div></div>', { class: 'answer-vote mr-2' });

  if (answer.user_id === gon.user_id) {
    $($voteNode).append("<span>Votes:</span><span class='mr-2 ml-1 answer-votes-total'>0</span");
  } else {
    $($answerNode).append("<a class='vote-for vote-for-answer'></a>");
    $($answerNode).append("<a class='unvote unvote-answer'></a>");
    $($answerNode).append("<a class='vote-against vote-against-answer'></a>");
    // как вложить что-то внутрь тега <a>?
  }

  if (links.length) {
    const $linksNode = $("<ul class='links'></ul>");

    links.forEach((link) => {
      $($linksNode).append(`<li data-link="${link.id}" href="${link.url}"></li>`);
    });

    $($answerContent).append($linksNode);
  }
  // тут ссылки на файлы
  console.log(files.length);
  if (files.length) {
    const $filesNode = $("<div class='answer-files'></div>");

    files.forEach((file) => {
      const $answerFile = $(`<p class='answer-file' data-file='${file.id}'></p>`);

      $($answerFile).append(`<a href='/rails/active_storage/blobs/hz/${file.name}">${file.name}</a>`);
      $($answerFile).append(`<a data-confirm="Are you sure?" class="ml-1" data-remote="true" rel="nofollow" data-method="delete" href="/attachments/${file.id}">(Delete)</a>`);

      $($filesNode).append($answerFile);
    });

    $($answerContent).append($filesNode);
  }

  $($answerContent).append(`<a class="choose-best-answer" data-remote="true" ref="nofollow" data-method="patch" href="/answers/${answer.id}/best">Choose as best answer</a><br><hr>`);
  $($answerContent).append("<a class='edit-answer-link' href='#'>Edit answer</a>");

  const formNode = document.createElement('form');
  
  formNode.classList.add('hidden');
  $(formNode).attr('id', `edit-answer-${answer.id}`);
  $(formNode).attr('enctype', 'multipart/form-data');
  $(formNode).attr('action', `/answers/${answer.id}`);
  $(formNode).attr('accept-charset', 'UTF-8');
  $(formNode).attr('data-remote', 'true');
  $(formNode).attr('method', 'post');

  $(formNode).append("<input type='hidden' name='_method' value='patch'>");
  $(formNode).append("<input type='hidden' name='authenticity token'>");
  $(formNode).append("<label for='answer_body'>Edited answer:</label><br>");
  $(formNode).append(`<textarea cols='40' name='answer[body]' id='answer_body'>${answer.body}</textarea><br>`);
  $(formNode).append("<label for='answer_files'>Files</label><br>");
  $(formNode).append("<input multiple='multiple' type='file' name='answer[files][]' id='answer_files'><br>");

  $(formNode).append('<input>', { type: 'hidden', name: '_method', value: 'patch' });
  $(formNode).append("<label for='answer_body'>Edited answer:</label><br>");
  $(formNode).append(`<textarea cols='40' name='answer[body]' id='answer_body'>${answer.body}</textarea><br>`);
  $(formNode).append("<label for='answer_files>Files</label><br>");

  $($answerContent).append(formNode);
  $($answerContent).append(`<br><a data-confirm="Are you sure?" data-remote="true" rel="nofollow" data-method="delete" href="/answers/${answer.id}">Delete answer</a>`);

  $($answerNode).append($voteNode, $answerContent);
  $('.answers').append($answerNode);
}
