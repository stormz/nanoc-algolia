# Nanoc algolia

Index an item in algolia

It use [nokogiri](http://nokogiri.org/) and algolia.

Note: It doesn't allow quering the index, it cannot works with nanoc. You should probably use the javascript integration.

## Install

    gem install nanoc-algolia

If you use bundler, add it to your Gemfile:

    gem "nanoc-algolia", "~> 0.0.1"

## Usage

Add to *lib/default.rb*:

```ruby
require 'nanoc-algolia'
```

Add to *config.yaml*:

    algolia:
      application_id: your_application_id
      api_key: your_api_key
      index: your_index_name

Add a filter at the compile time to use it:

```ruby
compile '*' do
  filter :algolia
  filter :erb
  layout 'default'
end
```

## License

(c) 2011 Pascal Widdershoven (https://github.com/PascalW/jekyll_indextank)
(c) 2015 Stormz

This code is free to use under the terms of the MIT license
