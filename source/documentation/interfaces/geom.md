---
layout: page
title: "Geometrical data"
date: 2012-06-21 23:53
comments: true
sharing: true
footer: true
---
The RubyPlayer provides an unified way to get geometrical data in robot's coordinate systems (CS):

{% codeblock lang:ruby %}
  proxy.query_geom    # Request geometrical data for any proxy and all sensors.
  client.read!        # Necessarily read buffering data from server
  proxy.geom          #=> { :px => 0.0, :py => 0.0 :pz => 0.1, :proll => 0.0, :ppitch => 0.0, 
                      # :pyaw => 0.0, sw => 0.1, :sl => 0.1, :sh => 0.05 }
{% endcodeblock %}

Keys of geom hash:

position:

* px - x coordinate [m]
* py - y coordinate [m]
* pz - z coordinate [m] 
* proll - roll [rad]
* ppitch - pitch [rad]
* pyaw - yaw [rad]

size:

* sw - width [m]
* sl - length [m]
* sh - height [m]
