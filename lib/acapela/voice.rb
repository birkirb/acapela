require 'set'

module Acapela
  class Voice
    attr_reader :languages, :speaker, :gender, :quality

    def initialize(speaker, gender, *languages)
      @speaker = speaker
      @gender = gender
      @quality = QUALITY_HIGH

      @languages = Set.new
      languages.each { |lang| @languages.add(lang) }
    end

    def id
      "#{speaker.downcase}#{quality}"
    end

    def language
      languages.first
    end

    def low_quality!
      @quality = QUALITY_LOW
    end

    def high_quality!
      @quality = QUALITY_HIGH
    end

    def self.extract_from_options(options)
      if speaker = options[:speaker]
        named_voice(speaker)
      else
        language = options[:language] || 'en'
        gender = options[:gender]
        speakers_for_language = Voices::PER_LANGUAGE[options[:language]]

        speakers = case gender
        when GENDER_FEMALE
          speakers_for_language[GENDER_FEMALE]
        when GENDER_MALE
          speakers_for_language[GENDER_MALE]
        else
          speakers_for_language[GENDER_FEMALE] +
            speakers_for_language[GENDER_MALE]
        end

        if speakers.empty?
          nil
        else
          named_voice(speakers.choice)
        end
      end
    end

    def self.named_voice(speaker)
      unless defined?(@@voices)
        @@voices = Hash.new
        Voices::PER_LANGUAGE.each do |language, voices|
          [GENDER_MALE, GENDER_FEMALE].each do |gender|
            voices[gender].each do |name|
              downcase_name = name.downcase.to_sym
              if @@voices[downcase_name].nil?
                @@voices[downcase_name] = Voice.new(name, gender, language.to_s)
              else
                @@voices[downcase_name].languages.add(language.to_s)
              end
            end
          end
        end
      end

      if info = @@voices[speaker.to_s.downcase.to_sym]
        info
      else
        raise Error.new("Voice does not exist.")
      end
    end

  end
end
