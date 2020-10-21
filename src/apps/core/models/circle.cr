require "../../models"

class CrystalTwin::Models::CircleInfo < CrystalTwin::Models::SubModel
    property tid : String = ""
    property name : String = ""
    property description : String = ""
    property title : String = ""
    property aliases : Array(String) = Array(String).new
    property type : String = ""
    property tags : Array(String) = Array(String).new
    property members : Array(String) = Array(String).new
    property children : Array(String) = Array(String).new
    property description : String = ""
    property remarks : String = ""
    property acl_id : Int32 = 0
end

class CrystalTwin::Models::Circle < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::CircleInfo
    property links : CrystalTwin::Models::Links
    property profile : CrystalTwin::Models::Profile

end