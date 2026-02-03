# config/initializers/prometheus.rb

require 'prometheus/client'
require 'prometheus/client/exporter/rack'
require 'prometheus/client/middleware/collector'

Rails.application.middleware.insert_before 0, Prometheus::Client::Middleware::Exporter
Rails.application.middleware.insert_before 0, Prometheus::Client::Middleware::Collector
