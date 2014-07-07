require "net/https"

class PostExampleController < ActionController::Base

  def create
    received_body = JSON.parse request.body.read.to_s.strip
    puts "Received body: #{received_body}" unless received_body.blank?

    received_message_type = received_body["Type"]
    if received_message_type == "SubscriptionConfirmation"
      
      #received_token = received_body["Token"] unless received_body.blank?   
      #topic_arn = received_body["TopicArn"] unless received_body.blank?   
      #puts "Received token: #{received_token}" unless received_token.blank?
      #puts "Received topic arn: #{topic_arn}" unless topic_arn.blank?
      confirmation_url = received_body["SubscribeURL"]
      puts "Send request to outbound URL: #{confirmation_url}"
      uri = URI.parse confirmation_url
      puts "Parsing URI into: #{uri.host}"
      http_request = Net::HTTP::Post.new(uri.request_uri)
      #puts "HTTP request created" if http_request
      
      #uri.port = Net::HTTP.https_default_port()
      puts "URI port: #{uri.port}"
      puts "URI host: #{uri.host}"
      #http = Net::HTTP.new(uri.host, uri.port).start 
      #request = Net::HTTP::Post.new(uri.request_uri)

      #response = http.request(http_request)
      #response = http.request(Net::HTTP::Get.new(uri.request_uri))
      

      #response = http.request(http_request)
      #puts "Response from AWS:\n #{response}"

      response_received = Net::HTTP.new(uri.host, uri.port).start do |http|
         http.use_ssl = true
         http.verify_mode = OpenSSL::SSL::VERIFY_NONE
         response = http.request(http_request)
      end

      puts "Response code received from endpoint:\n #{response_received.code}"
      puts "Response body received from endpoint:\n #{response_received.body.presence}"

    elsif received_message_type == "Notification"
      message_subject = received_body["Subject"]
      message_received = received_body["Message"]
      message_id = received_body["MessageId"]
      puts "Message received from AWS Topic. Id:#{message_Id}, Subject:#{message_subject}, Message:#{message_received}"
    end
    render :nothing, status: :ok
  end  
end

