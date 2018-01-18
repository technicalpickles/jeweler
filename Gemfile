source 'https://rubygems.org'

gem 'rake'
gem 'git', '>= 1.2.5'
gem 'nokogiri', '>= 1.5.10'
gem 'github_api', '~> 0.16.0'
gem 'highline', '>= 1.6.15'
gem 'bundler'
gem 'rdoc'
gem 'builder'
gem "semver2"
gem "psych"

group :development do
  gem 'yard', '>= 0.8.5'
  gem 'bluecloth'
  gem 'cucumber', '>= 1.1.4'
  gem 'simplecov'
end

group :test do
  gem 'timecop'
  gem 'activesupport', '~> 3.2.16'
  gem 'shoulda', require: false
  gem 'mhennemeyer-output_catcher'
  gem 'mocha', require: false
  gem 'redgreen'
  gem 'test_construct'
  gem 'coveralls', require: false
  gem 'test-unit-rr', require: false
end

# yo dawg, i herd u lieked jeweler
group :xzibit do
  # steal a page from bundler's gemspec:
  # add this directory as jeweler, in order to bundle exec jeweler and use the current working directory
  gem 'jeweler', path: '.'
end

group :debug do
  gem 'test-unit'
end
