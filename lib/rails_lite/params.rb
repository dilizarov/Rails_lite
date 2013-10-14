require 'uri'

class Params
  def initialize(req, route_params = {})
    if req.query_string
      @params = parse_www_encoded_form(req.query_string)
    end
    
    if req.body
      @params = parse_www_encoded_form(req.body)
    end
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    decoded = URI.decode_www_form(www_encoded_form)
    hash_values = {}
    decoded.each do |(x,y)|
      inner_hash = hash_values
      
      keys = parse_key(x)
      keys.each_with_index do |val, index|
        if (index + 1) == keys.length
          inner_hash[val] = y
        else
          inner_hash[val] ||= {}
          inner_hash = inner_hash[val]
        end
      end
    end
    
    hash_values
  end

  def parse_key(key)
    
    if key.include?('[')
      last_bracket = key.rindex('[')
      needed_key = key.slice!(key[last_bracket..-1])
      [key, needed_key[1...-1]]
    else
      [key]
    end
  end
end
