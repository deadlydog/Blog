source "https://rubygems.org"

# If we get gem errors building/running the site, try:
# 1. Comment out this file.
# 2. Run `bundle clean` in the terminal to remove all local gem files.
# 3. Uncomment this file.
# 4. Run `bundle install` again to download and reinstall gem files.
# Source: https://stackoverflow.com/a/71504116/602585

gem "github-pages", group: :jekyll_plugins

# Liquid 4.0.3 and less are not compatible with newer versions of Ruby (v3.2+).
gem "liquid", ">= 4.0.4"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem.
gem "tzinfo-data"

# Performance-booster for watching directories on Windows.
gem "wdm", "~> 0.2.0" if Gem.win_platform?

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
#   gem "jemoji" # Disable until this is fixed to be compatible with Ruby v3.3. See: https://github.com/jekyll/jekyll/issues/9733
  gem "jekyll-include-cache"
  gem "jekyll-algolia"
end

# Required for Ruby v3+
gem "webrick", "~> 1.7"
