---
layout: page
title: "Ranger"
date: 2012-06-22 00:04
comments: true
sharing: true
footer: true
---
The **ranger** proxy provides an interface to the ranger sensors built into robots.

Simple example:

{% codeblock lang:ruby %}
  require 'ruby-player'
  Player::Client.connect "localhost" do |cl|
    ranger = cl.ranger      # Subscribing 
          
    # Main loop
    cl.loop do
      ranges = ranger.collect(&:range)    # Get measures of sensors
      puts "I see: %s" % ranges.inspect
    end
  end
{% endcodeblock %}

### Measure

Ranger is container of sensors (class [Sensor]({{ site.urlroot }}/documentation/interfaces/sensor.html)) and it implements `Enumerable` interface. Example of access to sensors:
  
{% codeblock lang:ruby %}
  s = ranger[0]                # Get first sensor
  ranger.each { |s| s.range }  # Put measure ranges for all sensors
  ranger.count                 # Count of sensors in ranger  
{% endcodeblock %}

For information about sensor data see [[Sensor]] class.

### Configuration

The **ranger** interface provides access to ranger configuration:

{% codeblock lang:ruby %}
  ranger.query_config               # Request configuration data
  cl.read!                          # Read data from server
  ranger.config                     # => { min_angle: 0.0, max_angle: 0.0, angular_res: 0.0, min_range: 0.0,  
                                    # max_range: 0.0, range_res: 0.0, frequecy: 0.0 }
  ranger.set_config(max_angel:0.5)  # Set max angel to 0.5 radian
{% endcodeblock %}

For reading\writing configuration use hash with keys:

* **min_angle** - start angle of scans [rad] 
* **max_angle** - end angle of scans
* **angular_res** - scan resolution [rad]
* **min_range** -  maximum range [m]
* **max_range** - minimum range [m]
* **range_res** - range resolution [m]
* **frequency** - scanning frequency [Hz]

### Geometrical data

The *ranger* proxy provide access to geometrical data just other proxies (see [[ Geometrical data ]]). But when you query geometrical data for ranger you query geometrical data for all sensor included to ranger too.

{% codeblock lang:ruby %}
  ranger.query_geom  # Request geometrical data for ranger and all sensors.
  cl.read!           # Necessarily read buffering data from server
  ranger.geom           #=> { :px => 0.0, :py => 0.0 :pz => 0.1, :proll => 0.0, :ppitch => 0.0, 
                     # :pyaw => 0.0, sw => 0.1, :sl => 0.1, :sh => 0.05 }
{% endcodeblock %}

### More

For more information see documentation of `Ranger` class [here](http://rdoc.info/gems/ruby-player/Player/Ranger#set_config-instance_method)
