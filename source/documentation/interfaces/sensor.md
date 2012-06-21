---
layout: page
title: "Sensor"
date: 2012-06-22 00:07
comments: true
sharing: true
footer: true
---
The **Sensor** class provides interface to sate and geometrical data of range sensor.

Example:

{% codeblock lang:ruby %}
  s = ranger[0]        # Get first sensor
  s.range              # Range data in [m]
  s.intensity          # Intensity data in [m]
{% endcodeblock %}


### State
The Sensor provides measuring data by `Sensor#state` method:

{% codeblock lang:ruby %}
  s.state              #=> { :range => 0.0, :intensity => 0.0 }
{% endcodeblock %}

Returned hash consists:

* **range** - range data in [m]
* **intensity** - data in [m]

Also you can use the same methods.

### Geometrical data

The Sensor provides geometrical data by typical method, but request is implemented by ranger proxy:
  
{% codeblock lang:ruby %}
  ranger.query_geom  # Request geometrical data for ranger and all sensors.
  cl.read!           # Necessarily read buffering data from server
  ranger[0].geom     #=> { :px => 0.0, :py => 0.0 :pz => 0.1, :proll => 0.0, :ppitch => 0.0, 
                     # :pyaw => 0.0, sw => 0.1, :sl => 0.1, :sh => 0.05 }
{% endcodeblock %}
