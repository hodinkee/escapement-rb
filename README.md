# Escapement

Given a HTML formatted string, escapement will extract descendant tags into a device agnostic attributes array that can be used for formatting the text anywhere.

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

Basic usage is very straightforward. Escapement will consider all root-level tags as separate elements.

The position values are 0-based and are relative to the plain text result. The first value is the start of the attributed text, and the second is the end of the attributed text.

``` ruby
body = "<p>Isn't <i>Tourbillon</i> a <a href=\"http://google.com\">great</a> word?</p>"

html = Escapement::HTML.new(body)
html.extract!
html.results
# => [{:text=>"Isn't Tourbillon a great word?", :entities=>[{:type=>"italic", :html_tag=>"i", :position=>[6, 16], :attributes=>{}}, {:type=>"link", :html_tag=>"a", :position=>[19, 24], :attributes=>{"href"=>"http://google.com"}}]}]
```

Escapement also supports lists (with nesting), which treats each list item as a separate paragraph-like element.

``` ruby
body = "<ul><li>List item 1</li><ul><li><b>Nested</b> list item</li></ul><li>List item 2</li></ul>"

html = Escapement::HTML.new(body)
html.extract!
html.results

# => [{:type=>"unordered_list", :html_tag=>"ul", :children=>[{:type=>"list_item", :html_tag=>"li", :text=>"List item 1", :entities=>[]}, {:type=>"unordered_list", :html_tag=>"ul", :children=>[{:type=>"list_item", :html_tag=>"li", :text=>"Nested list item", :entities=>[{:type=>"bold", :html_tag=>"b", :position=>[0, 6], :attributes=>{}}]}]}, {:type=>"list_item", :html_tag=>"li", :text=>"List item 2", :entities=>[]}]}]
```

## How It Works

From a high level, Escapement uses [Nokogiri](https://github.com/sparklemotion/nokogiri) to recursively traverse the DOM tree. As it traverses, it keeps track of the current position of the node relative to the text content in order to determine entity position. There are no regular expression hacks involved.

## Contributing

1. Fork it ( https://github.com/hodinkee/escapement/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
