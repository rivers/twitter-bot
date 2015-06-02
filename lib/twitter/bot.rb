require 'twitter/bot/configuration'
require 'twitter/bot/version'
require 'logger'

module Twitter
  class Bot
    attr_writer :logger
    attr_reader :options

    # @param options [Hash] hash of configuration options
    #
    # @option options [String] :consumer_key
    # @option options [String] :consumer_secret
    # @option options [String] :access_token
    # @option options [String] :access_token_secret
    #
    # @option options [String]  :user_agent
    # @option options [Integer] :interval polling interval
    #
    def initialize(options)
      @options = options
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def search(query, &block)
      query = query.to_s

      logger.info "Polling for #{query.inspect} every #{config.interval}s..."

      cursor = nil

      loop do
        perform_search(query, cursor) do |tweet|
          reply(tweet, block)

          cursor = tweet.id if cursor.nil? || tweet.id > cursor
        end
      end
    end

    private

    def perform_search(query, cursor)
      options = { result_type: 'recent' }

      options[:since_id] = cursor if cursor

      logger.info "Searching for #{query}..."

      begin
        client.search(query, options).each { |tweet| yield tweet }
      rescue Twitter::Error::TooManyRequests
        logger.info 'Rate limit exceeded. Resuming in 30s...'

        sleep 30
      end

      sleep config.interval
    end

    def reply(tweet, block)
      *args = block.call(tweet)

      text = args.shift
      tweet_options = args.shift || {}

      return unless text && text.size > 0

      tweet_options[:in_reply_to_status] = tweet

      logger.info "Tweet: #{tweet.full_text}"
      logger.info "Autoreply: #{text}\n"

      begin
        client.update(text, tweet_options)
      rescue Twitter::Error.errors.values => exception
        logger.error "Autoreply failed: #{exception.class} #{exception.message}"
      end
    end

    def config
      @config ||= Configuration.new(options)
    end

    def client
      @client ||= Twitter::REST::Client.new do |client|
        client.consumer_key        = config.consumer_key
        client.consumer_secret     = config.consumer_secret
        client.access_token        = config.access_token
        client.access_token_secret = config.access_token_secret

        client.user_agent = config.user_agent
      end
    end
  end
end
