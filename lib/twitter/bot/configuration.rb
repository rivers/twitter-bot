module Twitter
  class Bot
    class Configuration
      DEFAULT_INTERVAL = 5

      DEFAULT_USER_AGENT =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) AppleWebKit/537.36 ' \
        '(KHTML, like Gecko) Chrome/43.0.2357.81 Safari/537.36'

      CREDENTIALS = %w(
        consumer_key
        consumer_secret
        access_token
        access_token_secret
      )

      attr_reader :values

      def initialize(values)
        values.keys.each { |key| values[key.to_s] = values.delete(key) }

        @values = values

        validate!
      end

      CREDENTIALS.each do |name|
        define_method(name) { values.fetch(name) }
      end

      def interval
        values.fetch('interval', DEFAULT_INTERVAL)
      end

      def user_agent
        values.fetch('user_agent', DEFAULT_USER_AGENT)
      end

      private

      def validate!
        CREDENTIALS.each do |name|
          unless values.key?(name)
            fail InvalidValue, "Missing required configuration key `#{name}`"
          end
        end

        true
      end

      class InvalidValue < StandardError; end
    end
  end
end
