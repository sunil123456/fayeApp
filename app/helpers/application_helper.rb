module ApplicationHelper
	def broadcast(channel, &block)
		  message = {:channel => channel, :data => capture(&block),:ext => {:auth_token => FAYE_TOKEN}}
		  # uri = URI.parse("http://localhost:9292/faye")
		  uri = URI.parse("http://ec2-18-222-195-118.us-east-2.compute.amazonaws.com/faye")
		  Net::HTTP.post_form(uri, :message => message.to_json)
	end
end
