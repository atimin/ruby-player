require 'ruby-player'
Player::Client.connect("localhost") do |robot|
  pos2d = robot.subscribe(:position2d)
  pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
  #main loop
  robot.loop do
    puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.position
  end
end
