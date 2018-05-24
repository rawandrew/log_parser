require_relative 'log_line_parser'

class Stats
  attr_reader :line_parser, :file

  def initialize(file: false, line_parser: LogLineParser.new)
    @line_parser = line_parser
    @file = file
  end

  def get_most_page_views

  end

  def get_most_unique_page_views

  end
end