require 'listen'
require 'mail'
require 'dotenv'
require 'byebug'

module Listner

  path =  File.dirname(__FILE__)
  Dotenv.load(path+'/.env')

  # this is myserver.rb
  # it does nothing really useful at the moment

  listener = Listen.to('/home/guest') do |modified, added, removed| 
    puts added
    if added.count > 0
      added.each do |file|
        puts ENV['RECEIVER']
        time = 0
        until `lsof | grep #{file}`.empty? do
          sleep 1
          puts "Waiting until file uploading #{time} sec ... "
          time += 1
        end
        time = 0
        puts "File downloaded successfully!"
        mail = Mail.new do
          to ENV['RECEIVER']
          from 'notify@partsable.com'
          subject "File #{file} has been added on #{Time.new.strftime("%m/%d/%Y at %I:%M%p")}"
          body "Some description for #{file}"
          add_file :filename => file.split('/').last, :content => File.read(file)
        end
        #Port 8025, 587 and 25 can also be used.
        smtp = Net::SMTP.new('smtpcorp.com', 2525)
        smtp.enable_starttls_auto
        smtp.start( 
          ENV['SMTPDOMAIN'], 
          ENV['SMTPUSERNAME'], 
          ENV['SMTPPASSWORD'], 
          :plain
        )
        smtp.send_message(mail.to_s, 'notify@partsable.com', ENV['RECEIVER'])
      end
    end
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

end
