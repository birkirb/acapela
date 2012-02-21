require 'net/http'

module Acapela
  class VoiceService

    CLIENT_ENVIRONMENT = "RUBY_#{RUBY_VERSION}"

    ERROR_MISSING_CONFIG = Error.new("VoiceService requires configuration.")

    attr_reader :config

    def initialize(config = Acapela.config)
      if config.is_a?(Acapela::Config)
        @config = config
      else
        raise ERROR_MISSING_CONFIG
      end
    end

    def generate_sound(text, options = {})
      voice = Voice.extract_from_options(options)

      case options[:quality]
      when :low
        voice.low_quality!
      when :high
        voice.high_quality!
      end

      generate_with_voice(text, voice)
    end

    def generate_with_voice(text, voice)
      params = {
        :prot_vers => @config.protocol,
        :cl_env => CLIENT_ENVIRONMENT,
        :cl_vers => @config.version,
        :cl_login => @config.login,
        :cl_app => @config.application,
        :cl_pwd => @config.password,
        :req_type => 'NEW',
       #:req_snd_id => nil,
        :req_voice => voice.id,
        :req_text => text,
       #:req_vol => nil, # Volume: min = 50, default = 32768, max = 65535
       #:req_spd => nil, # Speed: min = 60, default = 180, max = 360
       #:req_vct => nil, # Shaping: min = 50, default = 100, max = 150
       # Equalizer:  min = -100, default = 0, max = 100
       #:req_eq1 => nil, # Band 275Hz
       #:req_eq2 => nil, # Band: 2.2kHz
       #:req_eq3 => nil, # Band: 5kHz
       #:req_eq4 => nil, # Band: 8.3kHz
       #:req_snd_type => 'MP3', # Sound file type: MP3, WAV, RAW
       #:req_snd_ext => '.mp3', # Sound file extentions: .mp3 .wav .raw
       #:req_snd_kbps => 'CBR_48', # Variable bit rate VBR_5 to VRB_9 (5 = max quality, 9 min) or Constant Bit Rate CBR_8,16,32,48
       #:req_alt_snd_type => 'MP3', # Alternative Sound file type: MP3, WAV, RAW
       #:req_alt_snd_ext => '.mp3', # Alternative Sound file extentions: .mp3 .wav .raw
       #:req_wp => nil,  # 'ON' to receive word file URL
       #:req_bp => nil, # 'ON' to receive bookmark file URL
       #:req_mp => nil,  # 'ON' to receive mouth file URL
       #:req_comment => '', Information to store about the operation.
       #:req_start_time => nil, # The start time of the request will be used to calculate the deadline for request treatment
       #:req_timeout => nil, # The time allocated to request treatment in seconds.
       #:req_asw_type => 'SOUND', # Type of response:
                                  #   "INFO", key/value params.
                                  #   "SOUND", sound bytes once genearted.
                                  #   "STREAM", bytes as they are generated.
       #:req_asw_as_alt_snd => 'no', # Receive alternative file as response.
       #:req_err_as_id3 => 'no', # Reveive errors encapsulated in ID3 tag of MP3.
       #:req_echo => '',  # Receive some creation request fields in response.
       #:req_asw_redirect_url => nil, # Redirect response to a different URL.
      }

      Response.new(post(params))
    end

    private

    def post(params)
      body = Net::HTTP.post_form(@config.target_url, params).body
    end

  end
end
