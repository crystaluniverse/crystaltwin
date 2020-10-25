require "../../models"

class CrystalTwin::Models::PersonalInfo < CrystalTwin::Models::SubModel
    
    property tid : String = ""
    property full_name : String = ""
    property comment : String = ""
    property description : String = ""
    property tags : Array(String) = Array(String).new
    property aliases : Array(String) = Array(String).new
    property remarks : String = ""
    property countries : Array(String) = Array(String).new
    property cities : Array(String) = Array(String).new
    property db_tags : Hash(String, String) = Hash(String, String).new
end

class CrystalTwin::Models::ContactInfo < CrystalTwin::Models::SubModel
    property email : String = ""
    property telephone : String = ""
    property telegram : String = ""
    property skype : String = ""
end

class CrystalTwin::Models::Address < CrystalTwin::Models::SubModel
    property city : String = ""
    property houseno : String = ""
    property postalcode : String = ""
    property country : String = ""
end

class CrystalTwin::Models::Person < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::PersonalInfo
    property contactinfo : CrystalTwin::Models::ContactInfo
    property address : CrystalTwin::Models::Address
    property links : CrystalTwin::Models::Links
    property profile : CrystalTwin::Models::Profile

    # Overloading Save Method
    def save(overwite_flag : Bool = false)
        tags = self.info.db_tags
        db = CrystalTwin::Config.db
        cache = CrystalTwin::Config.cache
        tags["model"] = self.fullname
        tags[self.info.tags.to_s] = ""
        if self.id == 0 # new
            self.id = db.put(self.to_yaml, tags)
            cache.set(self.fullname, self.id.not_nil!, self)
            log("The file saved to the database as a new entry #{self.id}",1)
        elsif overwite_flag # update if overwrite enabled
            cache.set(self.fullname, self.id.not_nil!, self)
            db.update(self.id.not_nil!, self.to_yaml, tags)
            log("The file update the database entry #{self.id}",1)
        else # overwrite is not enabled
            log("The file already in the database\nplease add --overwrite to your command\n", 2)
        end
    end
end
