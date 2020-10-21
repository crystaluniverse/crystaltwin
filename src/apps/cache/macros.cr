require "./config"

module CrystalTwin::Macros

    # Initialize cache with as many namespaces as main models in the system 
    module Cache
        macro init_cache        
            def initialize
                CrystalTwin::Config.models.each do |model|
                    namesapces[model.fullname] = {} of UInt64 => CrystalTwin::Models::Model
                end
            end
        end
    end
end
