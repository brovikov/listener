# this is myserver_control.rb
require 'daemons'
options = {
  :log_output => true,
  :backtrace => true,
  :multiple => true,
  :output_logfilename => "log/listner_output.log",
  :logfilename => "log/listner.log"
}

Daemons.run('listner.rb', options)