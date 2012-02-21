require 'uri'

module Acapela

  VERSION = "0.8.0"

  class Voice
    QUALITY_LOW = '8k'
    QUALITY_HIGH = '22k'
    GENDER_FEMALE = :female
    GENDER_MALE = :male
  end

  module Scripts
    LOCAL_TEMP_DIR = 'tmp'
    TEST_VOICES_DIR = File.join(LOCAL_TEMP_DIR, 'voices')


    PHP_VOICE_ARRAY_URL = URI.parse("http://vaas.acapela-group.com/webservices/1-34-01/publish/export/EVAL_VAAS/voices_lists/php_code.txt")
    PHP_VOICE_ARRAY_FILE = File.join('script', 'php_code.txt')
    PHP_ARRAY_REGEXP = /array\((.*)?\),?$/

    VOICES_ENUMERATOR_URL = URI.parse("http://vaas.acapela-group.com/Services/Enumerator")
    VOICES_ENUMERATOR_FILE = File.join('script', 'voice_enumerator.out')
    # Enmuerator Example: leila22k=ar_SA/Arabic (Saudi Arabia)/Leila/HQ/F/PCM/22050
    VOICE_ENUMERATOR_REGEXP = /(.*)?=(\w\w_\w\w)\/(.*)?\/(\w+)\/(\w+)\/(\w+)\/(\w+)\//

    DEFAULT_VOICES_RUBY_FILE = File.join('lib', 'acapela', 'voices', 'default.rb')
  end

end
