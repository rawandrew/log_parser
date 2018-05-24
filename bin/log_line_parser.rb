class LogLineParser

  def parse(log_line: '')
    return false unless log_line.kind_of? String
    return false if log_line.empty?
    data = log_line.match(/(?<web_page>.*)\s(?<user_ip>\d{3}\.\d{3}\.\d{3}\.\d{3})/)
    {
        page: data[:web_page],
        user: data[:user_ip]
    }
  end
end