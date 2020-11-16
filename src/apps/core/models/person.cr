require "../../models"

class CrystalTwin::Models::PersonalInfo < CrystalTwin::Models::SubModel    

end

class CrystalTwin::Models::PersonProfile < CrystalTwin::Models::SubModel
    #short version of your profile e.g. the first sentence, ... 
    property profile_intro : String = ""
    property profile_long : String = ""
    property categories : Array(String) = Array(String).new #try to use enum: business, freetime, sports, school, ...
    property tags : Array(String) = Array(String).new  
    property cities : Array(String) = Array(String).new
    property countries : Array(String) = Array(String).new
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
    property tid : String = ""
    #human id = hid
    property hid: String = ""  
    property full_name : String = ""
    property tags : Array(String) = Array(String).new
    property aliases : Array(String) = Array(String).new
    property remarks : String = ""  
    property contactinfo :  Array(CrystalTwin::Models::ContactInfo) = Array(CrystalTwin::Models::ContactInfo).new  
    property addresses : Array(CrystalTwin::Models::Address) = Array(CrystalTwin::Models::Address).new
    property links : CrystalTwin::Models::Links #ARRAY
    property profiles : CrystalTwin::Models::Profile #ARRAY
end
