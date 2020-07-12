document.addEventListener('turbolinks:load', function (e) {
  const gists = document.querySelectorAll('.gist');

  if (gists.length) {
    gists.forEach((gist) => {
      const gist_id = truncateGistLink(gist.href);

    fetch(`https://api.github.com/gists/${gist_id}`)
    .then((data) => {
      return data.json();
    })
    .then((data) => {
      if (Object.keys(data.files).length) {
        const gistBlock = gist.parentElement;
        const header = document.createElement('p');
        const gistName = document.createElement('p');

        gistName.innerHTML = gist.innerHTML;
        gistBlock.append(header);
        header.innerHTML = data.description;

        for (let file in data.files) {
          gistBlock.insertAdjacentHTML('beforeend', data.files[file].content);
        }

        gist.replaceWith(gistName);
      }
    })
    });
  }

});

function truncateGistLink(link) {
  return /(?<=\/)\w+$/.exec(link)[0];
}
