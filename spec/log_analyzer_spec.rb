require 'spec_helper'
require 'tempfile'
require_relative '../bin/log_analyzer'
require_relative '../bin/log_line_parser'

RSpec.describe LogAnalyzer do

  it 'can instantiate a Stats class' do
    expect(LogAnalyzer.new).not_to be nil
  end

  it 'can intialize the stats with a log line parser' do
    stats = LogAnalyzer.new(line_parser: LogLineParser.new)
    expect(stats.line_parser).to be_a LogLineParser
  end

  it 'contains a default log line parser if one isn\'t passed in' do
    stats = LogAnalyzer.new
    expect(stats.line_parser).to be_a LogLineParser
  end

  it 'can initialize the stats with a file object' do
    stats = LogAnalyzer.new(file: File.open(File.join(Dir.pwd, 'webserver.log'), 'r'))
    expect(stats.file).to be_a File
  end

  it 'contains false instead of a file if one isn\'t passed in' do
    stats = LogAnalyzer.new
    expect(stats.file).to be false
  end

  it 'intializes the data after reading the file' do
    Tempfile.create('log') do |f|
      f.puts '/contact 184.123.665.067'
      f.puts '/contact 184.123.665.067'
      f.puts '/home 184.123.665.068'
      f.rewind
      expected_result = {
          "/contact" => { visits: 2, visitors: Set.new(['184.123.665.067'])},
          "/home" => { visits: 1, visitors: Set.new(['184.123.665.068'])}
      }
      stats = LogAnalyzer.new file: f
      expect(stats.data).to eq expected_result
    end
  end

  context '#get_most_page_views' do
    it 'returns "No log file to process" if no file is avaiable' do
      stats = LogAnalyzer.new
      expect(stats.generate_page_views_stats).to eq 'No log file to process'
    end

    it 'returns the website pages ordered by number of page views' do
      Tempfile.create('log') do |f|
        f.puts '/contact 184.123.665.067'
        f.puts '/contact 184.123.665.067'
        f.puts '/home 184.123.665.068'
        f.rewind
        stats = LogAnalyzer.new(file: f)
        expect(stats.generate_page_views_stats).to eq "/contact 2 visits\n/home 1 visits"
      end
    end
  end

  context '#get_most_unique_page_views' do
    it 'returns "No log file to process" if no file is avaiable' do
      stats = LogAnalyzer.new
      expect(stats.generate_unique_page_views_stats).to eq 'No log file to process'
    end

    it 'returns the website pages ordered by number of page views' do
      Tempfile.create('log') do |f|
        f.puts '/contact 184.123.665.067'
        f.puts '/contact 184.123.665.067'
        f.puts '/home 184.123.665.068'
        f.puts '/home 184.123.665.067'
        f.rewind
        stats = LogAnalyzer.new(file: f)
        expect(stats.generate_unique_page_views_stats).to eq "/home 2 visits\n/contact 1 visits"
      end
    end
  end
end