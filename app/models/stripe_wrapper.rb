module StripeWrapper
  class Charge
    attr_reader :response, :status 

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      begin
        response =  Stripe::Charge.create(
        amount: options[:amount],
        currency: 'usd',
        card: options[:card]) 

        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end

  class Customer
    attr_reader :response, :status

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {}) 
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: options[:plan],
          email: options[:email],
          description: "Payment for #{options[:email]}"
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e, :failed)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response.message
    end
  end
end
