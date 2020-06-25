document.addEventListener('turbolinks:load', function (e) {
  const editQuestionLink = document.querySelector('.edit-question-link');

  if (editQuestionLink) {
    const editQuestionForm = document.querySelector('.edit-question-form');

    editQuestionLink.addEventListener('click', (event) => {
      event.preventDefault();
  
      editQuestionLink.classList.add('hidden');
      editQuestionForm.classList.remove('hidden');
    });
  }
});
