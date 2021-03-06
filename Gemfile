source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt'

# Used for fetching and parsing rss feeds.
gem 'feedjira'

#Used for queueing feed updates
gem 'resque', "~> 1.22.0"
gem 'redis'

# Keeps my secrets nice and safe.
gem "figaro"

# Handles image uploading
gem "paperclip"
gem "aws-sdk"

# Sets up backbone
gem "backbone-on-rails"

# Uses faker for seeding the db
gem 'faker'

# Uses kaminari for pagination
gem 'kaminari'

# Uses nokogiri for scraping rss feeds from homepages
gem 'nokogiri'

# Icons
gem 'font-awesome-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'byebug'
  gem 'letter_opener'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'guard-rspec'
  gem 'shoulda-matchers'
  gem 'webmock'
end

group :production do
  gem 'rails_12factor'
end
# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
