source "http://rubygems.org"
source "http://gems.github.com"


gem "rake"
gem "git", ">= 1.2.5"
if RUBY_VERSION < "1.9.2"
  gem "nokogiri", "1.5.10" # newer nokogiri supports only ">= 1.9.2"
end
gem "github_api", ">= 0.8.1"
gem "highline", ">= 1.6.15"
gem "bundler", "~> 1.0"
gem "rdoc"
gem "builder"

group :development do
  gem "yard", "~> 0.8.5"
  gem "rdoc"
  gem "bluecloth"
  gem "cucumber", "~> 1.1.4"
end

group :test do
  gem "timecop"
  gem "activesupport", "~> 2.3.5"
  gem "shoulda"
  gem "mhennemeyer-output_catcher"
  gem "rr", "~> 1.0.4"
  gem "mocha"
  gem "redgreen"
  gem "test-construct"
  gem "rake"
end

# yo dawg, i herd u lieked jeweler
group :xzibit do
  # steal a page from bundler's gemspec:
  # add this directory as jeweler, in order to bundle exec jeweler and use the current working directory
  gem 'jeweler', :path => '.'
end


group :debug do
end
