require 'spec_helper'

describe Acapela do
  it 'should reference a config file' do
    config = Acapela.config

    config.should_not be_nil
    config.should be_a_kind_of(Acapela::Config)
  end

end
