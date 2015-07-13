# Escapement

Given a HTML formatted string, escapement will extract child tags into a device agnostic attributes array that can be used for formatting the text anywhere.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'escapement'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escapement

## Usage

Basic usage is very straightforward.

``` ruby
body = "<p>Escapement is <strong>great</strong>!</p>"

html = Escapement::HTML.new(body)
results = html.extract
#=> [{:text=>"Escapement is great!", :entities=>[{:type=>"bold", :html_tag=>"strong", :position=>[14, 19], :attributes=>{}}]}] 
```

In order to prevent over-engineering, there are some restrictions for the format of the HTML given to escapement.

By default, all text must be wrapped in `<p>` tags. You can override this setting with any CSS selector, if needed.

``` ruby
body = "<span>Isn't <i>Tourbillon</i> a <a href=\"http://google.com\">great</a> word?</span>"

html = Escapement::HTML.new(body, 'span')
results = html.extract
# => [{:text=>"Isn't Tourbillon a great word?", :entities=>[{:type=>"italic", :html_tag=>"i", :position=>[6, 16], :attributes=>{}}, {:type=>"link", :html_tag=>"a", :position=>[19, 24], :attributes=>{"href"=>"http://google.com"}}]}] 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/escapement/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
