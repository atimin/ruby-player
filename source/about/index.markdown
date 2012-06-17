---
layout: page
title: "About"
date: 2012-06-17 17:52
comments: true
sharing: true
footer: true
---

Ruby Player - client library for the Player (operation system for robots) in pure Ruby. [![Build Status](https://secure.travis-ci.org/flipback/ruby-player.png)](http://travis-ci.org/flipback/ruby-player)

Summary
-------------------------------------
Ruby Player provide high level client library to access to Player server in pure Ruby.

Why?
-------------------------------------
The Player project distributes bindings of client libraries for Ruby and Python but I think that this project has several reasons to be:

1. Pure implementation doesn't require C\C++ libraries of Player, SWIG and compilator. You can use it on any platform with installed Ruby.
2. In contrast to standard bindings Ruby Player is spreaded as gem and you can use it with Bundle, RVM and others tools which we all are loving.
3. Standard bindings doesn't use the expression of Ruby. Calls of function in C style without blocks, hashes and exceptions. 

Install
-------------------------------------

`gem install ruby-player`

Example
-------------------------------------

{% codeblock lang:ruby %}
    Player::Client.connect("localhost") do |robot|
      pos2d = robot.position2d(1)
      ranger = robot.ranger
      pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
      #main loop
      robot.loop do
        puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.state
        puts "Rangers: #{ranger.collect(&:range)}"
      end
    end
{% endcodeblock %}

API coverage 
-------------------------------------
The list of support objects and devices of Player.

* Client object
* ActArray
* AIO
* BlobFinder
* Gripper
* Position2d
* Power
* Ranger


Requirements
-------------------------------------

* Ruby 1.9.2 or later 
* Player 3.1.0 or later
* For examples Stage 4.1.0 or later

