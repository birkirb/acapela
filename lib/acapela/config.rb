require 'yaml'
require 'uri'

module Acapela
  class Config
    attr_reader :application,
                :version,
                :environment,
                :login,
                :password,
                :protocol,
                :target_url

    DEFAULT_PROTOCOL = '2'
    DEFAULT_VERSION = '1-30'
    DEFAULT_TARGET_URL = 'http://vaas.acapela-group.com/Services/Synthesizer'

    def initialize(login, application, password, target_url = nil, version = nil, protocol = nil)
      @login = login
      @application = application
      @password = password
      @protocol = protocol || DEFAULT_PROTOCOL
      @version = version || DEFAULT_VERSION
      @target_url = URI.parse(target_url || DEFAULT_TARGET_URL)
    end

    def self.read(config_file = nil)
      config_file ||= File.join('config', 'acapela.yml')
      begin
        yaml = YAML.load_file(config_file)
        self.new(yaml['login'], yaml['application'], yaml['password'], yaml['target_url'] , yaml['version'], yaml['protocol'])
      rescue => err
        raise Error.new("Failed to read configuration file", err)
      end
    end

  end
end
