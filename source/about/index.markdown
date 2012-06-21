---
layout: page
title: "About"
date: 2012-06-17 17:52
comments: false
sharing: true
footer: true
---

The **RubyPlayer** is a client library for the [Player](http://playerstage.sourceforge.net/) in pure Ruby.

Why?
-------------------------------------
The Player project distributes bindings of client libraries for Ruby and Python but I think that this project has several reasons to be:

1. Pure implementation doesn't require C\C++ libraries of Player, SWIG and compilator. You can use it on any platform with installed Ruby.
2. In contrast to standard bindings RubyPlayer is spreaded as gem and you can use it with Bundle, RVM and others tools which we all are loving.
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
The list of support objects and devices of the Player can see [here]( {{ site.urlroot }}/documentation/interfaces/ ).

Requirements
-------------------------------------

* Ruby 1.9.2 or later 
* Player 3.1.0 or later
* For examples Stage 4.1.0 or later

