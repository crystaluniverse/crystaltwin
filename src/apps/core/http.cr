require "kemal"

before_all "/v3/*" do |env|
    env.response.headers["Access-Control-Allow-Origin"] = "*"
end
