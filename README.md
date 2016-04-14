## README

This is an implementation of a RoR test task.

The initial task is to develop:

  * an API able to retrieve binary files containing samples, and insert them in database, into a samples table

  * an API able to send the content of the samples table as json data

In scope of this implementation were created two endpoints in SamplesController:

  * GET /samples/:sensor_id that returns samples for specified sensor_id in json format (with optional start_date and end_date)

  * POST /samples that accepts a json, application then processes the json and creates records in samples table.


## Decoding and storing the entries

Decoding of the received json implements the library lib/decoder.rb. It is a class that takes an encoded buffer and returns an array of hashes with following keys [:capture_time, :sensor_id, :light, :soil_moisture, :air_temperature] and decoded values.

Decoder does the following:

  * decodes received buffer from base64 to raw binary;

  * extracts header form raw binary and gets number of entries from the header;

  * extracts values for each entry from the raw binary; for extracting values from raw binary used *unpack* ruby function;

  * forms hash for each entry;


Processing and storing of samples are provided by SamplesService. SamplesService takes a received buffer, uses Decoder lib to decode it, forms ActiveRecord objects from hashes, runs validations and proceeds. The validations are implemented on Sample model that reflects an entry in samples db table:

  * validates uniqueness of capture_time for records with same sensor_id;

  * validates that capture_time cannot be in future;


## Send content of the samples table as json data

GET /samples/:sensor_id endpoint maps to index method of the SamplesController. It returns records from the samples table got by provided sensor_id and start_time, end_time if provided. ActiveModel::Serializer used to provide appropriate json of Sample model.


## Testing

Task is done using Rails 5 and ruby 2.2.4. Rspec is used for tests.

Before running the tests do:

  `cp config/database.yml.sample config/database.yml`
  `cp config/secrets.yml.sample config/secrets.yml`
