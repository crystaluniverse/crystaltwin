require "../../models"

class CrystalTwin::Models::TopicInfo < CrystalTwin::Models::SubModel
    property tid : String = ""
    property name : String = ""
    property description : String = ""
    property title : String = ""
    property type : String = ""
    property tags : Array(String) = Array(String).new
end

class CrystalTwin::Models::Topic < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::TopicInfo
    property links : CrystalTwin::Models::Links
    property git : CrystalTwin::Models::Git

end