# twitter-bot

Search Twitter for specific terms and automatically reply from your bot
account.

Please exercise reasonable benevolence with your new powers.

![Stealth Mountain](http://i.imgur.com/hopMhyb.png "Stealth Mountain")

## Installation

Add this line to your application's Gemfile:

    gem 'twitter-bot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twitter-bot

## Usage

### 1. Register a Twitter client application

Using your Twitter bot account:

1. Go to https://apps.twitter.com/app/new and create an app

2. Go to the **Keys and Access Tokens** tab and click "Create my access token"
   at the bottom.

You will need to save the 2 keypairs on this page (consumer key/secret & token
key/secret) to configure your bot.

### 2. Create a bot

```ruby
bot = Twitter::Bot.new(
  consumer_key:        'value',
  consumer_secret:     'value',
  access_token_key:    'value',
  access_token_secret: 'value')

bot.search('sneak peak') do |tweet|
  'I think you mean "sneak peek"'
end
```

#### Advanced configuration

* `interval`: seconds to wait between polling requests (default: 5)
* `user_agent`: custom user agent for Twitter API requests

#### More examples

```ruby
bot.search('"how long is this tweet"') do |tweet|
  "@#{tweet.user.screen_name} This is #{tweet.text.size} characters long"
end
```

```ruby
bot.search('from:nihilist_arbys "horsey saurce"') { |tweet| 'Yum!' }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
