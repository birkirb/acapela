require 'spec_helper'

describe Acapela::Config, 'When created' do

  default_config = YAML.load_file('config/acapela.yml')
  default_config['login'].should_not == nil
  default_config['application'].should_not == nil
  default_config['password'].should_not == nil

  context 'with a given login, application and password' do
    it 'should report those and other default values' do
      config = Acapela::Config.new(default_config['login'], default_config['application'], default_config['password'])
      config.version.should == Acapela::Config::DEFAULT_VERSION
      config.protocol.should == Acapela::Config::DEFAULT_PROTOCOL
      config.target_url.should == URI.parse(Acapela::Config::DEFAULT_TARGET_URL)
      config.environment.should be_nil

      config.login.should == default_config['login']
      config.application.should == default_config['application']
    end
  end

  context 'from a config file' do
    it 'should default to the local config/acapela.yml' do
      config = Acapela::Config.read
      config.login.should == default_config['login']
      config.application.should == default_config['application']
    end

    it 'should accept an arbitary config file argument' do
      config = Acapela::Config.read(test_config)
      config.login.should_not be_nil
      config.application.should_not be_nil

      config.login.should_not == default_config['login']
      config.application.should_not == default_config['application']
    end
  end

end
