require 'acapela/mocks/constants'

module Acapela
  class VoiceService
    include Acapela::Mocks

    attr_accessor :expected_response, :posted_params

    def expect_ok_response
      @expected_response = EXAMPLE_ACAPELA_RESPONSE_OK
    end

    def expect_invalid_param_response
      @expected_response = EXAMPLE_ACAPELA_RESPONSE_INVALID_PARAM
    end

    def expect_access_denied_response
      @expected_response = EXAMPLE_ACAPELA_RESPONSE_ACCESS_DENIED
    end

    private

    def post(params)
      @posted_params = params
      @expected_response || EXAMPLE_ACAPELA_RESPONSE_OK
    end

  end
end
