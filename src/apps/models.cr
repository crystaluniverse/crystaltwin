require "yaml"
require "json"
require "bcdb"

# Mark a model field as indexable
annotation Index; end

# Submodels are not saved into database by themselves
# They live as properties inside Main models
# i.e Person.info
# reason for separation here is because we want to list main models only most of the time
class CrystalTwin::Models::SubModel
    include YAML::Serializable
    include JSON::Serializable
end

abstract class CrystalTwin::Models::Model
    include YAML::Serializable
    include JSON::Serializable
    
    property id : UInt64? = 0_u64

    # circle, topic, etc...
    def self.basename : String
        self.name.split(":")[-1].downcase
    end

    # circle, topic, etc...
    def basename
        self.class.basename
    end

    # crystaltwin::models.circle, crystaltwin::models.topic, etc...
    def self.fullname : String
        self.name.downcase
    end

    # crystaltwin::models.circle, crystaltwin::models.topic, etc...
    def fullname
        self.class.name.downcase
    end

    # Save/update object in bcdb, add to cache as well
    def save
        db = CrystalTwin::Config.db
        cache = CrystalTwin::Config.cache
        tags = {"model" => self.fullname} 
        if self.id == 0 # new
            self.id = db.put(self.to_yaml, tags)
            cache.set(self.fullname, self.id.not_nil!, self)
        else # update
            cache.set(self.fullname, self.id.not_nil!, self)
            db.update(self.id.not_nil!, self.to_yaml, tags)
        end
    end

    # delete from both cache & db
    def delete
        db = CrystalTwin::Config.db
        cache = CrystalTwin::Config.cache
        cache.delete(self.fullname, self.id.not_nil!)
        db.delete(self.id.not_nil!)
    end

    # delete from both cache & db
    def self.delete(id)
        db = CrystalTwin::Config.db
        cache = CrystalTwin::Config.cache
        cache.delete(self.fullname, id)
        db.delete(id)
    end
    # get from cache, if not there fetch db and cache object
    def self.get(id)
        db = CrystalTwin::Config.db
        cache = CrystalTwin::Config.cache
        if cache.exists?(self.fullname, id)
            cache.get(self.fullname, id)
        else
            item = db.get(id)["data"].as(String)
            obj = self.from_yaml(item)
            cache.set(self.fullname, obj.id.not_nil!, obj)
            obj.id = id
            return obj
        end
    end

    # list all objects
    def self.list
        db = CrystalTwin::Config.db
        db.find({"model" => self.fullname})
    end
end

class CrystalTwin::Models::Git < CrystalTwin::Models::SubModel
    property url : String = ""
    property branch : String = ""
    property path : String = ""
end

class CrystalTwin::Models::Links < CrystalTwin::Models::SubModel
    property linkedin : String = ""
    property websites : Array(String) = Array(String).new
    property facebook : String = ""
    property telegram : String = ""
end

class CrystalTwin::Models::Profile < CrystalTwin::Models::SubModel
    property intro_video : String = ""
    property intro_text_purpose : String = ""
    property intro_text_experience : String = ""
end
