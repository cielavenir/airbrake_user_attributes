require 'airbrake/rails/javascript_notifier'

module Airbrake
  module Rails
    module JavascriptNotifier
      private

      def airbrake_javascript_notifier_options_with_user_attributes
        options=airbrake_javascript_notifier_options_without_user_attributes
        options[:locals][:user_attributes]=Airbrake::CurrentUser.filtered_attributes(self)
        options
      end
      alias_method_chain :airbrake_javascript_notifier_options, :user_attributes

    end
  end
end
