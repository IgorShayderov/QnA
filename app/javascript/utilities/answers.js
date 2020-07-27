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
