# QnA

Qna is a stackoverflow-like service. You can create question for theme you interested in, or answer another question to help other users.
You able to leave comment for question or answer, if you would like.
Inside every question or answer you can put link or upload file. There are option, which currently turned off, to upload files directly to Amazon S3 Cloud Service.
If you create new question or answer, other users can see them immediately, this feature provided by Action Cable.
Every update to existing question or answer performed through AJAX.

Things you may want to cover:

* Ruby version: 2.7.0

* How to run the test suite.
QnA using RSpec for tests, there are about 300 tests.

* Services (job queues, cache servers, search engines, etc.).
QnA using Sphinx to perform search through question/answers/comments/users.

* Deployment instructions
To successfully perform deploy you should register your application inside vk and github and store somewhere (for example inside rails credentials or .bashrc) authentication data for OAuth. Or you can simply stub OAuth data.
