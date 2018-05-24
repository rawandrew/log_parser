require_relative 'log_line_parser'
require 'set'

class Stats
  attr_reader :line_parser, :file, :data

  def initialize(file: false, line_parser: LogLineParser.new)
    @line_parser = line_parser
    @file = file
    get_data_from_file
  end

  def get_most_page_views
    return 'No log file to process' unless file
    data.keys
        .map { |website_page| {page: website_page, visits: data[website_page][:visits] } }
        .sort_by { |page_visits| page_visits[:visits] }
        .reverse
        .map { |page_visits| "#{page_visits[:page]} #{page_visits[:visits]} visits"}
        .join("\n")
  end

  def get_most_unique_page_views
    return 'No log file to process' unless file
  end

  private

  def get_data_from_file
    @data = {}
    return data unless file
    file.each do |log_line|
      line_data = line_parser.parse log_line: log_line
      if data[line_data[:page]]
        @data[line_data[:page]][:visits] += 1
        @data[line_data[:page]][:visitors] << line_data[:user]
      else
        @data[line_data[:page]] = {
            visits: 1,
            visitors: Set.new([line_data[:user]])
        }
      end
    end
    @data
  end
end