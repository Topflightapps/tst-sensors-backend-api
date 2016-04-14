class AddSamplesIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :samples, :sensor_id
    add_index :samples, :capture_time
  end
end
