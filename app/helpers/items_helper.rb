module ItemsHelper
	def sanitize_key key
		key.gsub(".", "$")
	end

	def unsanitize_key key
		key.gsub("$", ".")
	end

end
