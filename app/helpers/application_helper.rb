module ApplicationHelper
	def broadcast_message(channel, content)
		PrivatePub.publish_to channel, content
		#   message = {:channel => channel, :data => capture(&block),:ext => {:auth_token => FAYE_TOKEN}}
		#   uri = URI.parse("#{ENV['FAYURL']}faye")
		#   Net::HTTP.post_form(uri, :message => message.to_json)
	end
end
