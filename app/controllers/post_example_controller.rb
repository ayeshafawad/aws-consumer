class PostExampleController < ActionController::Base
  def create
    received_body = JSON.parse request.body.read.to_s.strip
    puts "Received body: #{received_body}" unless received_body.blank?
    received_token = received_body["Token"] unless received_body.blank?   
    topic_arn = received_body["TopicArn"] unless received_body.blank?   
    puts "Received token: #{received_token}" unless received_token.blank?
    puts "Received topic arn: #{topic_arn}" unless topic_arn.blank?
    confirmation_url = "https://sns.us-east-1.amazonaws.com/?Action=ConfirmSubscription&TopicArn=#{topic_arn}&Token=#{received_token}"
    puts "Send request to outbound URL: #{confirmation_url}"
    response_received = open(confirmation_url).read
    puts "Responses received from endpoint:\n #{response_received}"
    render :confirm, status: :ok
  end  
end

