require "block/version"
require "rubygems"
require "eventmachine"
require "eventmachine-tail"
require 'redis'

module Block
  class Reader < EventMachine::FileTail
    def initialize(path, startpos=-1)
      super(path, startpos)
      puts "Tailing #{path}"
      @buffer = BufferedTokenizer.new
      $redis = Redis.new
      @expiry_time = 10
      @magic_number = 30
    end

    def log_search(line, pattern)
      if line.grep(/#{pattern}/).length > 0
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
        # Do all your fun text mangling here.
        log_search(line, "POST")
        log_search(line, "acunetix")
        log_search(line, "passwd")
        log_search(line, "SomeCustomInjectedHeader")
      end
    end

    def firewall(ip)
      # /sbin/iptables -I INPUT -s {ip} -j DROP
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
      puts "Usage: #{$0} <path> [path2] [...]"
      return 1
    end

      EventMachine.run do
        args.each do |path|
          EventMachine::file_tail(path, Reader)
        end
      end
    end # def main

    exit(main(ARGV))
end
