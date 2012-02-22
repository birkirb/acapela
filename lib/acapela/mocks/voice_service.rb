module Acapela
  class VoiceService
    include Acapela::Mocks

    @@expected_response = EXAMPLE_ACAPELA_RESPONSE_OK
    @@last_posted_params = nil

    def self.expected_response
      @@expected_response
    end

    def self.last_posted_params
      @@last_posted_params
    end

    def self.expect_ok_response
      @@expected_response = EXAMPLE_ACAPELA_RESPONSE_OK
    end

    def self.expect_invalid_param_response
      @@expected_response = EXAMPLE_ACAPELA_RESPONSE_INVALID_PARAM
    end

    def self.expect_access_denied_response
      @@expected_response = EXAMPLE_ACAPELA_RESPONSE_ACCESS_DENIED
    end

    private

    def post(params)
      @@last_posted_params = params
      self.class.expected_response
    end

  end
end
