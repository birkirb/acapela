require 'net/http'
require 'set'
require 'fileutils'
require 'lib/acapela/constants'

include Acapela::Scripts

def save_uri_to_file_if_missing(uri, filename)
  if !File.exists?(filename)
    response = Net::HTTP.get_response(uri)

    if 200 == response.code.to_i
      voice_hash = Hash.new
      File.open(filename,'w') do |f|
        f.write(response.body)
      end
    else
      puts "Download failed with: #{response.code}\nBody#{response.body}"
      exit 1
    end
  end
end

def php_array_to_ruby_array_of_hashes(text)
  voices = Array.new
  text.lines do |line|
    if match = PHP_ARRAY_REGEXP.match(line)
      line_hash = eval("{#{match[1]}}")
      voices << line_hash
    end
  end
  voices
end

def enumerator_text_to_ruby_array_of_hashes(text)
  voices = Array.new
  text.lines do |line|
    if match = VOICE_ENUMERATOR_REGEXP.match(line)
      voices << {'language_locale' => match[2], 'speaker' => match[4], 'gender' => match[6]}
    end
  end
  voices
end

def gender_code_to_symbol(gender)
  case gender
  when 'F'
    Acapela::Voice::GENDER_FEMALE
  when 'M'
    Acapela::Voice::GENDER_MALE
  else
    raise "Unknown gender code: #{gender}"
  end
end

def simple_language_code(locale)
  locale.split('_').first
end

class Set
  def inspect
    self.to_a.inspect
  end
end

def voice_array_to_voices_per_language(voices)
  language_voices = Hash.new { |h,v| h[v] = { :female => Set.new, :male => Set.new } }

  voices.each do |voice_hash|
    gender = gender_code_to_symbol(voice_hash['gender'])
    locale = voice_hash['language_locale']
    simple_locale = simple_language_code(locale)

    language_voices[locale][gender].add(voice_hash['speaker'])
    language_voices[simple_locale][gender].add(voice_hash['speaker'])
  end

  # Clean up instance where specific locale is same as generic one.
  language_voices.delete_if do |key,value|
    simple_locale = simple_language_code(key)
    if key != simple_locale && language_voices[simple_locale] == value
      true
    else
      false
    end
  end

  language_voices
end

def construct_class(voices_per_language)
  text_hashes = voices_per_language.keys.sort.map do |key|
    "".rjust(6) + ":" + key.to_s.ljust(8) + "=>".ljust(4) + voices_per_language[key].inspect
  end

  klass_text = <<-CLASS
module Acapela
  module Voices
    PER_LANGUAGE = {
#{text_hashes.join(",\n")}
    }
  end
end
CLASS
  klass_text
end

def write_klass(klass)
  klass_dir = File.dirname(DEFAULT_VOICES_RUBY_FILE)

  if !File.exist?(klass_dir)
    FileUtils.mkdir_p(klass_dir)
  end

  File.open(DEFAULT_VOICES_RUBY_FILE, 'w') do |f|
    f.write(klass)
  end
end

def main
  if ARGV[0] == 'php'
    save_uri_to_file_if_missing(PHP_VOICE_ARRAY_URL, PHP_VOICE_ARRAY_FILE)
    voices = php_array_to_ruby_array_of_hashes(File.read(PHP_VOICE_ARRAY_FILE))
  else
    save_uri_to_file_if_missing(VOICES_ENUMERATOR_URL, VOICES_ENUMERATOR_FILE)
    voices = enumerator_text_to_ruby_array_of_hashes(File.read(VOICES_ENUMERATOR_FILE))
  end

  voices_per_language = voice_array_to_voices_per_language(voices)
  klass = construct_class(voices_per_language)
  write_klass(klass)
  puts "Done."
end

if $0 == __FILE__
  main
end
