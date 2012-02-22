require 'spec_helper'
require 'cgi'

describe Acapela::Response do

  after(:each) do
    Acapela::Response.mock_on
  end

  it 'should throw an error when created with bogus parameters' do
    expect do
      Acapela::Response.new('stuff=yeah')
    end.to raise_error(Acapela::Error, Acapela::Response::ERROR_UNEXPECTED_RESPONSE.message)
  end

  it 'should report sound related stats' do
    response = Acapela::Response.new(Acapela::Mocks::EXAMPLE_ACAPELA_RESPONSE_OK)
    response.url.should be_kind_of(URI)
    response.time.should be_kind_of(Float)
    response.size.should be_kind_of(Integer)
    response.id.should be_kind_of(String)
    response.time.should == 1407.94
    response.size.should == 9098
    response.id.should == '210375264_cacefb1f8f862'
  end

  it 'should download and return a tempfile with the object from the response url' do
    response = Acapela::Response.new(Acapela::Mocks::EXAMPLE_ACAPELA_RESPONSE_OK)

    file = response.download_to_tempfile
    file.should be_kind_of(Tempfile)
    file.rewind
    contents = file.read
    file.close
    contents.should == File.read(Acapela::Mocks::RESPONSE_TEST_FILE)
  end

  it 'should raise an error when file download fails with non 200 response' do
    Acapela::Response.mock_off # Returns the test file contents.
    response = Acapela::Response.new(Acapela::Mocks::EXAMPLE_ACAPELA_RESPONSE_OK)
    Net::HTTP.expects(:get_response).returns(Net::HTTPNotFound.new("Body?", 404, "Something went wrong."))
    expect do
      response.download_to_tempfile
     end.to raise_error(Acapela::Error)
  end

end
