require 'cgi'
require 'net/http'
require 'tempfile'

module Acapela
  class Response

    attr_reader :id,
                :time,
                :size,
                :url

    RESPONSE_STATE = 'res'
    RESPONSE_STATE_REGEXP = /#{RESPONSE_STATE}=/
    RESPONSE_SOUND_URL = 'snd_url'
    RESPONSE_STATE_OK = 'OK'
    RESPONSE_ERROR_MESSAGE = 'err_msg'
    RESPONSE_ERROR_CODE = 'err_code'

    ERROR_UNEXPECTED_RESPONSE = ServiceError.new("Unexpected response.")
    ERROR_MISSING_SOUND_URL = ServiceError.new("Parameters are missing sound url.")

    def initialize(response)
      if RESPONSE_STATE_REGEXP.match(response)
        params = CGI::parse(response)
      else
        raise ERROR_UNEXPECTED_RESPONSE
      end

      if RESPONSE_STATE_OK == params[RESPONSE_STATE].first
        if url = params[RESPONSE_SOUND_URL]
          @url = URI.parse(url.first)
          @id = params['snd_id'].first
          @time = params['snd_time'].first.to_f
          @size = params['snd_size'].first.to_i
        else
          raise ERROR_MISSING_SOUND_URL
        end
      else
        raise ServiceError.new(params[RESPONSE_ERROR_MESSAGE].first, params[RESPONSE_ERROR_CODE].first)
      end
    end

    def download_to_tempfile
      content = fetch_file_from_url
      file = Tempfile.new(self.id)
      file.write(content)
      file.flush
      file # Leaving open. Will be closed once object is finalized.
    end

    private

    def fetch_file_from_url
      response = Net::HTTP.get_response(self.url)
      if 200 == response.code.to_i
        response.body
      else
        raise Error.new("Download failed with status: #{response.code}.")
      end
    end

  end
end
