# For recursive symbolize of hash keys
def symbolize_keys(hash)
  hash.inject({}){|result, (key, value)|
    new_key = case key
              when String then key.to_sym
              else key
              end
    new_value = case value
                when Hash then symbolize_keys(value)
                else value
                end
    result[new_key] = new_value
    result
  }
end

raw_config = File.read("#{Rails.root}/config/twitter.yml")
TWITTER = symbolize_keys(YAML.load(raw_config)[Rails.env])
