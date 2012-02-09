Ruby Player - Ruby client library for Player (tools for robots) 

Summary
-------------------------------------
Ruby Player provide high level client library to access to Player server in pure Ruby
Currently (2012-01-07) the Ruby Player are developing and testing with Player 3.1.0 latest svn version

API coverage 
-------------------------------------
The list of support objects and devices of Player.

* Client object
* Position2d

Install
-------------------------------------

`gem install ruby-player`

Example
-------------------------------------

    require 'ruby-player'
    Player::Client.connect("localhost") do |robot|
      pos2d = robot.subscribe("position2d", index: 0)
      pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
      #main loop
      robot.loop do
        puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.position
      end
    end

References
-------------------------------------

[Home page](http://www.github.com/flipback/ruby-player)

[Player project](http://playerstage.sourceforge.net/)

[C API Player](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__player__clientlib__libplayerc.html)

Authors
-------------------------------------

Aleksey Timin <atimin@gmail.com>
