---
layout: page
title: "ActArray"
date: 2012-06-21 23:43
comments: true
sharing: true 
footer: true
---

The **actuator array** interface provides access to an array of actuators(joints).

Simple example:

{% codeblock lang:ruby %}
  require 'ruby-player'
  Player::Client.connect "localhost" do |cl|
    aary = cl.actarray          # Subscribing 

    aary.go_home!               # Command to go to home position for all actuators(joints)
    aary.set_position([0, 2, 1] # Set position for first three actuators in [rad or m]
    aary[0].set_position(1)     # Set position for first actuator [rad or m]
  end
{% endcodeblock %}

### State

The class `ActArray` provide only motor state for current data. The [Actuator]({{ site.urlroot }}/documentation/interfaces/actuator.html) class has been implemented to provide current state data of separate actuator:

{% codeblock lang:ruby %}
  aary.state   #=> { :motor_state => 1 }
  aary.power?  #=> true
{% endcodeblock %}

### Geometrical data

You may require geometrical parameters arrays in robot's coordinate system (CS) by `ActArray#query_geom` method (see [Geometrical data]({{ site.urlroot }}/documentation/interfaces/geom.html)):

{% codeblock lang:ruby %}
  aary.query_geom     # Request geometrical data
  cl.read!            # Necessarily read buffering data from server
  aary.geom           #=> { :px => 0.0, :py => 0.0 :pz => 0.1, :proll => 0.0, :ppitch => 0.0, :pyaw => 0.0 }
{% endcodeblock %}

### Commands

The `ActArray` provides several commands for actuators control. If you want control a separate actuator(joint) use [Actuator]({{ site.urlroot }}/documentation/interfaces/actuator.html) class. Example of main commands:

{% codeblock lang:ruby %}
  arry.power_on!              # Turn on array
  aary.go_home!               # Go to home position for all actuators(joints)
  aary.set_positions([1,2])   # Set position for first two actuators in [rad or m]
  aary.set_speeds([0.1, 0.2]) # Tells all joints(actuators) to attempt to move with the given speed.
  aary.power_off!             # Turn off array
{% endcodeblock %}

You can see others commands [here](http://rdoc.info/gems/ruby-player/Player/ActArray).
