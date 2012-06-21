---
layout: page
title: "position2d"
date: 2012-06-22 00:00
comments: true
sharing: true
footer: true
---


sition2d** proxy provides an interface to a mobile robot base

Simple example:

{% codeblock lang:ruby %}
  require 'ruby-player'
  Player::Client.connect "localhost" do |cl|
    p2d = cl.postion2d      # Subscribing 
    p2d.set_speed(vx: 0.2)  # Set forward speed robots to 0.2 m/s
    
    # Main loop
    cl.loop do
      puts "Current postition: px=%{px}, py=%{py}, pa=%{pa}" % p2d.state
    end
  end
{% endcodeblock %}

### State

The **position2d** provides data about current state: position, speed and motor state of robot by method `Position2d#state` in hash:

{% codeblock lang:ruby %}
  p2d.state #=> { :px => 1.2, :py => 0.0, :pa => 0.0, :vx => 0.2, :vy => 0.0, :va => 0.0, :stall => 1 }
{% endcodeblock %}

Keys of this hash:

* px - x coordinate [m]
* py - y coordinate [m]
* pa - angle [rad] 
* vx - forward speed [m/s]
* vy - sideways speed [m/s]
* va - rotational speed [rad/s]
* stall - state of motor

Also, position2d have method for short access to this data:

{% codeblock lang:ruby %}
  p2d.px
  p2d.va
  p2d.power?
  ....
{% endcodeblock %}

### Geometrical data

You may require geometrical parameters your robot in its coordinate system (CS) by `Position2d#query_geom`:

{% codeblock lang:ruby %}
  p2d.query_geom     # Request geometrical data
  cl.read!           # Necessarily read buffering data from server
  p2d.geom           #=> { :px => 0.0, :py => 0.0 :pz => 0.1, :proll => 0.0, :ppitch => 0.0, :pyaw => 0.0, :sw => 0.1, :sl => 0.1, :sh => 0.05 }
{% endcodeblock %}

About geometrical data see [Geometrical data]({{ site.urlroot }}/documentation/interfaces/geom.html).

### Main commands

 You can control speed or position your robot by several methods:

#### Position#set_speed 

Full call:
 
{% codeblock lang:ruby %}
  p2d.set_speed(vx: 0.1, vy: 0.1, va: 0.1, stall:1)
{% endcodeblock %}
 
parameters:  

  * vx - forward speed [m/s]
  * vy - sideways speed [m/s]
  * va - rotational speed [rad/s]
  * stall - state of motor

If you don't define all parameters the RubyPlayer initializes its with currently values automatically:

{% codeblock lang:ruby %}
  p2d.set_speed(vx:0.1)  #=> Eql p2d.set_speed(vx:0.1, vy:0.1, :va:0.0, stall:1) 
                        # if state => { ..., :vy => 0.1, :va => 0.0, :stall => 1 }
{% endcodeblock %}

#### Position#set_car

This method different `Position#set_speed` by that set angle (`:a` - parameter) motion instead angle speed. Angle is deviation from current angle in robot CS (`:pa`). Full call:
 
{% codeblock lang:ruby %}
  p2d.set_car(vx: 0.1, vy: 0.1, a: 0.1, stall:1)
{% endcodeblock %}

Also as `#set_speed` this method determines all non-defined parameters automatically.

#### Position#stop!

For simple stopping of robot:
  
{% codeblock lang:ruby %}
  p2d.stop!  #=> Eql set_speed(vx: 0, vy: 0, va: 0)
{% endcodeblock %}


### More

The **position2d** proxy has many more methods to control motion of robots. Probably, it is not needed in your project. However you can get information about all methods [here](http://rdoc.info/gems/ruby-player/Player/Position2d).
