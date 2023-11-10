# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION
DECIDIM_VERSION = { github: "decidim/decidim", branch: "release/0.27-stable" }.freeze

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
# gem "decidim-conferences", DECIDIM_VERSION
# gem "decidim-elections", DECIDIM_VERSION
# gem "decidim-initiatives", DECIDIM_VERSION
# gem "decidim-templates", DECIDIM_VERSION
gem "bootsnap", "~> 1.7"

gem "deface"
gem "puma"

gem "decidim-decidim_awesome", github: "decidim-ice/decidim-module-decidim_awesome"
gem "decidim-direct_verifications", github: "platoniq/decidim-verifications-direct_verifications"
gem "decidim-term_customizer", github: "mainio/decidim-module-term_customizer", branch: "master"

group :development, :test do
  gem "faker", "~> 2.14"
  gem "byebug", "~> 11.0", platform: :mri

  gem "decidim-dev", DECIDIM_VERSION

  gem "brakeman"
  gem "rubocop-faker"
end

group :development do
  gem "letter_opener_web"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "web-console"
end

group :production do
  gem "aws-sdk-s3", require: false
  gem "sidekiq"
  gem "sidekiq-cron"
end
