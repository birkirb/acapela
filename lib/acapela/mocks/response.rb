module Acapela
  class Response

    def self.mock_on
      self.class_eval(<<-EVAL, __FILE__, __LINE__)
       def fetch_file_from_url
         fetch_file_from_url_with_mock
       end
      EVAL
    end

    def self.mock_off
      self.class_eval(<<-EVAL, __FILE__, __LINE__)
       def fetch_file_from_url
         fetch_file_from_url_without_mock
       end
      EVAL
    end

    private

    alias :fetch_file_from_url_without_mock :fetch_file_from_url

    def fetch_file_from_url_with_mock
      File.read(Acapela::Mocks::RESPONSE_TEST_FILE)
    end

  end
end
