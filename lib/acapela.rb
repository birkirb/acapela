require 'acapela/error'
require 'acapela/config'
require 'acapela/voices/default'
require 'acapela/voice'
require 'acapela/constants'
require 'acapela/response'
require 'acapela/voice_service'

if RUBY_VERSION < "1.9"
  require 'backports'
end

module Acapela

  def self.config
    @@config ||= Acapela::Config.read rescue nil
  end

  def self.config=(config)
    if config.is_a?(Acapela::Config)
      @@config = config
    else
      raise Error.new("Acapela configuration required. Not #{config.class}")
    end
  end

end
