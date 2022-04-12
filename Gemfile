# frozen_string_literal: true

source "https://rubygems.org"
	
ruby RUBY_VERSION
DECIDIM_VERSION="0.24.3"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION
gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"
gem "faker", "~> 2.14"

gem "wicked_pdf", "~> 1.4"

gem 'decidim-verifications'
gem 'decidim-verifications-custom_csv_census', git: 'https://github.com/CodiTramuntana/decidim-verifications-custom_csv_census.git'
group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "passenger"
  gem "figaro"
  gem "sidekiq"
  gem "sidekiq-cron"
end
