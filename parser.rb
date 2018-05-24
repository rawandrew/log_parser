#!/usr/bin/env ruby
require_relative 'bin/log_analyzer'

file = File.open(ARGV.first)
analyzer = LogAnalyzer.new file: file
puts 'Webpages ordered by page views descending:'
puts analyzer.generate_page_views_stats
puts 'Webpages ordered by unique page views descending:'
puts analyzer.generate_unique_page_views_stats