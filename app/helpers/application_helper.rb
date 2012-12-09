module ApplicationHelper

	#used for the avatar of a user
	#at this point, this function is not used; instead, we just use the 
	#specified default url
  def avatar_url(user)
    default_url = "#{root_url}/images/jamessmall.jpg"
    gravatar_id = Digest::MD5::hexdigest(user.email).downcase
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
  end

  










end
