class WebhookController < ApplicationController
  protect_from_forgery except: :webhook

  def receive
    event_string = request.body.read
    puts event_string
    event = Stripe::Event.construct_from(
      JSON.parse(event_string, symbolize_names: true)
    )

    if event.type.include?('payment_intent')
      puts "estamos dentro de if"
      payment = event.data.object
      puts "buscnado la orden por stripe_payment_id..."
      order = Order.find_by(stripe_payment_id: payment.id)
      puts "esta es la orden encontrada #{order.id} | #{order.status}"
      order.update!(status: payment.status)
      puts "Orden actualizada #{order.id} | #{order.status}"
    end

    #render json: {}, status: 200
  end
end
