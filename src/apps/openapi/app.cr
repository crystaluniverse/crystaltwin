require "./config"
require "../app"

before_all "/v3/*" do |env|
    env.response.headers["Access-Control-Allow-Origin"] = "*"
end


class CrystalTwin::App::OpenAPI < CrystalTwin::App
    def  initialize
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

