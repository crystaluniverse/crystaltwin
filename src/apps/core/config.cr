require "swagger"
require "swagger/http/handler"

class CrystalTwin::Config;
     # OpenAPI
     @@swagger  = Swagger::Builder.new(
        title: "CrystalTwin API",
        version: "1.0.0",
        description: "CrystalTwin Open API docs",
        # authorizations: [
        #   Swagger::Authorization.jwt(description: "Use JWT Auth"),
        # ]
    )
   
    def self.swagger
        @@swagger
    end
end