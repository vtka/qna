class GistService
  def initialize(gist_link, client: default_client)
    @gist_id = gist_link.split('/').last
    @client = client
  end

  def call
    request = @client.gist(@gist_id)
    CallResult.new(request)
  rescue Octokit::NotFound
    CallResult.new
  end

  private

  def default_client
    Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
  end
end

class CallResult
  def initialize(result = nil)
    @result = result
  end

  def success?
    @result.present?
  end

  def content
    output = []
    @result.files.each do |name, file|
      output.push(name: name, content: file.content.truncate(160))
    end

    output
  end
end
