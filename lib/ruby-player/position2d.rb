# Ruby Player - Ruby client library for Player (tools for robots) 
#
# Copyright (C) 2012  Timin Aleksey
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

module Player
  # The position2d proxy provides an interface to a mobile robot base
  #
  # @example
  #   # get proxy object
  #   pos2d = client.subcribe(type: "position2d", index: 0)
  #   # setup speed of robot
  #   pos2d.set_speed(vx: 1.2, vy: 0.1, va: 0.3)
  #
  #   #update data from server
  #   client.read
  #   #read velocityand position by X,Y and angle
  #   pos2d.speed #=> { :vx => 1.2, :vy => 0.1, :va => 0.3 }
  #   pos2d.odometry #=> { :px => 0.2321, :py => 0,01, :pa => 0.2 }
  #   pos2d.stop 
  class Position2d < Device
    def initialize(addr, client, log_level)
      super
      @pos2d = {px: 0.0, py: 0.0, pa: 0.0, vx: 0.0, vy: 0.0, va: 0.0, stall: 0}
      @geom = {px: 0.0, py: 0.0, pz: 0.0, roll: 0.0, pitch: 0.0, yaw: 0.0, sw: 0.0, sl: 0.0, sh: 0.0}
    end

    #Query robot geometry 
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_GET_GEOM)
      self
    end
   
    # Turn on motor
    def turn_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [1].pack("N")) 
      self
    end
    
    # Turn off motor
    def turn_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [0].pack("N")) 
      self
    end

    def direct_speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [0].pack("N"))
      self
    end

    def separate_speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [1].pack("N"))
      self
    end

    def position_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [0].pack("N"))
      self
    end

    def speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [1].pack("N"))
      self
    end

    # Set odometry of robot.
    # @param [Hash] odometry 
    # @option odometry :px x position (m)
    # @option odometry :py y position (m)
    # @option odometry :pa angle (rad).     
    # @return self
    def set_odometry(odom)
      data = [
        odom[:px].to_f,
        odom[:py].to_f,
        odom[:pa].to_f
      ]
      
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SET_ODOM, data.pack("GGG"))
      self
    end

    # Set speed PID paramters
    # @param [Hash] PID params
    # @option PID params :kp P
    # @option PID params :ki I
    # @option PID params :kd D
    # @return self
    def set_speed_pid(params={})
      data = [
        params[:kp].to_f,
        params[:ki].to_f,
        params[:kd].to_f
      ]
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SPEED_PID, data.pack("GGG"))
      self
    end

    # Set position PID paramters
    # @param [Hash] PID params
    # @option PID params :kp P
    # @option PID params :ki I
    # @option PID params :kd D
    # @return self
    def set_position_pid(params={})
      data = [
        params[:kp].to_f,
        params[:ki].to_f,
        params[:kd].to_f
      ]
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_PID, data.pack("GGG"))
      self
    end

    def set_speed_profile(params={})
      data = [
        params[:speed].to_f,
        params[:acc].to_f
      ]

      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SPEED_PROF, data.pack("GG"))
      self
    end

    # Reset odometry to zero
    # @return self
    def reset_odometry
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_RESET_ODOM)
      self
    end

    # Position of robot
    # @return [Hash] hash position {:px, :py, :pa, :vx, :vy, :va, :stall }
    def position
      @pos2d.dup
    end
 
    # Robot geometry
    # @return [Hash] geometry { :px, :py. :pz, :roll, :pitch, :yaw, :sw, :sl, :sh }
    def geom
      @geom.dup
    end

    # Set speed of robot. All speeds are defined in the robot coordinate system.
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :vy sideways speed (m/s); this field is used by omni-drive robots only. 
    # @option speeds :va rotational speed (rad/s).     
    # @option speeds :stall state of motor
    # @return self
    def set_speed(speeds)
      data = [
        speeds[:vx] || @pos2d[:vx],
        speeds[:vy] || @pos2d[:vy],
        speeds[:va] || @pos2d[:va],
        speeds[:stall] || @pos2d[:stall]
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL, data.pack("GGGN"))
      self
    end

    # Set speed of carlike robot
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :a turning angle (rad).     
    def set_car(speeds)
      data = [ 
        speeds[:vx] || @pos2d[:vx],
        speeds[:a] || @pos2d[:pa]
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_CAR, data.pack("GG"))
      self
    end

    # The position interface accepts translational velocity + absolute heading commands
    # (speed and angular position) for the robot's motors (only supported by some drivers)
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :a absolutle angle (rad).     
    def set_speed_head(speeds)
      data = [ 
        speeds[:vx] || @pos2d[:vx],
        speeds[:a] || @pos2d[:pa]
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL_HEAD, data.pack("GG"))
      self
    end


    # State of motor
    # @return [Boolean] true - on
    def power
      @pos2d[:stall] == 1 
    end

    # Stop robot set speed to 0
    def stop!
      set_speed(vx: 0, vy: 0, va: 0)
    end

    # Check of robot state
    def stoped?
      speed[:vx] == 0 && speed[:vy] == 0 && speed[:va] == 0
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_POSITION2D_DATA_STATE
        read_position(msg)
      when PLAYER_POSITION2D_DATA_GEOM
        read_geom(msg)
      else
        warn "Get unexception data subtype=#{hdr.subtype}"
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_POSITION2D_REQ_GET_GEOM
        read_geom(msg)
      when 2..9
        nil #null response
      else
        warn "Handle unexception response subtype=#{hdr.subtype}"
      end
    end

    private
    def read_position(msg)
      data = msg.unpack("GGGGGGN")
      @pos2d.keys.each_with_index do |k,i|
        @pos2d[k] = data[i]
      end
      debug("Get position px=%.2f py=%.2f pa=%.2f; vx=%.2f, vy=%.2f, va=%.2f, stall=%d" % @pos2d.values)
    end

    def read_geom(msg)
      data = msg.unpack("G*")
      @geom.keys.each_with_index do |k,i|
        @geom[k] = data[i]
      end
      debug("Get geom px=%.2f py=%.2f pz=%.2f; roll=%.2f, pitch=%.2f, yaw=%.2f, sw=%.f, sl=%.2f, sh=%.2f" % @geom.values)
    end
  end
end
