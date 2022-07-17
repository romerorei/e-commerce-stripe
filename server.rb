# server.rb
#
# Use this sample code to handle webhook events in your integration.
#
# 1) Paste this code into a new file (server.rb)
#
# 2) Install dependencies
#   gem install sinatra
#   gem install stripe
#
# 3) Run the server on http://localhost:4242
#   ruby server.rb

require 'json'
require 'sinatra'
require 'stripe'

# This is your Stripe CLI webhook secret for testing your endpoint locally.
endpoint_secret = 'whsec_2111a0771c47dbeb9de16bdfa02da7a89342d00a1b22666ecbbd48b917476973'

set :port, 4242

post '/webhook' do
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
        event = Stripe::Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
    rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
    rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        status 400
        return
    end

    # Handle the event
    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      puts "event.type --> #{event.type}"
      puts "event.data --> #{event.data}"
      puts "event.data.object --> #{event.data.object}"
    when 'payment_intent.created'
      payment_intent = event.data.object
      puts "event.type --> #{event.type}"
      puts "event.data --> #{event.data}"
      puts "event.data.object --> #{event.data.object}"
    when 'payment_intent.payment_failed'
      payment_intent = event.data.object
      puts "event.type --> #{event.type}"
      puts "event.data --> #{event.data}"
      puts "event.data.object --> #{event.data.object}"
    when 'charge.succeeded'
      payment_intent = event.data.object
      puts "event.type --> #{event.type}"
      puts "event.data --> #{event.data}"
      puts "event.data.object --> #{event.data.object}"
    # ... handle other event types
    else
        puts "Unhandled event type: #{event.type}"
        payment_intent = event.data.object
        puts "event.type --> #{event.type}"
        puts "event.data --> #{event.data}"
        puts "event.data.object --> #{event.data.object}"
    end

    status 200
end
