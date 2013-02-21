block
=====

To install - first off make sure you have Redis available to you. Then:

    gem install block
    
From there, here's how you run it:

    NAME
        block - Ruby Gem to block IP addresses that are requesting URLs you determine are bad.

    SYNOPSIS
        block [global options] command [command options] [arguments...]

    VERSION
        0.0.9

    GLOBAL OPTIONS
        -d, --[no-]disable                 - Disable adding firewall rules
        -e, --expiry=10                    - Expiry time in seconds (default: 10)
        -f, --file=filename.txt            - The filename to watch (default: none)
        --help                             - Show this message
        -r, --redis=redis://127.0.0.1:6379 - Redis server location (default: redis://127.0.0.1:6379)
        -s, --search=passwd,acunetrix      - The searches - separated by commas. (default: none)
        -t, --threshold=30                 - Block threshold number (default: 30)
        --version                          - 

    COMMANDS
        help  - Shows a list of commands or help for one command
        watch - Watch and (optionally) block bad IP addresses

Monitor an Apache logfile and block IP addresses that are requesting pages that match strings you pass on the command line.

    block -f logfile-to-watch.txt -s passwd,acunetrix watch
  
We watch the logs and increment a counter each time there's a match for a particular IP address and string, once they hit a certain number of matches they're blocked using Linux's iptables.

If you're not sure whether it's tuned correctly, you can run it with the `-d` flag and watch what **would** happen.

Requires
--------

Ruby 1.8.7 or 1.9.x

Redis