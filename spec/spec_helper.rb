CONFIG_DIR = 'config'
CONFIG_FILE = File.join(CONFIG_DIR, 'acapela.yml')
DEFAULT_CONFIG_FILE = <<-YAML
login: 'EVAL_VAAS'
application: 'MY_APPLICATION'
password: 'MY_PASSWORD'
YAML

def create_missing_config_file
  unless File.exists?(CONFIG_FILE)
    Dir.mkdir(CONFIG_DIR)
    File.open(CONFIG_FILE, 'w') do |f|
      f.write(DEFAULT_CONFIG_FILE)
    end
  end
end

def test_config
  File.join('spec', 'acapela', 'test_config.yml')
end

create_missing_config_file

require File.join(File.dirname(__FILE__), '..', 'init')
Bundler.require(:test)


def silence_warnings
  begin
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
end

# Some test voices.
silence_warnings do
  Acapela::Voices::PER_LANGUAGE = {
    :en      =>  {:female=>["Tracy", "Heather"], :male=>["Kenny"]},
    :es      =>  {:female=>["Rosa"], :male=>[]},
    :fr      =>  {:female=>[], :male=>["Antoine", "Bruno"]},
  }
end

EXAMPLE_ACAPELA_RESPONSE_ACCESS_DENIED = "res=NOK&err_code=ACCESS_DENIED_ERROR&err_msg=Invalid%20identifiers&w=&create_echo="
EXAMPLE_ACAPELA_RESPONSE_INVALID_PARAM = "res=NOK&err_code=INVALID_PARAM_ERROR&err_msg=This%20voice%20is%20not%20available&w=&create_echo="
EXAMPLE_ACAPELA_RESPONSE_OK = "w=&snd_time=1407.94&get_count=0&snd_id=210375264_cacefb1f8f862&asw_pos_init_offset=0&asw_pos_text_offset=0&snd_url=http://vaas.acapela-group.com/MESSAGES/009086065076095086065065083/EVAL_ACCOUNT/sounds/210375264_cacefb1f8f862.mp3&snd_size=9098&res=OK&create_echo="
