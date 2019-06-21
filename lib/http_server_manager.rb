require 'net/http'
require 'sys/proctree'
require 'wait_until'

require_relative 'http_server_manager/stdout_logger'

module HttpServerManager

  class << self

    attr_accessor :pid_dir, :log_dir
    attr_writer   :logger

    def logger
      @logger || HttpServerManager::StdOutLogger.new
    end

  end

end

require_relative 'http_server_manager/server'
