Kaminari.configure do |config|
    config.default_per_page = (ENV['PAGINATION_SIZE'] || 10).to_i
end
  