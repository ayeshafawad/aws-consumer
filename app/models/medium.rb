class Medium < ActiveRecord::Base

	# Paperclip
	# has_attached_file :asset,
	# 	:styles => {
	# 		:thumb => "100x100",
	# 		:small => "150x150",
	# 		:medium => "300x300",
	# 		:large => "600x600"
	# 		},
	# 	:storage => :s3,
	# 	:s3_credentials => "#{Rails.root}/config/s3.yml",
	# 	:path => "/media/:id/:style/:basename.:extension",
	# 	:whiny => false,
	# 	:processors => [:thumbnail],
	# 	:s3_protocol => "https"

	#validates_attachment_content_type :asset, content_type: ["image/jpeg", "image/png", "image/gif"]

end
