require 'json'

def load_binary_data(name)
  data_file =  File.join(Rails.root, 'spec', "#{name}_input.json")
  JSON.parse(File.read(data_file))
end
