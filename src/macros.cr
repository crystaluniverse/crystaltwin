require "./config"

module CrystalTwin::Macros
    # Initialize all Apps in the system by running init if there
    module Apps
        macro init_apps
            CrystalTwin::Config.apps.each do |app|
                app.new
            end
        end
    end
end
