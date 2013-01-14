#!/usr/bin/env ruby
require 'optparse'
options = {}
opts = OptionParser.new do |opts|
    opts.banner = "Usage: block [options]"
    opts.on("-f", "--file FILE", "File to watch") do |file|
        options[:file] = file
    end
    # List of searches.
    opts.on("-s", "--search x,y,z", Array, "Example 'list' of searches") do |search|
      options[:search] = search
    end
    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        options[:verbose] = v
    end
    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
end
begin
  opts.parse!
  mandatory = [:file, :search]
  missing = mandatory.select{ |param| options[param].nil? }
  if not missing.empty?
    puts "Missing options: #{missing.join(', ')}"
    puts opts
    exit
  end
rescue OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts opts
  exit
end

puts "Performing task with options: #{options.inspect}"