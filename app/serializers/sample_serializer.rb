class SampleSerializer < ActiveModel::Serializer
  attributes :capture_time, :sensor_id, :light, :soil_moisture, :air_temperature
end
