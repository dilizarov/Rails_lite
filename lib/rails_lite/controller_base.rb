require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = Params.new(req, route_params)
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
    @already_rendered
  end

  def redirect_to(url)
    @res.status = 302
    @res.header['LOCATION'] = url
    session.store_session(@res)
    
    
    @response_built = true
  end

  def render_content(content, type)
    @res.body = content
    @res.content_type = type
    session.store_session(@res)
    
    @already_rendered = true
  end

  def render(template_name)
    controller_name = self.class.name.underscore
    erb = File.read("views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(erb)
    result = template.result(binding)
    render_content(result, 'text/html')
  end

  def invoke_action(name)
    self.send(name)
    
    render(name) unless already_rendered?
  end
end
