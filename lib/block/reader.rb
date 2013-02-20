require 'eventmachine'
require 'eventmachine-tail'

class Reader < EventMachine::FileTail
  def initialize(path, startpos=-1)
    super(path, startpos)
    @buffer = BufferedTokenizer.new
  end
  
  def log_search(line, pattern)
     if line.split(' ').grep(/#{pattern}/).length > 0
       array = line.split(" ")
       count = $redis.incr array.first.to_s
       $redis.expire array.first.to_s, $options[:expiry]
       puts "\nIP: #{array.first.to_s} on #{pattern} (#{count})"
       if (count > $options[:threshold])
         firewall(array.first.to_s)
       end
     else
       print "."
     end
   end

   def receive_data(data)
     @buffer.extract(data).each do |line|
       $search.each do |search|
         puts "Search: #{line} with #{search}"
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
         #system "/sbin/iptables -I INPUT -s #{ip} -j DROP"
         $redis.sadd "ips", "#{ip}"
       end
     end
   end

# def main(args)
#   EventMachine.run do
#     args.each do |path|
#       EventMachine::file_tail(path, Reader)
#     end
#   end
# end # def main