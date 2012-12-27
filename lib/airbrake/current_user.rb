module Airbrake
  module CurrentUser

    def self.filtered_attributes_config
      %W[password token login sign_in per_page _at passphrase _key]
    end

    # Returns filtered attributes for current user
    def self.filtered_attributes(controller)
      return {} unless controller.respond_to?(:current_user, true)
      begin
        user = controller.send(:current_user)
      rescue
        # If something goes wrong (perhaps while running rake airbrake:test),
        # use the first User.
        user = User.first
      end
      # Return empty hash if there are no users.
      return {} unless user && user.respond_to?(:attributes)

      # Removes auth-related fields
      config = filtered_attributes_config
      attributes = user.attributes.reject do |k, v|
        config.any?{|e|k.end_with?(e)}
      end
      # Try to include a URL for the user, if possible.
      if url_method = [:user_url, :admin_user_url].detect {|m| controller.respond_to?(m) }
        attributes[:url] = controller.send(url_method, user)
      end
      # Return all keys with non-blank values
      attributes.select {|k,v| v.present? }
    end

  end
end
