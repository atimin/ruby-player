Ruby Player - Ruby client library for Player (tools for robots) [![Build Status](https://secure.travis-ci.org/flipback/ruby-player.png)](http://travis-ci.org/flipback/ruby-player)

Summary
-------------------------------------
Ruby Player provide high level client library to access to Player server in pure Ruby.

Currently (2012-01-07) the Ruby Player are developing and testing with Player 3.1.0 latest svn version

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
        puts "Rangers: #{ranger.rangers}"
      end
    end

API coverage 
-------------------------------------
The list of support objects and devices of Player.

* Client object
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
