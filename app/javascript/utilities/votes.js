document.addEventListener('turbolinks:load', function (e) {
  const question = $('.question');

  if (question.length) {
    $('.vote-for')
    .on('ajax:success', handleVoteSuccess)
    .on('ajax:error', handleVoteError)

    $('.unvote')
    .on('ajax:success', handleVoteSuccess)
    .on('ajax:error', handleVoteError)

    $('.vote-against')
    .on('ajax:success', handleVoteSuccess)
    .on('ajax:error', handleVoteError)
  }
});

function handleVoteSuccess(event) {
  const { id, resource, votes_total } = event.detail[0];

  $(`.${resource}-errors`).empty();

  if (resource === 'answer') {
    const answer = $(`[data-answer-id='${id}']`);

    $('.answer-votes-total', answer).text(votes_total);
  } else if (resource === 'question') {
    $('.question-votes-total').text(votes_total);
  }
}

function handleVoteError(event) {
  const { errors, resource } = event.detail[0];

  $(`.${resource}-errors`).empty();
  $(`.${resource}-errors`).append('<p><b>Error(s) detected:</b></p');

  $(errors).each((index, value) => {
    $(`.${resource}-errors`).append(`<p class="alert alert-danger">${value}</p>`);
  });
}
