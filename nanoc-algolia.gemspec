# encoding: utf-8

Gem::Specification.new do |s|
  s.name             = "nanoc-algolia"
  s.version          = "0.0.1"
  s.date             = Time.now.utc.strftime("%Y-%m-%d")
  s.homepage         = "https://github.com/stormz/nanoc-algolia"
  s.authors          = "François de Metz"
  s.email            = "francois@2metz.fr"
  s.summary          = "Index items from nanoc site to algolia"
  s.extra_rdoc_files = %w(README.md)
  s.files            = Dir["README.md", "lib/**/*.rb"]
  s.require_paths    = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.add_runtime_dependency "algoliasearch", "~> 1.5"
  s.add_runtime_dependency "nokogiri", "~> 1.6"
end
