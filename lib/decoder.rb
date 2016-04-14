require "base64"

class Decoder

  ROW_HEADERS = [:capture_time, :sensor_id, :light, :soil_moisture, :air_temperature]
  VALUE_TRANSFORMERS = {
      capture_time: (lambda { |value| Time.at(value).utc})
  }

  def initialize(buffer)
    @buffer = buffer
    @header_length = 3
    @row_length = 12
  end

  def decode
    raw = from_base64_to_raw(@buffer)

    number_of_entries = number_of_entries(raw)

    entries_array = entries_string_to_array(raw[@header_length..-1], number_of_entries)

    form_entries(entries_array)
  end

  private

  def from_base64_to_raw(buffer)
    Base64.decode64(buffer)
  end

  def form_entries(arr)
    arr.map do |row|
      ROW_HEADERS.inject({}) do |memmo, header|
        value = row[ROW_HEADERS.index(header)]
        value = VALUE_TRANSFORMERS[header].call(value) if VALUE_TRANSFORMERS[header]
        memmo[header] = value
        memmo
      end
    end
  end

  def number_of_entries(raw_buffer)
    header = raw_buffer.unpack(">cn")
    number_of_entries = header.last
    return number_of_entries
  end

  def entries_string_to_array( original, number_of_entries)
    current_position = 0
    result = []
    number_of_entries.times do
      entry = original[current_position..-1].unpack('Nnnnn')
      result.push(entry)
      current_position = current_position + @row_length
    end

    result
  end
end
