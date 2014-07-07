require 'open-uri'

module AwsHelper

	def construct_url action, topic_arn, token
		"https://sns.us-east-1.amazonaws.com/?Action=#{action}&TopicArn=#{topic_arn}&Token=#{token}"
	end

	def send_confirmation_subscription confirm_url
		content = open(confirm_url).read
		content
	end

	def retrieve_token response_body, token_name		
		received_body = JSON.parse response_body
		return nil if received_body.blank?
		received_token = received_body[token_name] unless received_body.blank?   
		received_token 
	end

end
