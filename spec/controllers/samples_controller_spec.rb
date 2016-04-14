require 'rails_helper'
require 'support/shared_examples'

describe SamplesController do

  context "retrieve samples" do

    before do
      data = load_binary_data('correct')
      SamplesService.new.load_from_binary(data['buffer'])
      get :index, params: {sensor_id: 37}
    end

    it "returns success status" do
      expect(response.status).to eq(200)
    end

    it "returns list of all samples" do
      expect(JSON.parse(response.body)['samples'].size).to eq(3)
    end
  end

  context "upload correct sensors data" do

    before do
      request.env['CONTENT_TYPE'] = 'application/json'
      request.env['RAW_POST_DATA'] = load_binary_data('correct').to_json
      post :create
    end

    it "returns success" do
      expect(response.status).to eq(200)
    end

    it "should be samples are stored in the database" do
      expect(Sample.count).to eq(3)
    end

  end

  context "bad request data" do

    before do
      request.env['CONTENT_TYPE'] = 'application/json'
      request.env['RAW_POST_DATA'] = load_binary_data('time_in_future').to_json
      post :create
    end

    it "returns bad request" do
      expect(response.status).to eq(400)
    end

  end


end