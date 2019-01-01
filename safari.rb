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

get '/Animals' do 
    # return all_the_animals as json
    json SeenAnimal.all
end
 
get '/Search' do
    # return any animals where params match anything in species
    json SeenAnimal.where('species ILIKE ?', "%#{params["species"]}%")
end

post '/Animal' do
    animal_json = JSON.parse(request.body.read)

    animal_active_record = SeenAnimal.create(animal_json["seen_animal"])

    json animal_active_record
end