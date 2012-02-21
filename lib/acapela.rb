require 'acapela/error'
require 'acapela/config'
require 'acapela/voices/default'
require 'acapela/voice'
require 'acapela/constants'
require 'acapela/response'
require 'acapela/voice_service'

module Acapela

  @@config = Acapela::Config.read rescue nil

  def self.config
    @@config
  end

end
