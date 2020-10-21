require "./macros"

class CrystalTwin::Cache 
    property namesapces : Hash(String, Hash(UInt64, CrystalTwin::Models::Model)) = Hash(String, Hash(UInt64, CrystalTwin::Models::Model)).new

    #initialize cache (namespaces) hash with all model name keys
    CrystalTwin::Macros::Cache.init_cache
    
    def list(namespace : String)
        self.namesapces[namespace].values
    end

    def set(namespace : String, key : UInt64, value : CrystalTwin::Models::Model)
        self.namesapces[namespace][key] = value
    end

    def get(namespace, key)
        self.namesapces[namespace].[key]
    end

    def delete(namespace, key)
        if self.exists?(namespace, key)
            self.namesapces[namespace].delete(key)
        end
    end

    def update(namespace, key, value)
        self.namesapces[namespace][key] = value
    end

    def exists?(namespace, key)
        self.namesapces[namespace].has_key?(key)
    end
end