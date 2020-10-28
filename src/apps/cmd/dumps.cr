require "yaml"
require "json"
require "bcdb"

require "../models"
require "../../config"

class CrystalTwin::Cmd::Dumps
  @@data_path
  @@model

  def self.config(data_path : String = "#{__DIR__}/../../../data", socketfile = "/tmp/bcdb.sock", namespace = "crystaltwin")
    @@model = "*"
    @@data_path = Path.new(data_path)
    if !Dir.exists?(@@data_path.as(Path))
      Dir.mkdir(@@data_path.to_s)
    end
    CrystalTwin::Config.set_db socketfile: socketfile, namespace: namespace
  end

  def self.set_model(model = "*")
    known_model_names = [] of String
    known_model_names << "* -> All"
    is_known_model = MODELS.find { |mod|
      known_model_names << mod.basename
      model == mod.basename || model == "*"
    }
    if is_known_model.nil?
      err("Unknown Model,Please Enter one of the Following values #{known_model_names}")
      exit 1
    end
    @@model = model
  end

  def self.dumps(overwrite_flag : Bool = false)
    # Loop on each model
    CrystalTwin::Config.models.each do |model|
      # Check if model equals to the model option
      if @@model == "*" || @@model == model.basename
        model_path = Path.new(@@data_path.as(Path),"#{model.basename}s")
        if !Dir.exists?(model_path)
          Dir.mkdir(model_path)
        end
        # List the keys of each model
        model_objects = model.list
        # Dump the data from database to yaml files 
        model_objects.each do |key|
          obj_path = Path.new(model_path,"#{model.basename}#{key.to_s}.yaml")
          if File.exists?(obj_path) && !overwrite_flag
            log("#{File.basename(obj_path)} is already exist\nplease add --overwrite to your command\n", 2)
          else
            obj_file = File.new(obj_path, "w+")
            obj = model.get(key)
            obj.to_yaml(obj_file)
            log("Data dumped from database to #{File.basename(obj_path)}",1)
          end
        end
      end
    end
  end
end
