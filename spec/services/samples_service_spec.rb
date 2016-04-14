require 'rails_helper'
require 'support/shared_examples'

describe 'SamplesService' do

  subject { SamplesService.new }

  it 'should load samples from binary data' do
    data = load_binary_data('correct')

    subject.load_from_binary(data['buffer'])
    expect(Sample.count).to eq(3)
  end


  it 'should raise error on the sensor capture_time is in the future' do
    expect {
      data = load_binary_data('time_in_future')
      subject.load_from_binary(data['buffer'])
    }.to raise_error(SamplesService::SamplesLoadingError)
  end

  it 'should not save any samples if sensor capture_time is in the future' do
    data = load_binary_data('time_in_future')

    begin
      subject.load_from_binary(data['buffer'])
    rescue SamplesService::SamplesLoadingError => ex
      #do nothing
    end
    expect(Sample.count).to eq(0)
  end

  it 'should log warning if a sample is already present in the database' do
    data = load_binary_data('duplicate_entries')
    subject.load_from_binary(data['buffer'])
    expect(Sample.count).to eq(2)
  end

end