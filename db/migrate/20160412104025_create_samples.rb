class CreateSamples < ActiveRecord::Migration[5.0]
  def change
    create_table :samples do |t|
      t.timestamp :capture_time
      t.integer :sensor_id
      t.integer :light
      t.integer :soil_moisture
      t.integer :air_temperature
    end
  end
end
