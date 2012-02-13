require 'ruby-player'
Player::Client.connect("localhost") do |robot|
  pos2d = robot.subscribe(:position2d)
  ranger = robot.subscribe(:ranger)
  #main loop
  robot.loop(0.05) do
    puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.position
    r = ranger.rangers
    puts "Rangers: #{r}"

    if r[0] < 2.5
      pos2d.set_car vx: 0.2*r[0], a: -1 / r[0]
      puts "Turn right"
      next
    end
    
    if r[1] <  2.5
      pos2d.set_car vx: 0.2*r[1], a: 1 / r[1]
      puts "Turn left"
      next
    end

    if r[0] > 2.5 && r[1] > 2.5
      pos2d.set_car vx: 0.4, a: 0
    end
  end
end
