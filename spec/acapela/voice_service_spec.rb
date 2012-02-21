require 'spec_helper'

describe Acapela::VoiceService do

  text_string = 'This is a test'
  mock_service = true

  context 'When create without parameters' do
    service = Acapela::VoiceService.new

    it 'should use the default config' do
      service.config.should be_kind_of(Acapela::Config)
      service.config.should == Acapela.config
    end

    it 'should allow generation of MP3 sound' do
      service.stubs(:post => EXAMPLE_ACAPELA_RESPONSE_OK) if mock_service
      sound_url = service.generate_sound(text_string, :language => :en)
      sound_url.should be_kind_of(Acapela::Response)
    end
  end

  it 'should throw an error when created with nil config' do
    expect do
      service = Acapela::VoiceService.new(nil)
    end.to raise_error(Acapela::Error, Acapela::VoiceService::ERROR_MISSING_CONFIG.message)
  end

  context 'When created with config with invalid login/password' do
    service = Acapela::VoiceService.new(Acapela::Config.read(test_config))

    it 'should raise the reported access error' do
      service.stubs(:post => EXAMPLE_ACAPELA_RESPONSE_ACCESS_DENIED) if mock_service
       expect do
         service.generate_sound(text_string, :language => :en)
       end.to raise_error(Acapela::ServiceError, "Code: ACCESS_DENIED_ERROR, Message: Invalid identifiers")
    end
  end

  context 'When generating sound' do
    it 'should allow low quality setting' do
      service = Acapela::VoiceService.new
      service.expects(:post).once.returns(EXAMPLE_ACAPELA_RESPONSE_OK).with do |params|
        params[:req_voice].should == 'tracy8k'
        true
      end
      service.generate_sound(text_string, :speaker => 'tracy', :quality => :low)
    end

    it 'should allow custom voice setting' do
      service = Acapela::VoiceService.new
      service.expects(:post).once.returns(EXAMPLE_ACAPELA_RESPONSE_OK).with do |params|
        params[:req_voice].should == 'johnny22k'
        true
      end
      voice = Acapela::Voice.new('johnny', :male, 'en')
      service.generate_with_voice(text_string, voice)
    end
  end

end
