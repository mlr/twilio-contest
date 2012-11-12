require 'sinatra'
require 'sinatra/activerecord'
require 'twilio-ruby'

require './db/config'
require './includes/call'
require './includes/trivia'
require './includes/twilio'

get '/' do
  redirect "http://fightforlifeevent.org"
end

post '/' do
  response = Twilio::TwiML::Response.new do |r|
    r.Say "Sorry, the fight for life contest has not yet begun."
    r.Say "Watch our facebook page for the announcement."
  end
  response.text
end

post %r{/(\d+)} do
  question_index = params[:captures].first.to_i
  trivia = Trivia::Question(question_index)

  response = Twilio::TwiML::Response.new do |r|
    # No numbers were pressed, so this is the initial connection/call
    if !params[:Digits]
      r.Say "Thanks for playing the Fight for Life contest. Get ready."
      r.Say trivia[:question]
    end

    # No numbers pressed yet OR number 5 pressed to repeat choices
    if !params[:Digits] || params[:Digits] == "5"
      r.Gather numDigits: 1, timeout: 90, method: "POST" do
        trivia[:answers].each_with_index do |answer,index|
          lang = "en"
          lang = "es" if answer =~ /^El/
          r.Say "#{answer}", language: lang
          r.Say "Press #{index+1}"
        end

        r.Say "Please press 1 through 4 to answer. To hear the choices again, press 5."
      end
    end

    # A choice number (1-4) was pressed
    if (1..4).include?(params[:Digits].to_i)
      r.Say "You pressed number #{params[:Digits]}."

      # Correct answer
      if params[:Digits] == (trivia[:correct_answer] + 1).to_s
        r.Say "Congratulations! That is the correct answer."
        r.Redirect "/collect?question=#{question_index+1}", method: "POST"

      # Incorrect answer
      else
        r.Say "Sorry, that is not correct."
        r.Say "Please call back if you'd like to try again!"
        r.Hangup
      end

    # Number 5 pressed to hear choices again OR no number pressed
    elsif params[:Digits] == "5" || (params[:Digits].nil? && params[:restart].nil?)
      # Redirect with a restart flag. Prevents user from just holding the line open.
      r.Redirect "/?restart=1", method: "POST"
    end

    # If for some reason we still get here, just end the call
    r.Say "Thank you for playing. Goodbye."
  end

  response.text
end

post '/collect' do
  response = Twilio::TwiML::Response.new do |r|
    # Find the call in case the caller is trying to update their contact number
    call = Call.find_by_call_sid(params[:CallSid])

    if call.nil?
      # Record the user's information now, in case they hang up
      call = Call.create({
              call_sid: params[:CallSid],
          phone_number: params[:Caller],
        contact_number: params[:Caller],
              question: params[:question]
      })
    end

    # No digits so this is the first entrance into this method
    if params[:Digits].nil? || params[:Digits] == ""
      r.Say "If you are the winner, we will call you at #{params[:Caller].split("").join(" ")}."
      r.Gather numDigits: 1, timeout: 10, method: "POST" do
        r.Say "Press 1 if you would like to leave a different call-back number."
      end

    # Caller pressed "1" to enter a new phone number
    elsif params[:Digits] == "1"
      r.Gather timeout: 30, method: "POST" do
        r.Say "Please enter the phone number we should contact you at."
        r.Say "Press pound when finished."
      end

    # We either have a new phone number, or the user didn't provide one
    else
      if !params[:Digits].nil?
        # Phone number provide was not valid
        if params[:Digits].length < 7
          r.Say "That is not a valid phone number. Please try again."
          r.Redirect "/collect?question=#{params[:question]}&Digits=1", method: "POST"

        # Update database with new number
        else
          # Record the new phone number
          call = Call.find_by_call_sid(params[:CallSid])
          if call
            call.contact_number = params[:Digits]
            call.save
          end

          r.Say "OK, we will contact you at #{params[:Digits].split("").join("")}"
          r.Gather numDigits: 1, timeout: 15, method: "POST" do
            r.Say "If this is not correct, press 1 to change."
            r.Say "Otherwise, you may hang up. Thank you for playing."
          end
        end
      end
    end

    r.Say "Thank you for playing. Goodbye."
  end

  response.text
end

get '/results' do
  @calls = Call.order("question ASC, created_at ASC")
  erb :results
end
