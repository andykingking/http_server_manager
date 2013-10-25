module HttpServerManager

  class Server

    attr_reader :name, :host, :port

    def initialize(options)
      @name = options[:name]
      @host = options[:host]
      @port = options[:port]
      @deletable_artifacts = [pid_file_path]
    end

    def start!
      if running?
        logger.info "#{@name} already running on #{@host}:#{@port}"
      else
        ensure_directories_exist
        pid = Process.spawn(start_command, { [:out, :err] => [log_file_path, "w"] })
        create_pid_file(pid)
        Wait.until_true!("#{@name} is running") { running? }
        logger.info "#{@name} started on #{@host}:#{@port}"
      end
    end

    def stop!
      if running?
        Process.kill_tree(9, current_pid)
        FileUtils.rm_f(@deletable_artifacts)
        logger.info "#{@name} stopped"
      else
        logger.info "#{@name} not running"
      end
    end

    def restart!
      stop!
      start!
    end

    def status
      running? ? :started : :stopped
    end

    def to_s
      "#{@name} on #{@host}:#{@port}"
    end

    def logger
      HttpServerManager.logger
    end

    private

    def running?
      !!Net::HTTP.get_response(@host, "/", @port) rescue false
    end

    def current_pid
      File.exists?(pid_file_path) ? File.read(pid_file_path).to_i : nil
    end

    def pid_file_path
      File.join(pid_dir, "#{@name}.pid")
    end

    def create_pid_file(pid)
      File.open(pid_file_path, "w") { |file| file.write(pid) }
    end

    def log_file_path
      File.join(log_dir, "#{@name}_console.log")
    end

    def ensure_directories_exist
      FileUtils.mkdir_p([pid_dir, log_dir])
    end

    def pid_dir
      HttpServerManager.pid_dir
    end

    def log_dir
      HttpServerManager.log_dir
    end

  end

end
