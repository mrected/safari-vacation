require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'active_record'

# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    database: "safari_vacation"
)

class SeenAnimal < ActiveRecord::Base
end 


# returns all animals
get '/Animals' do 
    json SeenAnimal.all
end

# return any animals where params match anything in species
get '/Search' do
    json SeenAnimal.where('species ILIKE ?', "%#{params["species"]}%")
end

# adds an animal via 
post '/Animal' do

    # {
    #     "seen_animal":{
    #         "species": "dog",
    #         "count_of_times_seen":2,
    #         "last_location_seen": "playing poker"
    #     }
    # }

    animal_json = JSON.parse(request.body.read)

    animal_active_record = SeenAnimal.create(animal_json["seen_animal"])

    json animal_active_record
end

# gets animals only by EXACT location
get '/Animal/:location' do

    json SeenAnimal.where(last_location_seen: params["location"])

end

# adds 1 to count of times seen for given animal id
put '/Animal/:id' do

    found_animal = SeenAnimal.find(params["id"])

    found_animal.update(count_of_times_seen: found_animal.count_of_times_seen + 1)

    json found_animal

end
