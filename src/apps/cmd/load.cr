require "yaml"
require "json"
require "bcdb"

require "../models"
require "../../config"

class CrystalTwin::Cmd::Load
  property data_path
  property model
  property persons_path
  property circles_path
  property topics_path
  property epics_path
  property sites_path

  def initialize(@data_path=Path.new(__DIR__, "..", "..", "..", "data"))
    @model = "*"
    @persons_path = Path.new(self.data_path, "persons")
    @circles_path = Path.new(self.data_path, "circles")
    @topics_path = Path.new(self.data_path, "topics")
    @epics_path = Path.new(self.data_path, "epics")
    @sites_path = Path.new(self.data_path, "sites")
  end

  def config_db(socketfile = "/tmp/bcdb.sock", namespace = "crystaltwin")
    CrystalTwin::Config.set_db socketfile: socketfile, namespace: namespace
  end

  def set_data_path(path : String = self.data_path)
    @data_path = Path.new(path)
    @persons_path = Path.new(self.data_path, "persons")
    @circles_path = Path.new(self.data_path, "circles")
    @topics_path = Path.new(self.data_path, "topics")
    @epics_path = Path.new(self.data_path, "epics")
    @sites_path = Path.new(self.data_path, "sites")
  end

  def set_model(model = "*")
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
    @model = model
  end

  def load (overwrite_flag : Bool = false)
    # Load Person Model
    if @model == "*" || @model == "person"
      Dir.new(@persons_path.as(Path)).each_child do |child|
        path = Path.new(@persons_path.to_s, child)
        person = CrystalTwin::Models::Person.from_yaml(File.read(path))
        print ("# #{path.basename} Status\n")
        person.save(overwrite_flag)
        person.to_yaml(File.open(path,"w"))
      end
    end

    # Load Circle Model
    if @model == "*" || @model == "circle"
      Dir.new(@circles_path.as(Path)).each_child do |child|
        path = Path.new(@circles_path.to_s, child)
        circle = CrystalTwin::Models::Circle.from_yaml(File.read(path))
        print ("# #{path.basename} Status\n")
        circle.save(overwrite_flag)
        circle.to_yaml(File.open(path,"w"))
      end
    end

    # Load Topic Model
    if @model == "*" || @model == "topic"
      Dir.new(@topics_path.as(Path)).each_child do |child|
        path = Path.new(@topics_path.to_s, child)
        topic = CrystalTwin::Models::Topic.from_yaml(File.read(path))
        print ("# #{path.basename} Status\n")
        topic.save(overwrite_flag)
        topic.to_yaml(File.open(path,"w"))
      end
    end

    # Load Epic Model
    if @model == "*" || @model == "epics"
      Dir.new(@epics_path.as(Path)).each_child do |child|
        path = Path.new(@epics_path.to_s, child)
        epic = CrystalTwin::Models::Epic.from_yaml(File.read(path))
        print ("# #{path.basename} Status\n")
        epic.save(overwrite_flag)
        epic.to_yaml(File.open(path,"w"))
      end
    end

    # Load Site Model
    if @model == "*" || @model == "sites"
      Dir.new(@sites_path.as(Path)).each_child do |child|
        path = Path.new(@sites_path.to_s, child)
        site = CrystalTwin::Models::Site.from_yaml(File.read(path))
        print ("# #{path.basename} Status\n")
        site.save(overwrite_flag)
        site.to_yaml(File.open(path,"w"))
      end
    end
  end
end