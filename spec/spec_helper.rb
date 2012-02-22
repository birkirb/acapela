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
require 'bundler'
Bundler.require(:development)
require 'acapela/mocks'

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
