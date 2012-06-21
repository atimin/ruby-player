---
layout: page
title: "Getting started"

date: 2012-06-21 23:15
comments: true
sharing: true
footer: true
---

The RubyPlayer works with player server by TCP protocol. For begin, we must open TCP connection with server and close it in end:

{% codeblock lang:ruby %}
  require 'ruby-player'
    cl = Player::Client.new "localhost"
  # Your code
  cl.close

  #alternate syntax with block
  Player::Client.connect "localhost" do |cl|
    # Your code
  end
{% endcodeblock %}

We may set connection options:

1. **port** - TCP port for connection. It's equal 6665 by default.
2. **log_level** - Logging level equal :info by default. It may be :error, :warn, :info and :debug.

Example connection with opts: 

{% codeblock lang:ruby %}
  cl = Player::Client.new "localhost", port:9999, log_level:'debug'
{% endcodeblock %}

Next step it's subscribing to device of robot. All device have typical interface and index. For more info see documentation on [playerstage site](http://playerstage.sourceforge.net/doc/Player-svn/player/). RubyPlayer supported two way for it:

{% codeblock lang:ruby %}
  Player::Client.connect 'localhost' do |cl|
    pose = cl.subscribe(:position2d, index:1) # First method
    pose = cl.position2d(1)                   # Second method for ruby-player >= 0.6.0
  end
{% endcodeblock %}

For us result of subscribing is proxy object by which we can send command to robot, query configuration data and read current state. The RubyPlayer sends command and requests in moment of call related method, but reading data from server is implemented by client object. For example:

{% codeblock lang:ruby %}
  # subscribing code above
  pose.query_geom                 # request geom data
  pose.set_speed(vx:0.2, vy:0.4)  # set speed of robot in [m/s]

  cl.read!                        # client request buffering data from server for all proxies 

  pose.geom                       #=> Hash of geom data
  pose.state                      #=> Hash of current state
{% endcodeblock %}

For comfort, RubyPlayer has `Client#loop` method for cyclic request servers. Example of typical struct your application:

{% codeblock lang:ruby %}
  Player::Client.connect 'localhost' do |cl|
    # Subscribing
    pose = cl.position2d(1)
    # Initial commands
    pose.set_speed(vx: 0.1)
    # Cyclic request by 0.1 seconds 
    cl.loop(0.1) do
      # Your code
    end
  end
{% endcodeblock %}

That's all. Play with your robots fun=)
