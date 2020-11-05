require "kemal"

before_all "/v3/*" do |env|
    env.response.headers["Access-Control-Allow-Origin"] = "*"
end

# Landing Page Endpoint
before_get "/" do |env|
    env.response.content_type = "text/html"
end

get "/" do |env|
    username = env.session.string?("username")
    if username.nil? || username != CrystalTwin::Config.username
        name = "Guest"
        is_connected = false
        render "public/landing_page/index.ecr"
    else
        name = username.split(".")[0].capitalize
        is_connected = true
        render "public/landing_page/index.ecr"
    end
end

get "/logout" do |env|
    env.session.string("username", "")
    env.session.string("email", "")
    env.redirect "/"
end