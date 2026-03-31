module Acmesmith
  module Utils
    module Finder
      class NotFound < StandardError; end

      def self.find(const, prefix, name, error: true)
        retried = false
        constant_name = name.to_s.gsub(/\A.|_./) { |s| s[-1].upcase }

        begin
          const.const_get constant_name, false
        rescue NameError
          unless retried
            begin
              require "#{prefix}/#{name}"
            rescue LoadError
              raise NotFound, "Couldn't find #{name.inspect} for #{const}" if error
              return nil
            end

            retried = true
            retry
          end

          raise NotFound, "Couldn't find #{name.inspect} for #{const}" if error
        end
      end
    end
  end
end
