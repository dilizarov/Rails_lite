require 'json'
require 'webrick'

class Session
  def initialize(req)
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @value = JSON.parse(cookie.value)
      end
    end
    
    @value ||= {}  
  end

  def [](key)
    @value[key]
  end

  def []=(key, val)
    @value[key] = val
  end

  def store_session(res)
    res.cookies << 
    WEBrick::Cookie.new('_rails_lite_app', @value.to_json)
  end
end
