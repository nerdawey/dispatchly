ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def setup_auth_headers(user)
      # Ensure we have a valid secret key base in test environment
      Rails.application.credentials.secret_key_base ||= SecureRandom.hex(64)
      token = JsonWebToken.encode(user_id: user.id)
      { "Authorization" => "Bearer #{token}" }
    end
  end
end
