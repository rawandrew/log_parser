#!/usr/bin/env ruby
require_relative 'bin/stats'

file = File.open(File.join(Dir.pwd, ARGV.first), 'r')
stats = Stats.new file: file
puts 'Webpages ordered by most views:'
puts stats.get_most_page_views
puts 'Webpages ordered by most unique views:'
puts stats.get_most_unique_page_views