require 'listen'
require 'mail'
require 'dotenv'

path =  File.dirname(__FILE__)
Dotenv.load(path+'/.env')

# this is myserver.rb
# it does nothing really useful at the moment

listener = Listen.to('/home/guest') do |modified, added, removed| 
  puts added 
  puts ENV['RECEIVER']
  mail = Mail.new do
    to ENV['RECEIVER']
    from 'notify@partsable.com'
    subject 'testing'
    body "File #{added} had been added"
  end
  mail.deliver!
end

loop do
  if listener.processing?
    puts "Listener processing ..."
  else
    puts "Listener starting ..."
    listener.start
  end 
  sleep(5)
end