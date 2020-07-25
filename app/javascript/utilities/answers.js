import createAnswer from './create_answer';

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

    createAnswer(answer, is_author, links);
    // const textField = document.querySelector('#answer_body')
    // console.log(textField);
    // console.log(document.querySelector('#answer_body').value, 'value');
    // textField.value = '!!!!!!!!';
    // console.log(document.querySelector('#answer_body').value, 'after');
    // textField.replaceWith($(textField).text('').clone(true));
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
