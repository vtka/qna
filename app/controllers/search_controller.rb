class SearchController < ApplicationController
  expose :search_result, -> { SearchService.new(search_params).call }

  def search_params
    params.permit(:q, :scope)
  end
end
