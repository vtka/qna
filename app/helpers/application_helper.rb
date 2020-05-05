module ApplicationHelper
  FLASH_TO_ALERT = { notice: :primary, alert: :warning, error: :danger }.freeze

  def flash_type_to_alert(type)
    FLASH_TO_ALERT[type.to_sym] || type
  end

  def current_year
    Time.current.year
  end

  def gist?(link)
    link[:url].include?('gist.github.com')
  end

  def gist(link)
    response = GistService.new(link[:url]).call
    render partial: 'gists/gist', locals: { resource: response, link: link }
  end
end
