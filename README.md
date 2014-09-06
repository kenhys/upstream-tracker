# Upstream::Tracker

upstream-tracker gem is a tool to fetch data about API/ABI changes from http://upstream-tracker.org/.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'upstream-tracker'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install upstream-tracker

## Usage

Get list of registered library:

    $ upstream-tracker list

Specify libraries which you want to search from:

    $ upstream-tracker use GTK+,glib

Search symbol which you want to:

    $ upstream-tracker search g_strdown

## Contributing

1. Fork it ( https://github.com/kenhys/upstream-tracker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
