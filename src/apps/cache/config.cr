require "./cache"

class CrystalTwin::Config
    # Cache
    @@cache = CrystalTwin::Cache.new

    def self.cache
        @@cache
    end
end


    