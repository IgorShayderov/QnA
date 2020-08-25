class SearchesController < ApplicationController
  skip_authorization_check

  def index
    search_base = option == "global" ? ThinkingSphinx : option.capitalize.constantize

    @result = search_base.search context
  end

  private

  def option
    params[:option]
  end

  def context
    params[:context]
  end

end
