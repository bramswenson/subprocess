
class Hash
  # str8 from activesupport core_ext/hash/keys.rb
  def symbolize_keys
    inject({}) do |options, (key, value)|
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end
end

