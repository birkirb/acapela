#!/usr/bin/env ruby

require 'rake'
require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'acapela/constants'

RSpec::Core::RakeTask.new(:spec)

namespace :generate do
  desc "Generates MP3 with test strings for all voices."
  task :test_voices do
    exec('ruby -I lib script/test_voices.rb')
  end

  desc "Generate default voice class based on enumrated values from Acapela"
  task :default_voices_class do
    exec('ruby -I lib script/create_voices.rb')
  end

  desc "Generate default voice class based on PHP example voice list"
  namespace :default_voices_class do
    task :php do
      exec('ruby -I lib script/create_voices.rb php')
    end
  end
end

desc "Clean up generated and downloaded files"
task :clean do
  include Acapela::Scripts
  FileUtils.rm_rf(LOCAL_TEMP_DIR)
  FileUtils.rm(PHP_VOICE_ARRAY_FILE) rescue nil
  FileUtils.rm(VOICES_ENUMERATOR_FILE) rescue nil
end

task :default => :spec
