require 'spec_helper'
require 'tempfile'
require_relative '../bin/log_analyzer'
require_relative '../bin/log_line_parser'

RSpec.describe LogAnalyzer do

  it 'can instantiate a log analyzer class' do
    expect(LogAnalyzer.new).not_to be nil
  end

  it 'can intialize the LogAnalyzer with a log line parser' do
    analyzer = LogAnalyzer.new(line_parser: LogLineParser.new)
    expect(analyzer.line_parser).to be_a LogLineParser
  end

  it 'contains a default log line parser if one isn\'t passed in' do
    analyzer = LogAnalyzer.new
    expect(analyzer.line_parser).to be_a LogLineParser
  end

  it 'can initialize the log analyzer with a file object' do
    analyzer = LogAnalyzer.new(file: File.open(File.join(Dir.pwd, 'webserver.log'), 'r'))
    expect(analyzer.file).to be_a File
  end

  it 'contains false instead of a file if one isn\'t passed in' do
    analyzer = LogAnalyzer.new
    expect(analyzer.file).to be false
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
      analyzer = LogAnalyzer.new file: f
      expect(analyzer.data).to eq expected_result
    end
  end

  context '#get_most_page_views' do
    it 'returns "No log file to process" if no file is avaiable' do
      analyzer = LogAnalyzer.new
      expect(analyzer.generate_page_views_stats).to eq 'No log file to process'
    end

    it 'returns the website pages ordered by number of page views' do
      Tempfile.create('log') do |f|
        f.puts '/contact 184.123.665.067'
        f.puts '/contact 184.123.665.067'
        f.puts '/home 184.123.665.068'
        f.rewind
        analyzer = LogAnalyzer.new(file: f)
        expect(analyzer.generate_page_views_stats).to eq "/contact 2 visits\n/home 1 visits"
      end
    end
  end

  context '#get_most_unique_page_views' do
    it 'returns "No log file to process" if no file is avaiable' do
      analyzer = LogAnalyzer.new
      expect(analyzer.generate_unique_page_views_stats).to eq 'No log file to process'
    end

    it 'returns the website pages ordered by number of page views' do
      Tempfile.create('log') do |f|
        f.puts '/contact 184.123.665.067'
        f.puts '/contact 184.123.665.067'
        f.puts '/home 184.123.665.068'
        f.puts '/home 184.123.665.067'
        f.rewind
        analyzer = LogAnalyzer.new(file: f)
        expect(analyzer.generate_unique_page_views_stats).to eq "/home 2 visits\n/contact 1 visits"
      end
    end
  end
end