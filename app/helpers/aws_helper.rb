require 'open-uri'

module AwsHelper
	def send_confirmation_subscription confirm_url
		content = open(confirm_url).read
		content
	end
end
