module UsersHelper
  #authenticates a user by looking up a certain email, checking if a user with 
  #that email exists, and checking if their hashed password is the same
  #as the supplied password
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  #performs authentication using a stored cookie for additional security
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  #defines a gravatar image for a given user; in this case, we are only using a default
  #image at this point
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag("james.jpg", :alt => user.firstname,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

end
