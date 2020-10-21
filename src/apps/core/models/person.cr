require "../../models"

class CrystalTwin::Models::PersonalInfo < CrystalTwin::Models::SubModel
    
    property tid : String = ""
    property full_name : String = ""
    property comment : String = ""
    property description : String = ""
    property tags : Array(String) = Array(String).new
    property aliases : Array(String) = Array(String).new
    property remarks : String = ""
    property countries : Array(String) = Array(String).new
    property cities : Array(String) = Array(String).new
end

class CrystalTwin::Models::ContactInfo < CrystalTwin::Models::SubModel
    property email : String = ""
    property telephone : String = ""
    property telegram : String = ""
    property skype : String = ""
end

class CrystalTwin::Models::Address < CrystalTwin::Models::SubModel
    property city : String = ""
    property houseno : String = ""
    property postalcode : String = ""
    property country : String = ""
end

class CrystalTwin::Models::Person < CrystalTwin::Models::Model
    property info : CrystalTwin::Models::PersonalInfo
    property contactinfo : CrystalTwin::Models::ContactInfo
    property address : CrystalTwin::Models::Address
    property links : CrystalTwin::Models::Links
    property profile : CrystalTwin::Models::Profile
end
