# Ruby Player - Ruby client library for Player (tools for robots) 
#
# Copyright (C) 2012  Aleksey Timin
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

    # X position [m]
    # @return [Float]
    def px
      state[:px]
    end
    
    # Y position [m]
    # @return [Float]
    def py
      state[:py]
    end
    
    # Yaw [rad]
    # @return [Float]
    def pa
      state[:pa]
    end

    # X speed [m/s]
    # @return [Float]
    def vx
      state[:vx]
    end
    
    # Y speed [m/s]
    # @return [Float]
    def vy
      state[:vy]
    end
    
    # Yaw speed [rad/s]
    # @return [Float]
    def va
      state[:va]
    end

    # State of motor
    # @return [Boolean] true - on
    def power?
      state[:stall] != 0 
    end

    # @deprecated Use {#power?}
    def power
      warn "Method `power` is deprecated. Pleas use `power?`"
      power?
    end

    # @deprecated Use {#state}
    def position
      warn "Method `position` is deprecated. Pleas use `data` for access to position"
      state
    end

    # Query robot geometry 
    # @return [Position2d] self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_GET_GEOM)
      self
    end
   
    # Turn on motor
    # @return [Position2d] self
    def power_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [1].pack("N")) 
      self
    end
    
    # @deprecated Use {#power_on!}
    def turn_on!
      warn "Method `turn_on!` is deprecated. Pleas use `power_on!`"
      power_on!
    end

    # Turn off motor
    # @return [Position2d] self
    def power_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_MOTOR_POWER, [0].pack("N")) 
      self
    end

    # @deprecated Use {#power_off!}
    def turn_off!
      warn "Method `turn_off!` is deprecated. Pleas use `power_off!`"
      power_off!
    end

    # @return [Position2d] self
    def direct_speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [0].pack("N"))
      self
    end

    # @return [Position2d] self
    def separate_speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_VELOCITY_MODE, [1].pack("N"))
      self
    end

    # @return [Position2d] self
    def position_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [0].pack("N"))
      self
    end

    # @return [Position2d] self
    def speed_control!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_POSITION_MODE, [1].pack("N"))
      self
    end

    # Set odometry of robot.
    # @param [Hash] odom odometry 
    # @option odom :px x position (m)
    # @option odom :py y position (m)
    # @option odom :pa angle (rad).     
    # @return [Position2d] self
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
    # @return [Position2d] self
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
    # @return [Position2d] self
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
    # @return [Position2d] self
    def set_speed_profile(params={})
      data = [
        params[:speed].to_f,
        params[:acc].to_f
      ]

      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POSITION2D_REQ_SPEED_PROF, data.pack("GG"))
      self
    end

    # Reset odometry to zero
    # @return [Position2d] self
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
    # @return [Position2d] self
    def set_speed(speeds={})
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
    # @return [Position2d] self
    def set_car(speeds={})
      data = [ 
        speeds[:vx] || @state[:vx],
        speeds[:a] || 0
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_CAR, data.pack("GG"))
      self
    end

    # The position interface accepts translational velocity + absolute heading commands
    # (speed and angular position) for the robot's motors (only supported by some drivers)
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :a absolutle angle (rad).     
    # @return [Position2d] self
    def set_speed_head(speeds={})
      data = [ 
        speeds[:vx] || @state[:vx],
        speeds[:a] || @state[:pa],
      ]
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_VEL_HEAD, data.pack("GG"))
      self
    end

    # Set the target pose  with motion vel. (gx, gy, ga) is the target pose in the
    # odometric coordinate system.
    # @param [Hash] pose
    # @option pose :gx x coordinate [m]
    # @option pose :gy y coordinate [m]
    # @option pose :ga angle [rad] 
    # @option pose :vx forward vel [m/s] (default current)
    # @option pose :vy sideways vel [m/s] (default current)
    # @option pose :va rotational speed [rad/s] (default current)
    # @option pose :stall state of motor (default current)
    # @return [Position2d] self
    def set_pose(pose={})
      data = [
        pose[:gx].to_f,
        pose[:gy].to_f,
        pose[:ga].to_f,
        pose[:vx] || @state[:vx],
        pose[:vy] || @state[:vy],
        pose[:va] || @state[:va],
        pose[:stall] || @state[:stall]
      ]

      send_message(PLAYER_MSGTYPE_CMD, PLAYER_POSITION2D_CMD_POS, data.pack("GGGGGGN"))
      self
    end

    # Stop robot set speed to 0
    # @return [Position2d] self
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
      fill_hash!(@state, msg.unpack("GGGGGGN"))
      debug "Got state: " + hash_to_sft(@state)
    end

    def read_geom(msg)
      fill_hash!(@geom, msg.unpack("G*"))
      debug "Got geom: " + hash_to_sft(@geom)
    end
  end
end
