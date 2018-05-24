require_relative 'log_line_parser'

class Stats
  attr_reader :line_parser

  def initialize(line_parser: LogLineParser.new)
    @line_parser = line_parser
  end
end