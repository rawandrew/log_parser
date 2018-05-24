require 'spec_helper'
require_relative '../bin/stats'
require_relative '../bin/log_line_parser'

RSpec.describe Stats do

  it 'can instantiate a Stats class' do
    expect(Stats.new).not_to be nil
  end

  it 'can intialize the stats with a log line parser' do
    stats = Stats.new(line_parser: LogLineParser.new)
    expect(stats.line_parser).to be_a LogLineParser
  end

  it 'contains a default log line parser if one isn\'t passed in' do
    stats = Stats.new
    expect(stats.line_parser).to be_a LogLineParser
  end
end