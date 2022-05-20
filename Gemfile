# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = "0.26.1"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION
gem "bootsnap", "~> 1.3"

gem "faker", "~> 2.14"
gem "puma", ">= 5.0.0"
gem "uglifier", "~> 4.1"

gem "decidim-decidim_awesome"
gem "decidim-direct_verifications", "~> 1.2"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "develop"

gem "virtus-multiparams"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION

  gem "brakeman"
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web", "~> 1.4"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.0"

  gem "capistrano", "~> 3.15"
  gem "capistrano-bundler"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rails-console"
  gem "capistrano-rbenv"
  gem "capistrano-sidekiq"
end

group :production do
  gem "figaro"
  gem "passenger"
  gem "sidekiq"
  gem "sidekiq-cron"
end
