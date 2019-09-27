# frozen_string_literal: true

module Scholar
  # This object is used to inspect specific attributes of a user
  class UserAttributeService
    def initialize(user_params)
      @domain = Mail::Address.new(user_params[:email]).domain.to_s
      @parsed_domain = @domain.split('.')[-2]
      @rails_paths = Rails.application.routes.url_helpers
    end

    def email_redirect_path
      domain_hash[@parsed_domain]
    end

    private

    def domain_hash
      {
        # oregonstate: @rails_paths.new_osu_session_path.to_s,
        # orst: @rails_paths.new_osu_session_path.to_s,
        colorado: @rails_paths.new_cu_session_path.to_s
      }.with_indifferent_access
    end
  end
end
