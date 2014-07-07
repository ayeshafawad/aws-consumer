class PostExampleController < ActionController::Base

  def create
    received_body = JSON.parse request.body.read.to_s.strip
    received_token = received_body["Token"] unless received_body.blank?
    puts "Received request body: \n#{received_body.inspect}"
    puts "Received token: #{received_token}" unless received_token.blank?
    render :confirm, status: :ok
  end

  def confirm
  end
  
end

