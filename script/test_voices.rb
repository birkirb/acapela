# Encoding: UTF-8

trap("SIGINT") do
  puts "Stopping..."
  @interrupted = true
end

SAMPLE_SENTENCES = {
  :ar      =>  "اسمي {name} وأنا أتكلم يمكن.", # Arabic (Saudi Arabia)
  :ca      =>  "El meu nom és {name} i que pot parlar.", # Catalan (Spain)
  :cs      =>  "Mé jméno je {name} a mohu mluvit.", # Czech
  :da      =>  "Mit navn er {name}, og jeg kan tale.", # Danish
  :de      =>  "Mein Name ist {name}, und ich kann sprechen.", # German
  :el      =>  "Το όνομά μου είναι {name}, και μπορώ να μιλήσω.", # Greek
  :en      =>  "My name is {name} and I can talk.", # English
  :en_GB   =>  "My name is {name} and I live in Great Britain.", # English (Great Britain)
  :en_IN   =>  "My name is {name} and I live in India.", # English (India)
  :en_US   =>  "My name is {name} and I live in the United States.", # English (US)
  :es      =>  "Mi nombre es {name}, y puede hablar.", # Spanish
  :es_ES   =>  "Mi nombre es {name} y vivo en España.", # Spanish (Spain)
  :es_US   =>  "Mi nombre es {name} y yo vivimos en Estados Unidos.", # Spanish (US?)
  :fi      =>  "Nimeni on {name}, ja voin puhua.", # Finnish
  :fr      =>  "Mon nom est {name}, et je peux parler.", # French
  :fr_BE   =>  "Mon nom est {name} et je vis en Belgique.", # French (Belgium)
  :fr_CA   =>  "Mon nom est {name} et je vis au Canada.", # French (Canada)
  :fr_FR   =>  "Mon nom est {name} et je vis en France.", # French (French)
  :gb      =>  "Mitt namn är {name} och jag bor i Gotenburg.", # Gotenburg (Swedish), should be sv_SV_gotenburg ?
  :it      =>  "Il mio nome è {name}, e posso parlare.", # Italian
  :ja      =>  "私の名前は{name}です。私は話せます。", # Japanese
  :nl      =>  "Mijn naam is {name}, en ik spreek kan.", # Dutch
  :nl_BE   =>  "Mijn naam is {name} en ik woon in België.", # Dutch (Belgium)
  :nl_NL   =>  "Mijn naam is {name} en ik woon in Nederland.", # Dutch (Netherlands)
  :no      =>  "Mitt navn er {name}, og jeg kan snakke.", # Norwegian
  :pl      =>  "Nazywam się {name}, i mogę mówić.", # Polish
  :pt      =>  "Meu nome é {name}, e eu posso falar.", # Portuguese
  :pt_BR   =>  "Meu nome é {name} e eu vivo no Brasil.", # Portuguese (Brazil)
  :pt_PT   =>  "Meu nome é {name} e eu vivo em Portugal.", # Portuguese (Portugal)
  :ru      =>  "Меня зовут {name}, и я могу сказать.", # Russia
  :sc      =>  "Mitt namn är {name} och jag bor i Scania.", # Scanian (Sweden), should be sv_SE_scania
  :sv      =>  "Mitt namn är {name}, och jag kan tala.", # Swedish
  :sv_FI   =>  "Mitt namn är {name} och jag bor i Finland.", # Swedish (Finland)
  :sv_SE   =>  "Mitt namn är {name} och jag bor i Sverige.", # Swedish (Sweden)
  :tr      =>  "Benim adım {name} ve konuşamıyorum.", # Turkish
  :zh      =>  "我的名字是{name}，我可以說。", # Chinese
}

require 'acapela'
include Acapela::Scripts

service = Acapela::VoiceService.new(Acapela.config)
FileUtils.mkdir_p(TEST_VOICES_DIR)

Acapela::Voices::PER_LANGUAGE.each do |language, voice_gender|
  voice_gender.each do |gender, speakers|
    speakers.each do |speaker|
      begin
        if text = SAMPLE_SENTENCES[language.to_sym]
          text = text.gsub('{name}', speaker)
          destination_file = File.join(TEST_VOICES_DIR, "#{language}_#{speaker}.mp3")
          if !File.exists?(destination_file)
            response = service.generate_sound(text, :speaker => speaker)
            mp3_file = response.download_to_tempfile
            FileUtils.cp(mp3_file.path, destination_file)
            mp3_file.close!
            puts "Generated: #{text}"
          end
        else
          puts "No text for: #{speaker} in #{language}"
        end
      rescue => err
        puts "FAILED WITH: #{language}, #{gender}, #{speakers.inspect}, #{speaker}\nReason: #{err.message}"
      end

      exit 0 if @interrupted
    end
  end
end
