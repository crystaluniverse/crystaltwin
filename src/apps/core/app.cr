require "./config"
require "./macros"
require "../app"


class CrystalTwin::App::Core < CrystalTwin::App
    def  initialize
        # generate all basic crud endpoints as well as their swagger api docs
        # for all models in the system
        CrystalTwin::Macros::Crud.init

        # Initialize swagger
        CrystalTwin::Config.swagger.add(Swagger::Server.new("http://localhost:#{CrystalTwin::Config.port}/", "Alias Name", [
            Swagger::Server::Variable.new("port", "#{CrystalTwin::Config.port}", ["#{CrystalTwin::Config.port}"], "API port"),
            ]))
        
        CrystalTwin::Config.swagger.add(Swagger::Server.new("http://0.0.0.0:#{CrystalTwin::Config.port}/", "IP Address", [
        Swagger::Server::Variable.new("port", "#{CrystalTwin::Config.port}", ["#{CrystalTwin::Config.port}"], "API port"),
        ]))

        swagger_api_endpoint = "http://#{CrystalTwin::Config.host}:#{CrystalTwin::Config.port}"
        swagger_web_entry_path = "/openapi"
        swagger_api_handler = Swagger::HTTP::APIHandler.new(CrystalTwin::Config.swagger.built, swagger_api_endpoint)
        swagger_web_handler = Swagger::HTTP::WebHandler.new(swagger_web_entry_path, swagger_api_handler.api_url)

        add_handler swagger_api_handler
        add_handler swagger_web_handler
    end
end
