require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
  minimum_coverage 100
  refuse_coverage_drop
end if ENV["coverage"]

require_relative '../lib/http_server_manager'
require_relative '../lib/http_server_manager/rake/task_generators'

module HttpServerManager

  def self.root
    @root ||= File.expand_path("../../../", __FILE__)
  end

end

require_relative 'support/http_server_manager/test_support'
HttpServerManager.logger = HttpServerManager::Test::SilentLogger
HttpServerManager.pid_dir = "#{HttpServerManager.root}/tmp/pids"
HttpServerManager.log_dir = "#{HttpServerManager.root}/tmp/logs"

require_relative '../examples/rack_server'
