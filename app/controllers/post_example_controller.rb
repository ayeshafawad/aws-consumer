class PostExampleController < ActionController::Base
  include AwsHelper

  def create
    received_token = retrieve_token(request.body.read.to_s.strip, "Token")
    received_topic_arn = retrieve_token(request.body.read.to_s.strip, "TopicArn")
    puts "Received token: #{received_token}" unless received_token.blank?
    puts "Received topic arn: #{received_topic_arn}" unless received_topic_arn.blank?
    confirmation_url = construct_url("ConfirmSubscription", received_topic_arn, received_token)
    puts "Send request to outbound URL: #{confirmation_url}"
    response_received = send_confirmation_subscription(confirmation_url)
    puts "Responses received from endpoint:\n #{response_received}"
    render :confirm, status: :ok
  end  
end

