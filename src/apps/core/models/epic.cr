require "../../models"

class CrystalTwin::Models::EpicInfo < CrystalTwin::Models::SubModel
    @[Index]
    property tid : String = ""
    property uid : String = ""
    property title : String = ""
    property aliases : Array(String) = Array(String).new
    property tags : Array(String) = Array(String).new
end

class CrystalTwin::Models::Epic < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::EpicInfo
    property links : CrystalTwin::Models::Links
    property profile : CrystalTwin::Models::Profile
end
