# frozen_string_literal: true

class Link < ApplicationRecord
  GIST_URL = %r{^(https?://)?(www\.)?gist\.github\.com/\w+/\w+$}.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    url.match(GIST_URL).present?
  end
end
