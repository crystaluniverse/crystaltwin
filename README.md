# crystaltwin


## Installation

`shards install`

## Run

```
./bin/crystaltwin --seedfile ~/work/user.seed
```

### Other options

```
CrystalTwin. The ultimate digital avatar

  Usage:

    crystaltwin [options] ...

  Options:

    --secret=SECRET                  Session Secret [type:String] [default:""]
    --env=ENV                        Threebot environment (production|development|staging) [type:String] [default:"development"]
    --mnemonic=MNEMONIC              Mnemonic [type:String] [default:""]
    --dbsocket=SOCKET                Bcdb unix socket file [type:String] [default:"/tmp/bcdb.sock"]
    --dbnamespace                    Bcdb namespace [type:String] [default:"crystaltwin"]
    --host=HOST                      Host [type:String] [default:"0.0.0.0"]
    --port=PORT                      Port [type:Int32] [default:3000]
    --ssl=SSL                        SSL enabled [type:Bool] [default:false]
    --key=KEYFILE                    SSL Key file [type:String] [default:""]
    --cert=CERTFILE                  SSL Cert file [type:String] [default:""]
    --cookie-name=COOKIENAME         Cookie name [type:String] [default:"crystaltwin"]
    --session-expiration=HOURS       Session expiration in hours [type:Int32] [default:720]
    --threebot-id=ID                 3 bot ID [type:Int32] [default:-1]
    --threebot-name=USERNAME         3 bot Username [type:String] [default:""]
    --threebot-url=URL               3 bot connect URL [type:String] [default:""]
    --openkyc-url=URL                3 bot connect openkyc URL [type:String] [default:""]
    --seedfile=SEEDFILE              Seed file [type:String]
    --explorer=EXPLORER              Seed file [type:String] [default:""]
    --help                           Show this help.
    --version                        Show version.

  Sub Commands:

    load    load yaml files into database. Run crystaltwin load --help for more info
    dumps   dump yaml files into data directory. Run crystaltwin dump --help for more info
```

## Use seed & socket files being used by the local bcdb

- Run : `./bin/crystaltwin --dbsocket /home/hamdy/work/chat/bcdb1.sock --seedfile ~/work/user.seed`

## seedfile example :
  ```
  "1.1.0"{"mnemonic":"crop orient animal script safe inquiry neglect tumble maple board degree you intact busy birth west crack cabin lizard embark seed adjust around talk","threebotid":1607}
  ```
