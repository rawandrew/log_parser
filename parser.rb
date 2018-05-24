#!/usr/bin/env ruby
require_relative 'bin/log_analyzer'

file = File.open(ARGV.first)
stats = LogAnalyzer.new file: file
puts 'Webpages ordered by page views descending:'
puts stats.generate_page_views_stats
puts 'Webpages ordered by unique page views descending:'
puts stats.generate_unique_page_views_stats