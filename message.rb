require 'rubygems'
require 'sinatra/activerecord'
require 'twilio-ruby'
require 'json'

require './db/config'
require './includes/call'
require './includes/trivia'
require './includes/twilio'

file    = File.absolute_path('./db/numbers.json')
numbers = JSON.parse(File.read(file))
winners = JSON.parse(File.read('./db/winners.json'))

client  = Twilio::REST::Client.new account_sid, auth_token
from    = "+16613798663"

calls = Call.order("question ASC, created_at ASC")
calls.each do |call|
  number  = call[:contact_number]
  formatted_number = call.contact_number

  if number.length == 7
    number = "661#{number}"
  end

  next if number.length != 10

  unless numbers.include?(number) || winners.include?(number)
    numbers << number

    client.account.sms.messages.create(
      :from => from,
      :to => number,
      :body => "Thanks for playing! Sadly someone was a bit faster. If you'd like to buy a discounted Fight For Life ticket, please call 661-837-0477 by 5PM."
    )

    puts "Sent message to #{number}"
  end
end

File.open(file, 'w') do |f|
 f.puts JSON.dump(numbers)
end
