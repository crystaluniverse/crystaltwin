require "./config"

module CrystalTwin::Macros

    # Generate CRUD api endpoints 
    module Crud
        # Generate crud operations for all (main) models out there
        # examples
        # get /api/circles  (list)
        # get /api/circles:id (get)
        # post /api/circles (create)
        # put /api/circles/:id (update)
        # delete /api/circles/:id (delete)
        macro init

            # all responses coming from /api/* are json
            before_all "/api/*" do |env|
                env.response.content_type = "application/json"
            end

            CrystalTwin::Config.models.each do |model|
                prefix = "/api/#{model.basename}s/"
                
                # get /api/{model}s (list)
                get prefix do |env|
                    model.list.to_json
                end
                
                get "#{prefix}:id" do |env|
                    begin
                        model.get(env.params.url["id"].to_u64).to_json
                    rescue Bcdb::NotFoundError
                        halt env, status_code: 404, response: %({"error": "Not Found"})
                    end
                end
                
                delete "#{prefix}:id" do |env|
                    begin
                        model.delete(env.params.url["id"].to_u64)
                    rescue Bcdb::NotFoundError
                        halt env, status_code: 404, response: %({"error": "Not Found"})
                    end
                end

                post prefix do |env|
                    obj = model.from_json(env.params.json.to_json)
                    begin
                        obj.save.to_json
                    rescue JSON::MappingError
                        halt env, status_code: 409, response: %({"error": "Json Parsing error"})
                    end
                end
                
                put "#{prefix}:id" do |env|
                    obj = model.from_json(env.params.json.to_json)
                    if obj.id == 0
                        halt env, status_code: 409, response: %({"error": "Invalid object ID"})
                    end
                    begin
                        obj.save.to_json
                    rescue Bcdb::NotFoundError
                        halt env, status_code: 404, response: %({"error": "Not Found"})
                    end
                end

                # Build Open API docs
                capitalmodelname = model.basename.capitalize
                CrystalTwin::Config.swagger.add(Swagger::Controller.new(capitalmodelname, "#{capitalmodelname} resources", [
                    Swagger::Action.new("get", "#{prefix}", description: "All #{model.basename}s", responses: [
                        Swagger::Response.new("200", "Success response")
                    ]),
                    
                    Swagger::Action.new("get", "#{prefix}{id}", description: "Get #{model.basename} by id", parameters: [
                        Swagger::Parameter.new("id", "path")
                    ], responses: [
                        Swagger::Response.new("200", "Success response"),
                        Swagger::Response.new("404", "Not found")
                    ], authorization: false),

                    Swagger::Action.new("put", "#{prefix}{id}", description: "Update #{model.basename} by id", parameters: [
                        Swagger::Parameter.new("id", "path")
                    ],
                    request: Swagger::Request.new([
                        Swagger::Property.new("#{capitalmodelname}", required: true, description: "#{capitalmodelname} object"),
                    ], "#{capitalmodelname} Object", "application/json"),
                    responses: [
                        Swagger::Response.new("200", "Success response"),
                        Swagger::Response.new("404", "Not found")
                    ], authorization: false),
                    
                    Swagger::Action.new("post", "#{prefix}", description: "Create #{capitalmodelname}",
                    request: Swagger::Request.new([
                        Swagger::Property.new("#{capitalmodelname}", required: true, description: "#{capitalmodelname} object"),
                    ], "#{capitalmodelname} Object", "application/json"),
                    responses: [
                        Swagger::Response.new("201", "Return #{model.basename} resource after created"),
                        Swagger::Response.new("401", "Unauthorizated")
                    ], authorization: false),

                    Swagger::Action.new("delete", "#{prefix}{id}", description: "Delete #{model.basename} by id", parameters: [
                        Swagger::Parameter.new("id", "path")
                    ], responses: [
                        Swagger::Response.new("200", "Success response"),
                        Swagger::Response.new("404", "Not found")
                    ], authorization: true),

                    ]))
            end
            
        end
    end
end
