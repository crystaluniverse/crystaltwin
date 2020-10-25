require "../../models"

class CrystalTwin::Models::EpicInfo < CrystalTwin::Models::SubModel
    @[Index]
    property tid : String = ""
    property uid : String = ""
    property title : String = ""
    property aliases : Array(String) = Array(String).new
    property tags : Array(String) = Array(String).new
    property db_tags : Hash(String, String) = Hash(String, String).new
end

class CrystalTwin::Models::Epic < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::EpicInfo
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
