module Acapela
  module Mocks

    RESPONSE_TEST_FILE = File.join(File.dirname(__FILE__), 'test_file.mp3')

    EXAMPLE_ACAPELA_RESPONSE_ACCESS_DENIED = "res=NOK&err_code=ACCESS_DENIED_ERROR&err_msg=Invalid%20identifiers&w=&create_echo="
    EXAMPLE_ACAPELA_RESPONSE_INVALID_PARAM = "res=NOK&err_code=INVALID_PARAM_ERROR&err_msg=This%20voice%20is%20not%20available&w=&create_echo="
    EXAMPLE_ACAPELA_RESPONSE_OK = "w=&snd_time=1407.94&get_count=0&snd_id=210375264_cacefb1f8f862&asw_pos_init_offset=0&asw_pos_text_offset=0&snd_url=http://vaas.acapela-group.com/MESSAGES/009086065076095086065065083/EVAL_ACCOUNT/sounds/210375264_cacefb1f8f862.mp3&snd_size=9098&res=OK&create_echo="

  end
end
