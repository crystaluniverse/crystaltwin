class CrystalTwin::App
    def self.basename : String
        self.name.split(":")[-1].downcase
    end

    def basename
        self.class.basename
    end

    def self.fullname : String
        self.name.downcase
    end

    def fullname
        self.class.name.downcase
    end
end