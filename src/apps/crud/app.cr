require "./config"
require "./macros"
require "../app"

class CrystalTwin::App::Crud < CrystalTwin::App
    # generate all basic crud endpoints as well as their swagger api docs
    # for all models in the system
    def  initialize
        CrystalTwin::Macros::Crud.init
    end
end
