# frozen_string_literal: true
require 'typhoeus/adapters/faraday'

stack = Faraday::RackBuilder.new do |builder|
  options = {}.tap do |opts|
    opts[:store]        = Rails.cache
    opts[:shared_cache] = false
    opts[:serializer]   = Marshal

    opts[:logger] = Rails.logger unless Rails.env.production?
  end

  builder.use Faraday::HttpCache, options
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
  builder.use FaradayMiddleware::Gzip
  builder.request :retry
  builder.adapter :typhoeus
end
Octokit.middleware = stack
