require_relative 'log_line_parser'
require 'set'

class LogAnalyzer
  attr_reader :line_parser, :file, :data

  def initialize(file: false, line_parser: LogLineParser.new)
    @line_parser = line_parser
    @file = file
    initialize_data_from_file
  end

  def generate_page_views_stats
    return no_file unless file
    sort_log_data_using page_visits_data
  end

  def generate_unique_page_views_stats
    return no_file unless file
    sort_log_data_using unique_page_visits_data
  end

  private

  def initialize_data_from_file
    @data = {}
    return data unless file
    file.each do |log_line|
      line_data = line_parser.parse log_line: log_line
      page_stats_exist?(line_data) ? update_page_visit_data(line_data) : initialize_data_for_new_page(line_data)
    end
  end

  def page_stats_exist?(line_data)
    data[line_data[:page]]
  end

  def update_page_visit_data(line_data)
    @data[line_data[:page]][:visits] += 1
    @data[line_data[:page]][:visitors] << line_data[:user]
  end

  def initialize_data_for_new_page(line_data)
    @data[line_data[:page]] = {
        visits: 1,
        visitors: Set.new([line_data[:user]])
    }
  end

  def no_file
    'No log file to process'
  end

  def sort_log_data_using(page_visits_data)
    page_visits_data
        .sort_by { |page_visits| page_visits[:visits] }
        .reverse
        .map { |page_visits| generate_page_visits_description(page_visits) }
        .join("\n")
  end

  def page_visits_data
    data.keys
        .map {|website_page| generate_page_visits_hash(website_page)}
  end

  def unique_page_visits_data
    data.keys
        .map {|website_page| generate_unique_page_visits_hash(website_page)}
  end

  def generate_page_visits_hash(website_page)
    { page: website_page, visits: data[website_page][:visits] }
  end

  def generate_page_visits_description(page_visits)
    "#{page_visits[:page]} #{page_visits[:visits]} visits"
  end

  def generate_unique_page_visits_hash(website_page)
    { page: website_page, visits: data[website_page][:visitors].size }
  end
end