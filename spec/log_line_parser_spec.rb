require 'spec_helper'
require_relative '../bin/log_line_parser'

RSpec.describe LogLineParser do
  let(:parser) { LogLineParser.new }

  it 'can instantiate a LogLineParser class' do
    expect(parser).not_to be nil
  end

  context '#parse' do
    it 'returns false when passed an empty log line' do
      expect(parser.parse(log_line: '')).to eq false
    end

    it 'returns false when no log line is passed in' do
      expect(parser.parse).to eq false
    end

    it 'returns false when passed a non string value' do
      expect(parser.parse(log_line: nil)).to eq false
    end

    it 'parses correctly a log line' do
      line_to_parse = '/help_page/1 126.318.035.038'
      result = { page: '/help_page/1', user: '126.318.035.038' }
      expect(parser.parse(log_line: line_to_parse)).to eq result
    end

    it 'parses correctly a log line even when the data is separated by several spaces' do
      line_to_parse = '/help_page/1   126.318.035.038'
      result = { page: '/help_page/1', user: '126.318.035.038' }
      expect(parser.parse(log_line: line_to_parse)).to eq result
    end

    it 'can handle a badly formatted log line' do
      line_to_parse = '/help_page/1   126.318.035'
      result = { page: '', user: '' }
      expect(parser.parse(log_line: line_to_parse)).to eq result
    end
  end
end