require "kemal"
require "threebot"

require "./config"

include Threebot

# Try setting seed at request time because at then, we have access
# to a singleton config object that is fully initialized
# otherwise config is empty because this module contents are executed before the initialization
# crystaltwin main module
before_all "/threebot/*" do |env|
    Threebot.set_seed(CrystalTwin::Config.seed)
    Threebot.set_threebot_login_url(CrystalTwin::Config.threeboturl)
    Threebot.open_kyc_url(CrystalTwin::Config.openkycurl)
end

# Exclude some URLs from being authenticated with 3bot like /api , ..
before_all "/*" do |env|
    excluded = [] of String 
    excluded <<  "/threebot/login"
    excluded <<  "/threebot/callback"
    excluded << "/threebot/login/url"
    excluded << "/api"
    excluded << "/v3/swagger.json"
    excluded << "/"

    found = false

    excluded.each do |path|
        if env.request.resource.starts_with?(path) || env.request.resource == path
            found = true
            break
        end
    end

    if !found
        username = env.session.string?("username")
        if username.nil? || username != CrystalTwin::Config.username
            halt env, status_code: 403, response: "Forbidden, your 3 bot connect username must match one used to run Crystaltwin"
      end
    end
end


# After successful login with 3 bot
def threebot_login(env, email, username)
    if username != CrystalTwin::Config.username
        env.response.status_code = 401
        env.response.print "Not Authorized, your 3 bot connect username must match one used to run Crystaltwin"
        env.response.close
    else
        env.session.string("username", username)
        env.session.string("email", email)
        env.redirect "/"
    end
end