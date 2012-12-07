module Facebook

  class Settings
    
    class << self
      def method_missing(method_id, *args, &block)
        config = self.config_hash

        if config[method_id.to_s]
          self.class_eval <<-EOS, __FILE__, __LINE__ + 1
            def self.#{method_id}
              self.config_hash["#{method_id}"]
            end
          EOS
          send(method_id, *args)
        else
          super
        end
      end

      def config_hash
        config = YAML::load(File.open(File.expand_path("#{RAILS_ROOT}/config/facebook.yml")))[RAILS_ENV]
      end
    end
    
  end
end