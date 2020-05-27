class SearchController < ApplicationController
  def index
    @search_result = SearchService.new(search_params).call
  end

  def search_params
    params.permit(:q, :scope)
  end
end
