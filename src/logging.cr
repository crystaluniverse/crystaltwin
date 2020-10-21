require "colorize"

macro log(msg, level = 5)
  
    if {{level}} == 1 || {{level}} == 2 || {{level}} == 3
      msg1 = {{msg}}
      #expand to 25
      ffrom = {{ @type.stringify }}.downcase()[0,25].ljust(25)
      msg2 = " - #{ffrom} : #{msg1}" 
      {% if level == 1 %}
      puts msg2.colorize(:green)
      {% elsif level == 2 %}
      puts msg2.colorize(:yellow)
      {% elsif level == 3 %}
      puts msg2.colorize(:red)
      {% else %}
      puts msg2.colorize(:light_gray)
      {% end %}
    
    end
  end
  
  # don't rename as (error) because it conflicts with kemal preventing it from running
  macro err(msg, extra = "")
    puts {{msg}}.colorize(:red)
    {% if extra %}
    puts {{extra}}
    {% end %}
    exit 1
  end