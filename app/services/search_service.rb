class SearchService
  attr_reader :query, :scope

  def initialize(params)
    @query = params[:q]
    @scope = params[:scope]
  end

  def call
    result = scope_klass.search(query)
    SearchResult.new(query, scope, result)
  end

  def scope_klass
    available_resources.include?(scope) ? scope.singularize.constantize : ThinkingSphinx
  end

  def available_resources
    Rails.configuration.x.search.available_resources.drop(1)
  end
end

class SearchResult
  attr_reader :query, :scope, :content, :count

  def initialize(query, scope, result)
    @query = query
    @scope = scope
    @content = result
    @count = content.count
  end

  def success?
    content.present?
  end
end
