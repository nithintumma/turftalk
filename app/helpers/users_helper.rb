module UsersHelper
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag("james.jpg", :alt => user.firstname,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end

end
