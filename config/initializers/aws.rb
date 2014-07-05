# # setting up global variable with an instance of the S3 interface
	$s3 = AWS::S3.new(
	  :access_key_id => "AKIAJWDPVFWLNP5AAIFA",
	  :secret_access_key => "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")

	$ses = AWS::SimpleEmailService.new(
	  :access_key_id => "AKIAJWDPVFWLNP5AAIFA",
	  :secret_access_key => "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")

	$r53 = AWS::Route53.new(
	  :access_key_id => "AKIAJWDPVFWLNP5AAIFA",
	  :secret_access_key => "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")

	$dynamodb = AWS::DynamoDB.new(
	  :access_key_id => "AKIAJWDPVFWLNP5AAIFA",
	  :secret_access_key => "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")

	# $dynamodbclient = AWS::DynamoDB::Client.new(
 	#        :access_key_id => ENV["S3_ACCESS_KEY"],
 	#        :secret_access_key => ENV["S3_SECRET_KEY"])

	# $dynamodb = AWS::DynamoDB::Client.new(
	#   :access_key_id => ENV["S3_ACCESS_KEY"],
	#   :secret_access_key => ENV["S3_SECRET_KEY"])

	AWS.config(
	  :region => 'us-east-1',
	  :ses => { :region => 'us-east-1' }
	)

# $bucket = $s3.buckets['S3_ayesha_bucket']