#!/usr/bin/env ruby
#
# Simple 'tail -f' example.
# Usage example:
#   tail.rb /var/log/messages
# Pretty much direct copy of https://github.com/jordansissel/eventmachine-tail/blob/master/samples/tail.rb

require "rubygems"
require 'optparse'
require "eventmachine"
require "eventmachine-tail"
require 'redis'

class Reader < EventMachine::FileTail
  def initialize(path, startpos=-1)
    options = setup_options
    $search = options[:search]
    super(options[:file], startpos)
    @buffer = BufferedTokenizer.new
    $redis = Redis.new
    @expiry_time = 10
    @magic_number = 30
  end
  
  def setup_options
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
    options
  end

  def log_search(line, pattern)
    if line.split(' ').grep(/#{pattern}/).length > 0
      array = line.split(" ")
      @count = $redis.incr array.first.to_s
      $redis.expire array.first.to_s, @expiry_time
      puts "\nIP: #{array.first.to_s} on #{pattern} (#{@count})"
      if (@count > @magic_number)
        firewall(array.first.to_s)
      end
    else
      print "."
    end
  end

  def receive_data(data)
    @buffer.extract(data).each do |line|
      $search.each do |search|
        log_search(line, "#{search}")
      end
    end
  end

    def firewall(ip)
      # /sbin/iptables -I INPUT -s 174.136.98.202 -j DROP
      puts "Firewalling: #{ip}"
      if ($redis.sismember "ips", "#{ip}")
        puts "Already firewalled"
      else
        system "/sbin/iptables -I INPUT -s #{ip} -j DROP"
        $redis.sadd "ips", "#{ip}"
      end
    end
  end

  def main(args)
    if args.length == 0
      puts "Usage: #{$0} -f filename.txt -s search,words,go,here"
      return 1
    end
    EventMachine.run do
      args.each do |path|
        EventMachine::file_tail(path, Reader)
      end
    end
  end # def main

  exit(main(ARGV))