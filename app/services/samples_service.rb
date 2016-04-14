class SamplesService

  class SamplesLoadingError < StandardError
  end

  def load_from_binary(binary_data)
    values = Decoder.new(binary_data).decode

    samples = values.inject([]) do |memmo, value|
      sample = Sample.new(value)
      sample.validate
      memmo << sample
      memmo
    end


    error = samples.find {|sample| sample.errors[:capture_time].include? 'cannot be in the future'}
    raise SamplesLoadingError if error

    samples.each do |s|
      s.save! if s.valid?
      Rails.logger.warn "Sample with capture_time already exists."  if s.errors[:capture_time].include?('"should be unique for sensor_id"')
    end

  end
end
