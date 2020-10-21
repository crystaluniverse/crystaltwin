require "../../models"

class CrystalTwin::Models::SiteInfo < CrystalTwin::Models::SubModel
    property tid : String = ""
    property name : String = ""
    property title : String = ""
    property aliases : Array(String) = Array(String).new
    property tags : Array(String) = Array(String).new
end


class CrystalTwin::Models::Site < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::SiteInfo
    property links : CrystalTwin::Models::Links
    property topic_ids : Array(String) = Array(String).new
    property include : Array(String) = Array(String).new
    property exclude : Array(String) = Array(String).new
end