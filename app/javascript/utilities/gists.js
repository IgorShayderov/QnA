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
      const keys = Object.keys(data.files);

      if (Object.keys(data.files).length) {
        const gistContent = document.createElement('div');
        const header = document.createElement('p');

        gistContent.appendChild(header);
        header.innerHTML = data.description;

        for (let file in data.files) {
          gistContent.insertAdjacentHTML('beforeend', data.files[file].content);
        }

        gist.replaceWith(gistContent);
      }
    })
    });
  }

});

function truncateGistLink(link) {
  return /(?<=\/)\w+$/.exec(link)[0];
}
