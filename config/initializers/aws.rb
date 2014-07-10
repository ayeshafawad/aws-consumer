# # setting up global variable with an instance of the S3 interface
	$s3 = AWS::S3.new(
	  		:access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

	$ses = AWS::SimpleEmailService.new(
	  		:access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

	$r53 = AWS::Route53.new(
	  		:access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

	$dynamodb = AWS::DynamoDB.new(
	  		:access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

    $dynamodbclient = AWS::DynamoDB::Client.new(
 	        :access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

    $iam = AWS::IAM.new(
 	        :access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

    $eb = AWS::IAM.new(
 	        :access_key_id => ENV["S3_ACCESS_KEY"],
 	        :secret_access_key => ENV["S3_SECRET_KEY"])

	AWS.config(
	  :region => 'us-east-1',
	  :ses => { :region => 'us-east-1' }
	)

# $bucket = $s3.buckets['S3_ayesha_bucket']