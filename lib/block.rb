require 'block/version.rb'
require 'block/reader.rb'
require 'redis'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

def check_for_redis(args)
  uri = URI.parse(args[:redis])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  begin
    $redis.ping
    true
  rescue
    help_now!("######### WARNING: Redis needs to be running. #########")
    false
  end
end

def check_for_file(args)
  if args[:file].nil?
    help_now!("Need a filename.") 
  else
    file = File.join(Dir.pwd,args[:file])
    if File.exist?(file)
      true
    else
      help_now!("File needs to exist.") 
    end
  end
end

def check_for_searches(args)
  if args[:search].nil?
    help_now!("Need some searches - separated by commas.") 
  else
    true
  end
end