require "http/client"
require "json"

require "clim"
require "mnemonic"

require "./logging"
require "./config"
require "./server"
require "./macros"

module CrystalTwin

  # Temporary class to load json response from explorer when resoliving threebot ID into name
  # Only used if --threebot-name is not provided
  class ThreebotUser
    include JSON::Serializable

    property name : String
  end

  class Cli < Clim
    main do
      desc "CrystalTwin. The ultimate digital avatar"
      usage "crystaltwin [options] ..."
      version "Version 0.1.0"
      option "--secret=SECRET", type: String, desc: "Session Secret", default: ""
      option "--env=ENV", type: String, desc: "Threebot environment (production|development|staging)", default: "development"
      option "--mnemonic=MNEMONIC", type: String, desc: "Mnemonic", default: ""
      option "--dbsocket=SOCKET", type: String, desc: "Bcdb unix socket file", default: "/tmp/bcdb.sock"
      option "--dbnamespace", type: String, desc: "Bcdb namespace", default: "crystaltwin"
      option "--host=HOST", type: String, desc: "Host", default: "0.0.0.0"
      option "--port=PORT", type: Int32, desc: "Port", default: 3000
      option "--ssl=SSL", type: Bool, desc: "SSL enabled", default: false
      option "--key=KEYFILE", type: String, desc: "SSL Key file", default: ""
      option "--cert=CERTFILE", type: String, desc: "SSL Cert file", default: ""
      option "--cookie-name=COOKIENAME", type: String, desc: "Cookie name", default: "crystaltwin"
      option "--session-expiration=HOURS", type: Int32, desc: "Session expiration in hours", default: 720
      option "--threebot-id=ID", type: Int32, desc: "3 bot ID", default: -1
      option "--threebot-name=USERNAME", type: String, desc: "3 bot Username", default: ""
      option "--threebot-url=URL", type: String, desc: "3 bot connect URL", default: ""
      option "--openkyc-url=URL", type: String, desc: "3 bot connect openkyc URL", default: ""
      option "--seedfile=SEEDFILE", type: String, desc: "Seed file"
      option "--explorer=EXPLORER", type: String, desc: "Seed file", default: ""
     
      run do |opts|

        # Required to silent kemal, otherwise it takes them
        ARGV.clear
        
        env = opts.env
        if env != "development" && env != "production" && env != "staging"
          err("--env must be one of (development|production|staging)\n")
          exit 1
        end

        if env == "production" && opts.secret == ""
          err("--secret is required if you are running a production environment")
          exit 1
        end

        if opts.ssl && (opts.key == "" || opts.cert == "")
          err("--key and --cert are required when SSL is enabled\n")
          exit 1
        end
        
        if opts.seedfile.nil? && (opts.threebot_id == -1 || opts.mnemonic == "")
          err("use --seedfile=SEEDFILE OR both --threebot-id=ID AND --mnemonic=MNEMONIC")
          exit 1
        end

        # Get threebot userid && username
        threebotid = opts.threebot_id
        mnemonic = opts.mnemonic
        threebotname = opts.threebot_name

        if opts.seedfile
          d = File.read(opts.seedfile.not_nil!).gsub("\"1.1.0\"", "")
          data = JSON.parse(d)
          threebotid = data["threebotid"].to_s.to_i32
          mnemonic = data["mnemonic"].to_s
        end
                
        # Set Global configurations 

        ## set environment
        ## if production, use explorer production url, 3bot connect production
        ## if staging or development use explorer dev url, 3bot connect staging
        ## you can still use production environement and override the 3bot connect and explorer urls
        ## by providing --explorer , --threebot-url , --openkyc-url 
        CrystalTwin::Config.set_environment opts.env
        
        if opts.explorer != ""
          CrystalTwin::Config.set_explorer opts.explorer
        end

        if opts.threebot_url != ""
          CrystalTwin::Config.set_threeboturl opts.threebot_url
        end

        if opts.openkyc_url != ""
          CrystalTwin::Config.set_openkycurl opts.openkyc_url
        end
        
        CrystalTwin::Config.set_userid threebotid
        CrystalTwin::Config.set_keys mnemonic

        ## If threebot name is not provided, try resolving from explorer
        if threebotname == ""
          log "Threebot name is not provided, Trying to resolve user ID #{threebotid.to_s} from explorer #{CrystalTwin::Config.explorer}", 2
          response = HTTP::Client.get url: %(#{CrystalTwin::Config.explorer}/users/) + threebotid.to_s, headers: HTTP::Headers{"Content-Type" => "application/json"}
          if ! response.status_code == 200
              err "Can not resolve threebot user ID #{threebotid.to_s} from #{CrystalTwin::Config.explorer}"
              exit 1
          else
            user = ThreebotUser.from_json(response.body)
            threebotname = user.name
            CrystalTwin::Config.set_username threebotname
            
          end
        end

        # Set Database & db session engine connection 
        CrystalTwin::Config.set_db socketfile: opts.dbsocket, namespace: opts.dbnamespace

        # Set Kemal options
        
        ## secret is required to be passed in production, otherwise it gets a default value for development
        if opts.secret != ""
          CrystalTwin::Config.set_sessionsecret opts.secret
        end

        CrystalTwin::Config.set_host opts.host
        CrystalTwin::Config.set_port opts.port
        CrystalTwin::Config.set_ssl opts.ssl
        CrystalTwin::Config.set_sslkeyfile opts.key
        CrystalTwin::Config.set_sslcertfile opts.cert
        CrystalTwin::Config.set_sessionexpiration opts.session_expiration
        CrystalTwin::Config.set_cookiename opts.cookie_name

        # Initializing apps
        CrystalTwin::Macros::Apps.init_apps
        
        # Some logging before starting
        log "Starting Crystaltwin with environment #{env}", 1
        log "Starting Crystaltwin with username #{threebotname}", 1
               
        # Start kemal webserver
        CrystalTwin::Server.start
      end

      sub "load" do
        desc "load yaml files into database. Run crystaltwin load --help for more info"
        usage "crystaltwin load [options]"
        option "--overwrite",  type: String, desc: "Overwrite if exists"
        option "--only",  type: String, desc: "load only this certain file"
        option "--dir=DDIR",  type: String, desc: "load files from this dir"
        option "--model=MODEL",  type: String, desc: "load only all files for this model"
        option "--dbsocket=SOCKET", type: String, desc: "Bcdb unix socket file", default: "/tmp/bcdb.sock"
        option "--dbnamespace", type: String, desc: "Bcdb namespace", default: "crystaltwin"

        run do |opts, args|
          if opts.dir
            CrystalTwin::Cmd::Load.config data_path: opts.dir.to_s, socketfile: opts.dbsocket, namespace: opts.dbnamespace
          else
            CrystalTwin::Cmd::Load.config socketfile: opts.dbsocket, namespace: opts.dbnamespace
          end

          overwrite_flag = false

          if opts.overwrite
            overwrite_flag = true
          end

          if opts.only
            # ToDO later
          end

          if opts.model
            CrystalTwin::Cmd::Load.set_model(opts.model.to_s)
          end

          CrystalTwin::Cmd::Load.load(overwrite_flag)
        end
      end

      sub "dumps" do
        desc "dump yaml files into data directory. Run crystaltwin dump --help for more info"
        usage "crystaltwin dumps [options]"
        option "--overwrite",  type: String, desc: "Overwrite if exists"
        option "--dir=DDIR",  type: String, desc: "dumo files into this dir"
        option "--model=MODEL",  type: String, desc: "dump only files for this model"
        option "--object=ID",  type: String, desc: "dump only this object"
        option "--dbsocket=SOCKET", type: String, desc: "Bcdb unix socket file", default: "/tmp/bcdb.sock"
        option "--dbnamespace", type: String, desc: "Bcdb namespace", default: "crystaltwin"

        run do |opts, args|
          if opts.dir 
            CrystalTwin::Cmd::Dumps.config data_path: opts.dir.to_s, socketfile: opts.dbsocket, namespace: opts.dbnamespace
          else
            CrystalTwin::Cmd::Dumps.config socketfile: opts.dbsocket, namespace: opts.dbnamespace
          end

          overwrite_flag = false

          if opts.overwrite
            overwrite_flag = true
          end

          if opts.object
            # ToDO later
          end

          if opts.model
            CrystalTwin::Cmd::Dumps.set_model(opts.model.to_s)
          end

          CrystalTwin::Cmd::Dumps.dumps(overwrite_flag)
        end
      end
    end
  end
end

CrystalTwin::Cli.start(ARGV)
