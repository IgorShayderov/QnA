class SearchesController < ApplicationController
  skip_authorization_check

  def index
    p '11111'
    p params
    p params[:context]
    p params[:option]

  end

  private

  # def search_params
  #   params.require()
  # end
end
