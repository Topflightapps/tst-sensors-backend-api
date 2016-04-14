class SamplesController < ApplicationController

  def index
    relation = Sample.where(sensor_id: params[:sensor_id])
    relation = relation.where(capture_time >= params[:start_time]) if params[:start_time]
    relation = relation.where(capture_time <= params[:end_time]) if params[:end_time]

    @samples = relation
    render json: @samples
  end

  def create
    SamplesService.new.load_from_binary(params[:buffer])
    render json: { message: 'success'}
  rescue SamplesService::SamplesLoadingError => e
    render json: { message: e.message}, status: 400
  end
end
