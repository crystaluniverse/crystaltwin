require "yaml"
require "json"
require "bcdb"

require "../models"
require "../../config"

class CrystalTwin::Cmd::Load
  @@data_path
  @@model
  @@persons_path
  @@circles_path
  @@topics_path
  @@epics_path
  @@sites_path

  def self.config(data_path : String = "#{__DIR__}/../../../data", socketfile = "/tmp/bcdb.sock", namespace = "crystaltwin")
    @@model = "*"
    @@data_path = data_path
    @@persons_path = Path.new(@@data_path.to_s, "persons")
    @@circles_path = Path.new(@@data_path.to_s, "circles")
    @@topics_path = Path.new(@@data_path.to_s, "topics")
    @@epics_path = Path.new(@@data_path.to_s, "epics")
    @@sites_path = Path.new(@@data_path.to_s, "sites")
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
    # Load Person Model
    if @@model == "*" || @@model == "person"
      Dir.new(@@persons_path.as(Path)).each_child do |child|
        path = Path.new(@@persons_path.to_s, child)
        person = CrystalTwin::Models::Person.from_yaml(File.read(path))
        if person.id == 0 || overwrite_flag
          person.save
          person.to_yaml(File.open(path,"w"))
          log("#{path.basename} loaded to the database at entry ##{person.id}",1)
        else
          log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
        end
      end
    end

    # Load Circle Model
    if @@model == "*" || @@model == "circle"
      Dir.new(@@circles_path.as(Path)).each_child do |child|
        path = Path.new(@@circles_path.to_s, child)
        circle = CrystalTwin::Models::Circle.from_yaml(File.read(path))
        if circle.id == 0 || overwrite_flag
          circle.save
          circle.to_yaml(File.open(path,"w"))
          log("#{path.basename} loaded to the database at entry ##{circle.id}",1)
        else
          log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
        end
      end
    end

    # Load Topic Model
    if @@model == "*" || @@model == "topic"
      Dir.new(@@topics_path.as(Path)).each_child do |child|
        path = Path.new(@@topics_path.to_s, child)
        topic = CrystalTwin::Models::Topic.from_yaml(File.read(path))
        if topic.id == 0 || overwrite_flag
          topic.save
          topic.to_yaml(File.open(path,"w"))
          log("#{path.basename} loaded to the database at entry ##{topic.id}",1)
        else
          log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
        end
      end
    end

    # Load Epic Model
    if @@model == "*" || @@model == "epics"
      Dir.new(@@epics_path.as(Path)).each_child do |child|
        path = Path.new(@@epics_path.to_s, child)
        epic = CrystalTwin::Models::Epic.from_yaml(File.read(path))
        if epic.id == 0 || overwrite_flag
          epic.save
          epic.to_yaml(File.open(path,"w"))
          log("#{path.basename} loaded to the database at entry ##{epic.id}",1)
        else
          log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
        end
      end
    end

    # Load Site Model
    if @@model == "*" || @@model == "sites"
      Dir.new(@@sites_path.as(Path)).each_child do |child|
        path = Path.new(@@sites_path.to_s, child)
        site = CrystalTwin::Models::Site.from_yaml(File.read(path))
        if site.id == 0 || overwrite_flag
          site.save
          site.to_yaml(File.open(path,"w"))
          log("#{path.basename} loaded to the database at entry ##{site.id}",1)
        else
          log("#{path.basename} already in the database\nplease add --overwrite to your command\n", 2)
        end
      end
    end
  end
end