require "kemal"
require "kemal-session"
require "kemal-session-bcdb"
require "swagger"

require "./apps/app"
require "./apps/models"

APPS = {{CrystalTwin::App.subclasses}}
MODELS = {{CrystalTwin::Models::Model.subclasses}}


class CrystalTwin::Config
    # Threebot info
    @@userid = 0
    @@username = ""
    @@seed = ""
    @@publickey = ""
    @@secretkey = ""
   
    # Environment
    @@environment = "production"
    @@explorer = "https://explorer.devnet.grid.tf/explorer"
    @@threeboturl = "https://login.staging.jimber.org"
    @@openkycurl = "https://openkyc.staging.jimber.org/verification/verify-sei"
    
    # Database
    @@socketfile = "/tmp/bcdb.sock"
    @@dbnamespace = "crystaltwin"
    @@dbnamespacesession = "crystaltwin::sessions"
    @@database : Bcdb::Client? = nil

    # Kemal
    @@host = ""
    @@port = 0
    @@ssl = false
    @@sslkeyfile = ""
    @@sslcertfile = ""
    @@sessionsecret = "22b51a8e38564939a5285404793ac1af" # only for development, in production user is required to pass secret
    @@sessionexpiration = 720 # hours
    @@cookiename = "crystaltwin"
    @@sessionengine : Kemal::Session::BcdbEngine? = nil

    # Apps
    @@apps = [] of String 

    # Models
    @@models = []of CrystalTwin::Models::Model
    
    # Threebot info
    
    ## set crystal twin threebot user id
    def self.set_userid(userid)
        @@userid = userid
    end

    ## get crystal twin threebot user id
    def self.userid
        @@userid
    end

    ## set crystal twin threebot user name
    def self.set_username(username)
        @@username = username
    end

    ## get crystal twin threebot user name
    def self.username
        @@username
    end

    ## set public & secret keys from seedphrase/mnemonic
    def self.set_keys(mnemonic)
        en = Mnemonic::Mnemonic.new
        secretkey = en.get_signing_key mnemonic
        publickey = secretkey.public_key
        
        @@seed = Base64.strict_encode(secretkey.seed.to_slice)
        @@secretkey = Base64.strict_encode(secretkey)
        @@publickey = Base64.strict_encode(publickey)

    end

    ## get seed for this digital twin user
    def self.seed
        @@seed
    end

    ## get public key for this digital twin user
    def self.publickey
        @@publickey
    end

    ## get secret key for this digital twin user
    def self.secretkey
        @@secretkey
    end


    #---------------------------------------------------------------#

    # Environment

    ## set environment (production, staging, development)
    def self.set_environment(environment)
        @@environment = environment
        if environment == "production"
            @@explorer = "https://explorer.devnet.grid.tf/explorer"
            @@threeboturl = "https://login.threefold.me"
            @@openkycurl = "https://openkyc.live/verification/verify-sei"
        end
    end

    ## get environment (production, staging, development)
    def self.environment
        @@environment
    end

    ## set explorer URL
    def self.set_explorer(url)
        @@explorer = url.rstrip("/")
    end

    ## get explorer URL
    def self.explorer
        @@explorer
    end

    ## set threebot connect URL
    def self.set_threeboturl(url)
        @@threeboturl = url.rstrip("/")
    end

    ## get threebot connect URL
    def self.threeboturl
        @@threeboturl
    end

    ## set threebot connect openkyc URL
    def self.set_openkycurl(url)
        @@openkycurl = url.rstrip("/")
    end

    ## get threebot connect openkyc URL
    def self.openkycurl
        @@openkycurl
    end


    #---------------------------------------------------------------#

    # Database

    ## set database
    def self.set_db(socketfile="/tmp/bcdb.sock", namespace="crystaltwin", namespacesession="crystaltwin::sessions")
        @@socketfile = socketfile
        @@dbnamespace = namespace
        @@dbnamespacesession = namespacesession
        @@db = Bcdb::Client.new unixsocket: socketfile, db: "db", namespace: namespace
        @@sessionengine = Kemal::Session::BcdbEngine.new(unixsocket= socketfile, namespace = "crystaltwin_sessions", key_prefix = "crystal:twin:session:")
    end
    
    ## get socket file
    def self.socketfile
        @@socketfile
    end

    ## get database namespace
    def self.dbnamespace
        @@dbnamespace
    end

    ## get database namespace for sessions
    def self.dbnamespacesession
        @@dbnamespacesession
    end

    ## get database
    def self.db
        @@db.not_nil!
    end

    ## get session engine
    def self.sessionengine
        @@sessionengine.not_nil!
    end

    #---------------------------------------------------------------#

    # Kemal
    
    ## set host
    def self.set_host(host)
        @@host = host
    end

    ## get host
    def self.host
        @@host
    end

    ## set port
    def self.set_port(port)
        @@port = port
    end

    ## get port
    def self.port
        @@port
    end

    ## enable/disable ssl 
    def self.set_ssl(enabled)
        @@ssl = enabled
    end

    ## get ssl state
    def self.ssl
        @@ssl
    end

    ## set ssl keyfile path
    def self.set_sslkeyfile(path)
        @@sslkeyfile = path
    end

    ## get ssl keyfile path
    def self.sslkeyfile
        @@sslkeyfile
    end

    ## set ssl certfile path
    def self.set_sslcertfile(path)
        @@sslcertfile = path
    end

    ## get ssl certfile path
    def self.sslcertfile
        @@sslcertfile
    end

    ## set session secret key
    def self.set_sessionsecret(secret)
        @@sessionsecret = secret
    end

    # get session secret key
    def self.sessionsecret
        @@sessionsecret
    end

    def self.set_sessionexpiration(hours)
        @@sessionexpiration = hours
    end

    def self.sessionexpiration
        @@sessionexpiration
    end

    # set cookie name
    def self.set_cookiename(cookiename)
        @@cookiename = cookiename
    end

    # get cookie name
    def self.cookiename
        @@cookiename
    end

    #-------------------------------------------------------------#
    
    # Apps

    ## List all apps in the system
    def self.apps
        APPS
    end

    #-------------------------------------------------------------#

    # Models
    
    ## List all models in the system
    def self.models
        MODELS
    end
end