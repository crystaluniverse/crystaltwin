require "kemal"
require "kemal-session"
require "kemal-session-bcdb"

require "./config"
require "./apps/**"

# workaround until kemal really supports 0.35
# To solve non terminated responses for long responses
 class HTTP::Server::Response
    class Output
        # original definition since Crystal 0.35.0
        def close
            return if closed?

            unless response.wrote_headers?
            response.content_length = @out_count
            end

            ensure_headers_written

            super

            if @chunked
            @io << "0\r\n\r\n"
            @io.flush
            end
        end

        # patch from https://github.com/kemalcr/kemal/pull/576
        def close
            # ameba:disable Style/NegatedConditionsInUnless
            unless response.wrote_headers? && !response.headers.has_key?("Content-Range")
            response.content_length = @out_count
            end

            ensure_headers_written

            previous_def
        end

    end
end

# Add proper configuration & Start Kemal
class CrystalTwin::Server
    def self.start
        Kemal::Session.config do |config|
            config.cookie_name = CrystalTwin::Config.cookiename
            config.secret = CrystalTwin::Config.sessionsecret
            config.engine = CrystalTwin::Config.sessionengine

            # set session timeout
            sessionexpiration = CrystalTwin::Config.sessionexpiration
            
            minutes = sessionexpiration / (60)
            seconds = sessionexpiration.remainder(60)
            hours = minutes / 60
            minutes = minutes.remainder(60)

            config.timeout = Time::Span.new hours: hours.to_i32, minutes: minutes.to_i32, seconds: seconds.to_i32
        end

        Kemal.config.host_binding = CrystalTwin::Config.host
        Kemal.config.port =  CrystalTwin::Config.port
        
        env = CrystalTwin::Config.environment
        
        # Kemal only knows only production or development
        if env == "staging"
            env = "production"
        end

        Kemal.config.env = env
        
        if CrystalTwin::Config.ssl
            ssl = Kemal::SSL.new
            ssl.key_file = CrystalTwin::Config.sslkeyfile
            ssl.cert_file = CrystalTwin::Config.sslcertfile
            Kemal.config.ssl = ssl.context
        end
        Kemal.run
    end
end
