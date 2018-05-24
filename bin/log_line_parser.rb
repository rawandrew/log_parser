class LogLineParser
  attr_reader :log_line, :data

  def parse(log_line: '')
    set_log_line_to log_line
    return false if log_line_not_string?
    return false if log_line_empty?
    extract_log_line_data
    generate_result
  end

  private

  def set_log_line_to(log_line)
    @log_line = log_line
  end

  def log_line_not_string?
    !@log_line.kind_of?(String)
  end

  def log_line_empty?
    @log_line.empty?
  end

  def extract_log_line_data
    @data = @log_line.match(/(?<web_page>\S*)\s*(?<user_ip>\d{3}\.\d{3}\.\d{3}\.\d{3})/)
  end

  def generate_result
    if data
      {
          page: @data[:web_page],
          user: @data[:user_ip]
      }
    else
      {
          page: '',
          user: ''
      }
    end
  end
end