require "yaml"
require "json"
require "bcdb"

require "../models"
require "../../config"

class CrystalTwin::Cmd::Dump
  property data_path
  property model
  property persons_path
  property circles_path
  property topics_path
  property epics_path
  property sites_path

  def initialize(@data_path = Path.new(__DIR__, "..", "..", "..", "dump_data"))
    @model = "*"
    @persons_path = Path.new(self.data_path, "persons")
    @circles_path = Path.new(self.data_path, "circles")
    @topics_path = Path.new(self.data_path, "topics")
    @epics_path = Path.new(self.data_path, "epics")
    @sites_path = Path.new(self.data_path, "sites")
    if !Dir.exists?(data_path)
      Dir.mkdir(@data_path)
      Dir.mkdir(@persons_path.as(Path))
      Dir.mkdir(@circles_path.as(Path))
      Dir.mkdir(@topics_path.as(Path))
      Dir.mkdir(@epics_path.as(Path))
      Dir.mkdir(@sites_path.as(Path))
    end
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

  def dump(overwrite_flag : Bool = false)
    # Dump Person Model
    if @model == "*" || @model == "person"
      persons_entries = CrystalTwin::Models::Person.list
      persons_entries.each do |key|
        file_path = @persons_path.to_s + "/person#{key.to_s}.yaml"
        if File.exists?(file_path) && !overwrite_flag
          log("#{File.basename(file_path)} is already exist\nplease add --overwrite to your command\n", 2)
        else
          file = File.new(file_path, "w+")
          person = CrystalTwin::Models::Person.get(key)
          person.to_yaml(file)
          log("Data dumped from database to #{File.basename(file_path)}",1)
        end
      end
    end

    # # Dump Circle Model
    if @model == "*" || @model == "circle"
      circles_entries = CrystalTwin::Models::Circle.list
      circles_entries.each do |key|
        file_path = @circles_path.to_s + "/cicle#{key.to_s}.yaml"
        if File.exists?(file_path) && !overwrite_flag
          log("#{File.basename(file_path)} is already exist\nplease add --overwrite to your command\n", 2)
        else
          file = File.new(file_path, "w+")
          circle = CrystalTwin::Models::Circle.get(key)
          circle.to_yaml(file)
          log("Data dumped from database to #{File.basename(file_path)}",1)
        end
      end
    end

    # # Dump Topic Model
    if @model == "*" || @model == "topic"
      topics_entries = CrystalTwin::Models::Topic.list
      topics_entries.each do |key|
        file_path = @topics_path.to_s + "/topic#{key.to_s}.yaml"
        if File.exists?(file_path) && !overwrite_flag
          log("#{File.basename(file_path)} is already exist\nplease add --overwrite to your command\n", 2)
        else
          file = File.new(file_path, "w+")
          topic = CrystalTwin::Models::Topic.get(key)
          topic.to_yaml(file)
          log("Data dumped from database to #{File.basename(file_path)}",1)
        end
      end
    end

    # # Dump Epic Model
    if @model == "*" || @model == "epics"
      epics_entries = CrystalTwin::Models::Epic.list
      epics_entries.each do |key|
        file_path = @epics_path.to_s + "/epic#{key.to_s}.yaml"
        if File.exists?(file_path) && !overwrite_flag
          log("#{File.basename(file_path)} is already exist\nplease add --overwrite to your command\n", 2)
        else
          file = File.new(file_path, "w+")
          epic = CrystalTwin::Models::Epic.get(key)
          epic.to_yaml(file)
          log("Data dumped from database to #{File.basename(file_path)}",1)
        end
      end
    end

    # # Dump Site Model
    if @model == "*" || @model == "sites"
      sites_entries = CrystalTwin::Models::Site.list
      sites_entries.each do |key|
        file_path = @sites_path.to_s + "/site#{key.to_s}.yaml"
        if File.exists?(file_path) && !overwrite_flag
          log("#{File.basename(file_path)} is already exist\nplease add --overwrite to your command\n", 2)
        else
          file = File.new(file_path, "w+")
          site = CrystalTwin::Models::Site.get(key)
          site.to_yaml(file)
          log("Data dumped from database to #{File.basename(file_path)}",1)
        end
      end
    end
  end
end
