source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'bootstrap-sass', '2.0.0'
gem 'bcrypt-ruby', '3.0.1'  # adds state-of-the-art encryption hash function
gem 'faker', '1.0.1'		# allows us to make semi-realistic users, etc.
gem 'will_paginate', '3.0.3' 			# easy pagination
gem 'bootstrap-will_paginate', '0.0.6'	# configures will_paginate for Bootstrap
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
	# provides annotation capabilities for Rails models etc.
	gem 'annotate', '~> 2.4.1.beta'
end

group :development, :test do
	gem 'sqlite3'
	gem 'rspec-rails', '2.9.0'
	gem 'guard-rspec', '0.5.5'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

group :test do 
	gem 'capybara', '1.1.2'

	# system-dependent gems for running Guard and getting Growl notifications
	gem 'rb-fsevent', :require => false
	gem 'growl', '1.0.3'
	gem 'guard-spork'
	gem 'spork'
	# Factory Girl generates factories useful for defining objects to insert 
	# into database for testing
	gem 'factory_girl_rails', '1.4.0'
end

# indluce PostgreSQL gem for heroku deployment
group :production do 
	gem 'pg', '0.12.2'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
