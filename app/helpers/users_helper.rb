module UsersHelper

  # Gravatar URIs are based on an MD5 hash of the user’s email address. In Ruby,
  # the MD5 hashing algorithm is implemented using the hexdigest method, which is
  # part of the Digest library. Returns the Gravatar (http://gravatar.com/) for
  # the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
