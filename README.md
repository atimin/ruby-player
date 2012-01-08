Ruby Player - Ruby client library for Player (tools for robots) 

Summary
-------------------------------------
Ruby Player provide high level client library to access to Player server. 
It are using the FFI for binding with playerc C client library. 

API coverage 
-------------------------------------
The list of support objects and devices of Player.

* Client object
* Position2d

Install
-------------------------------------
Currently (2012-01-07) the Ruby Player are developing and testing with Player 3.1.0 latest svn version
and Stage v4.1.0. See them user guides for installation. 

After installation Player/Stage run:

`gem install ruby-player`

For testing library in root dir library:

    player spec/world/test.cfg
    bundle exec rake spec

Example
-------------------------------------

    require 'ruby-player'
    Player::Client.connect("localhost") do |robot|
      pos2d = robot[:position2d, 0]
      pos2d.set_vel(1, 0, 0.2)
      robot.loop do
        puts "Position: x=#{pos2d.px}, y=#{pos2d.py}, a=#{pos2d.pa}
      end
    end

References
-------------------------------------

[Home page](http://www.github.com/flipback/ruby-player)

[Player project](http://playerstage.sourceforge.net/)

[Stage project](https://github.com/rtv/Stage)

[C API Player](http://playerstage.sourceforge.net/doc/Player-3.0.2/player/group__player__clientlib__libplayerc.html)

Authors
-------------------------------------
Aleksey Timin <atimin@gmail.com>
