require 'spec_helper'

describe Acapela::Voice do

  context 'When created' do
    speaker_name = 'tom'
    test_voice = Acapela::Voice.new(speaker_name, Acapela::Voice::GENDER_FEMALE)

    it 'with name and gender should report default values' do
      test_voice.speaker.should == speaker_name
      test_voice.gender.should == Acapela::Voice::GENDER_FEMALE
      test_voice.quality.should == Acapela::Voice::QUALITY_HIGH
      test_voice.languages.should be_kind_of(Set)
      test_voice.languages.should be_empty
      test_voice.language.should be_nil
      test_voice.id.should == "#{speaker_name}#{test_voice.quality}"
    end

    it 'should allow flipping quality setting' do
      test_voice.low_quality!
      test_voice.quality.should == Acapela::Voice::QUALITY_LOW
      test_voice.high_quality!
      test_voice.quality.should == Acapela::Voice::QUALITY_HIGH
    end
  end

  context 'With a set of defined voices' do
    it 'should throw an error if the voice does not exist' do
      expect do
        Acapela::Voice.named_voice('Birkir')
      end.to raise_error(Acapela::Error, "Voice does not exist.")
    end

    it 'should return the active voice map' do
      Acapela::Voice.map.should == Acapela::Voices::PER_LANGUAGE
    end

    context 'should find a voice' do
      it 'given an existing speaker name' do
        voice = Acapela::Voice.named_voice('Tracy')
        voice.speaker.should == 'Tracy'
        voice.language.should == 'en'
        voice.gender.should == Acapela::Voice::GENDER_FEMALE
        voice.languages.should == Set.new('en')
        voice.id.should == 'tracy22k'
      end

      it 'given an existing speaker name in lower case' do
        voice = Acapela::Voice.named_voice('bruno')
        voice.speaker.should == 'Bruno'
        voice.gender.should == Acapela::Voice::GENDER_MALE
        voice.language.should == 'fr'
      end

      it 'given an existing speaker name as a symbol' do
        voice = Acapela::Voice.named_voice(:rosa)
        voice.speaker.should == 'Rosa'
        voice.gender.should == Acapela::Voice::GENDER_FEMALE
        voice.language.should == 'es'
      end
    end

    context 'should extract a voice when given an option that' do
      it 'specifies nothing, defaulting to English' do
        voice = Acapela::Voice.extract_from_options
        ['Tracy', 'Heather', 'Kenny'].should include(voice.speaker)
      end

      it 'specifies a speaker' do
        voice = Acapela::Voice.extract_from_options(:speaker => 'antoine')
        voice.speaker.should == 'Antoine'
        voice.gender.should == Acapela::Voice::GENDER_MALE
        voice.language.should == 'fr'
      end

      it 'specifies a language' do
        voice = Acapela::Voice.extract_from_options(:language => :es)
        voice.speaker.should == 'Rosa'
      end

      it 'specifies a language and no gender' do
        voice = Acapela::Voice.extract_from_options(:language => :fr)
        voice.should_not be_nil
        ['Antoine', 'Bruno'].should include(voice.speaker)
      end

      it 'specifies a language and gender' do
        voice = Acapela::Voice.extract_from_options(:language => :es, :gender => Acapela::Voice::GENDER_FEMALE)
        voice.speaker.should == 'Rosa'

        voice = Acapela::Voice.extract_from_options(:language => :es, :gender => Acapela::Voice::GENDER_MALE)
        voice.should be_nil
      end
    end
  end

  context 'Allows for voices to be overriden or changed' do
    after(:each) do
      Acapela::Voice.reset_map
    end

    it 'should allow removing specific entries' do
      Acapela::Voice.map[:en][:male].first.should == 'Kenny'
      Acapela::Voice.override_map(:en => nil)
      Acapela::Voice.map[:en].should be_nil
    end

    it 'should allow mapping one entry to another' do
      Acapela::Voice.map[:en][:male].first.should == 'Kenny'
      Acapela::Voice.override_map(:en => :fr)
      Acapela::Voice.map[:en][:male].first.should == 'Antoine'
    end

    it 'should allow replacing an entry' do
      Acapela::Voice.map[:en][:male].first.should == 'Kenny'
      Acapela::Voice.override_map(:en => {:male => ['Johnny']})
      Acapela::Voice.map[:en][:male].should == ['Johnny']
      Acapela::Voice.map[:en][:female].first.should == 'Tracy'
    end

    it 'should allow adding an entry' do
      Acapela::Voice.map[:is].should be_nil
      Acapela::Voice.override_map(:is => {:male => ['Birkir'], :female => ['Harpa']})
      Acapela::Voice.map[:is][:male].first.should == 'Birkir'
      Acapela::Voice.map[:is][:female].first.should == 'Harpa'
    end
  end
end
