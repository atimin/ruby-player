Ruby Player - Ruby client library for Player (tools for robots) [![Build Status](https://secure.travis-ci.org/flipback/ruby-player.png)](http://travis-ci.org/flipback/ruby-player)

Summary
-------------------------------------
Ruby Player provide high level client library to access to Player server in pure Ruby.

This project is active developing now! *Please don't use it in serious projects.*

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

    require 'ruby-player'
    Player::Client.connect("localhost") do |robot|
      pos2d = robot.subscribe("position2d", index: 0)
      ranger = robot.subscribe(:ranger)
      pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
      #main loop
      robot.loop do
        puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.state
        puts "Rangers: #{ranger.collect { |r| r.range }}"
      end
    end

API coverage 
-------------------------------------
The list of support objects and devices of Player.

* Client object
* ActArray
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

References
-------------------------------------

[Home page](http://www.github.com/flipback/ruby-player)

[Documentation](http://rubydoc.info/gems/ruby-player/)

[Player project](http://playerstage.sourceforge.net/)

[C API Player](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__player__clientlib__libplayerc.html)

Authors
-------------------------------------

Aleksey Timin <atimin@gmail.com>
