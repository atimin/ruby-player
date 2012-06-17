---
layout: post
title: "RubyPlayer-0.6.0 has been released"
date: 2012-06-17 21:17
comments: true
categories: 
---

I glad to report about a new minor release of **RubyPlayer**. Now you can subscribe interfaces with
shorter syntax:

{% codeblock lang:ruby %}
require 'ruby-player'

Player::Client.connect "localhost" do |robot|
  # subscribe to :ranger interface (default index=0)
  ranger = robot.ranger # Instead of robot.subscribe(:ranger)
  # or with index
  ranger = robot.ranger(2) # Instead of robot.subscribe(:ranger, index: 2)
end
{% endcodeblock %}

<!-- more -->

The library supports [aio](http://playerstage.sourceforge.net/doc/Player-svn/player/group__interface__aio.html) interface 
for analog I\O siense this version:

{% codeblock lang:ruby %}
aio = robot.aio
aio.voltages #=> [0.2, 0.6, 0.7] - Voltages from 0 to 5 V
aio[1] = 0.3 # Set voltage on #1 output
{% endcodeblock %}

Also I have cleaned code and deleted deprecated methods.

Regards, [@flipback](https://github.com/flipback).
