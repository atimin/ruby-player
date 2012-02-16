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
  #   pos2d = client.subcribe("position2d", index: 0)
  #   # setup speed of robot
  #   pos2d.set_speed(vx: 1.2, vy: 0.1, va: 0.3)
  #
  #   #update data from server
  #   client.read!
  #   #read velocityand position by X,Y and angle
  #   pos2d.state #=> { :px => 0.2321, :py => 0,01, :pa => 0.2, :vx => 1.2, :vy => 0.1, :va => 0.3, :stall => 1  }
  #   pos2d.stop!
  class Position2d < Device

    # Position of robot
    # @return [Hash] hash position {:px, :py, :pa, :vx, :vy, :va, :stall }
    attr_reader :state
    
    # Device geometry
    # @return [Hash] geometry { :px, :py. :pz, :proll, :ppitch, :pyaw, :sw, :sl, :sh }
    attr_reader :geom


    def initialize(addr, client)
      super
      @state = {px: 0.0, py: 0.0, pa: 0.0, vx: 0.0, vy: 0.0, va: 0.0, stall: 0}
      @geom = {px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0, sw: 0.0, sl: 0.0, sh: 0.0}
    end

    # Depricated alias for data
    def position
      warn "Method `position` is deprecated. Pleas use `data` for access to position"
      state
    end

    # Query robot geometry 
    # @return self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_GET_GEOM)
      self
    end
   
    # Turn on motor
    # @return self
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
    # @param [Hash] params PID params
    # @option params :kp P
    # @option params :ki I
    # @option params :kd D
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
    # @param [Hash] params PID params
    # @option params :kp P
    # @option params :ki I
    # @option params :kd D
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

    # Set speed profile
    # @param [Hash] params profile prarams
    # @option params :spped max speed (m/s)
    # @option params :acc max acceleration (m/s^2)
    # @return self
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

    # Set speed of robot. All speeds are defined in the robot coordinate system.
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :vy sideways speed (m/s); this field is used by omni-drive robots only. 
    # @option speeds :va rotational speed (rad/s).     
    # @option speeds :stall state of motor
    # @return self
    def set_speed(speeds)
      data = [
        speeds[:vx] || @state[:vx],
        speeds[:vy] || @state[:vy],
        speeds[:va] || @state[:va],
        speeds[:stall] || @state[:stall]
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
        speeds[:vx] || @state[:vx],
        speeds[:a] || @state[:pa]
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
        speeds[:vx] || @state[:vx],
        speeds[:a] || @state[:pa]
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL_HEAD, data.pack("GG"))
      self
    end


    # State of motor
    # @return [Boolean] true - on
    def power
      @state[:stall] == 1 
    end

    # Stop robot set speed to 0
    # @return self
    def stop!
      set_speed(vx: 0, vy: 0, va: 0)
    end

    # Check of robot state
    def stoped?
      @state[:vx] == 0 && @state[:vy] == 0 && @state[:va] == 0
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_POSITION2D_DATA_STATE
        read_state(msg)
      when PLAYER_POSITION2D_DATA_GEOM
        read_geom(msg)
      else
        unexpected_message hdr
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_POSITION2D_REQ_GET_GEOM
        read_geom(msg)
      when 2..9
        nil #null response
      else
        unexpected_message hdr
      end
    end

    private
    def read_state(msg)
      data = msg.unpack("GGGGGGN")
      @state.keys.each_with_index do |k,i|
        @state[k] = data[i]
      end
      debug("Get state px=%.2f py=%.2f pa=%.2f; vx=%.2f, vy=%.2f, va=%.2f, stall=%d" % @state.values)
    end

    def read_geom(msg)
      data = msg.unpack("G*")
      [:px,:py,:pz, :proll,:ppitch,:pyaw, :sw,:sl,:sh].each_with_index do |k,i|
        @geom[k] = data[i]
      end
      debug "Get geom " + geom_to_s(@geom)
    end
  end
end
