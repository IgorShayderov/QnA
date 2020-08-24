document.addEventListener('turbolinks:load', function (e) {
  const searchForm = document.querySelector('.search__form');

  if (searchForm) {
    searchForm.addEventListener('submit', (event) => {
      console.log('submit');
    });
  }
});
