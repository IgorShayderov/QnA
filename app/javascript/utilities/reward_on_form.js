document.addEventListener('turbolinks:load', function (e) {
  const addReward = document.querySelector('.add-reward');

  if (addReward) {
    addReward.addEventListener('click', (event) => {
      event.preventDefault();
      const newReward = document.querySelector('.new-reward');

      newReward.classList.remove('hidden');
      addReward.classList.add('hidden');
    });
  }
});
