document.addEventListener('turbolinks:load', function (e) {
  $('.answers').on('click', '.edit-answer-link', (event) => {
    const answerId = $(event.target).parent('li').data('answerId');

    event.preventDefault();
    $(event.target).hide();
    $(`form#edit-answer-${answerId}`).removeClass('hidden');
  });
});
