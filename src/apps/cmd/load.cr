require "yaml"
require "json"
require "bcdb"

require "../models"
require "../../config"

class CrystalTwin::Cmd::Load
  @@data_path
  @@model

  def self.config(data_path : String = "#{__DIR__}/../../../data", socketfile = "/tmp/bcdb.sock", namespace = "crystaltwin")
    @@model = "*"
    @@data_path = Path.new(data_path)
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

  def self.load (overwrite_flag : Bool = false)
    # Loop on all model directories in the data directory
    Dir.new(@@data_path.as(Path)).each_child do |model_dir|
      # Loop on each model
      CrystalTwin::Config.models.each do |model|
        # Check if model directory equals to the model directory and equals to the model option
        if "#{model.basename}s" == model_dir && (@@model == "*" || "#{@@model}s" == model_dir)
          model_path = Path.new(@@data_path.as(Path),model_dir)
          # Loop on each file inside model directory and load it to the database
          Dir.new(model_path.as(Path)).each_child do |child|
            path = Path.new(model_path, child)
            obj = model.from_yaml(File.read(path))
            if obj.id == 0 # In case of new entry
              obj.save
              obj.to_yaml(File.open(path,"w"))
              log("#{path.basename} loaded to the database as new entry ##{obj.id}",1)
            elsif overwrite_flag # In case of old entry with overwrite option
              obj.save
              log("#{path.basename} update the database at entry ##{obj.id}",1)
            else # In case of old entry without overwrite option
              log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
            end
          end
          break # To not loop on other models after found one.
        end
      end
    end
  end
end