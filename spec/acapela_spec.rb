require 'spec_helper'

describe Acapela do
  it 'should reference a config file' do
    config = Acapela.config

    config.should_not be_nil
    config.should be_a_kind_of(Acapela::Config)
  end

  it 'should allow setting of the config file' do
    default_config = Acapela.config

    begin
      test_config = Acapela::Config.read(test_config)

      Acapela.config = test_config
      Acapela.config.should == test_config
    ensure
      Acapela.config = default_config
    end
  end

end
