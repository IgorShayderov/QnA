# frozen_string_literal: true

module ControllerHelpers
  def create_file_blob(
    filename: 'alphabet.jpg',
    content_type: 'image/jpg'
  )
    ActiveStorage::Blob.create_after_upload!(
      io: file_fixture(filename).open,
      filename: filename,
      content_type: content_type
    )
  end
end
