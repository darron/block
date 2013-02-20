require 'block/version.rb'
require 'redis'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

def setup_redis
  begin
    $redis = Redis.new
    $redis.ping
  rescue
    puts "######### WARNING: Redis needs to be running. #########"
    false
  end
end