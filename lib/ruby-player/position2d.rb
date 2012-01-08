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
  #   pos2d = client[:position2d, 0]
  #   # setup speed of robot
  #   pos2d.set_speed(vx: 1.2, vy: 0.1, va: 0.3)
  #
  #   #update data from server
  #   client.read
  #   #read velocityand position by X,Y and angle
  #   pos2d.speed #=> { :vx => 1.2, :vy => 0.1, :va => 0.3 }
  #   pos2d.odometry #=> { :px => 0.2321, :py => 0,01, :pa => 0.2 }
  #   pos2d.stop 
  class Position2d
    include CType
    include Common

    module C
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_position2d_create, [:pointer, :int],  :pointer
      attach_function :playerc_position2d_destroy, [:pointer],  :void
      attach_function :playerc_position2d_subscribe, [:pointer, :int],  :int
      attach_function :playerc_position2d_unsubscribe, [:pointer],  :int

      attach_function :playerc_position2d_get_geom, [:pointer], :int
      attach_function :playerc_position2d_set_cmd_vel, [:pointer, :double, :double, :double, :int], :int
      attach_function :playerc_position2d_set_cmd_car, [:pointer, :double, :double], :int
      attach_function :playerc_position2d_enable, [:pointer, :int], :int
      attach_function :playerc_position2d_set_odom, [:pointer, :double, :double, :double], :int
    end

    def initialize(client, index)
      @pos2d =  Position2dStruct.new(C.playerc_position2d_create(client, index))
      try_with_error C.playerc_position2d_subscribe(@pos2d, PLAYER_OPEN_MODE)

      ObjectSpace.define_finalizer(self, Position2d.finilazer(@pos2d))
    end

    # Odometry of robot
    # @return [Hash] hash odometry {:px, :py, :pa }
    def odometry
      { 
        px: @pos2d[:px],
        py: @pos2d[:py],
        pa: @pos2d[:pa]
      }
    end
    
    # Set odometry of robot.
    # @param [Hash] odometry
    # @option odometry :px x position (m)
    # @option odometry :py y position (m)
    # @option odometry :pa angle (rad).     
    # @return self
    def set_odometry(odometry)
      args = [
        odometry[:px].to_f || @pos2d[:px],
        odometry[:py].to_f || @pos2d[:py],
        odometry[:pa].to_f || @pos2d[:pa]
      ]

      try_with_error C.playerc_position2d_set_odom(@pos2d, *args)
      self
    end

    # Reset odometry to zero
    # @return self
    def reset_odometry
      set_odometry(px: 0, py: 0, pa: 0)
    end

    # Robot geometry
    # @return [Hash] position :px, :py, :pa, size :sx, :sy
    def geom
      try_with_error C.playerc_position2d_get_geom(@pos2d)
      p = @pos2d[:pose].to_a
      s = @pos2d[:size].to_a
      {
        px: p[0],
        py: p[1],
        pa: p[2],
        sx: s[0],
        sy: s[1]
      }
    end


    # Set speed of robot. All speeds are defined in the robot coordinate system.
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :vy sideways speed (m/s); this field is used by omni-drive robots only. 
    # @option speeds :va rotational speed (rad/s).     
    # @return self
    def set_speed(speeds)
      args = [
        speeds[:vx].to_f || @pos2d[:vx],
        vy = speeds[:vy].to_f || @pos2d[:vy],
        va = speeds[:va].to_f || @pos2d[:va],
        1
      ]
      try_with_error C.playerc_position2d_set_cmd_vel(@pos2d, *args)
      self
    end

    # Set speed of carlike robot
    # @param [Hash] speeds 
    # @option speeds :vx forward speed (m/s)
    # @option speeds :a angle robot (rad).     
    def set_car(speeds)
      args = [ 
        speeds[:vx].to_f || @pos2d[:vx],
        speeds[:a].to_f || @pos2d[:pa]
      ]
      try_with_error C.playerc_position2d_set_cmd_car(@pos2d, *args)
      self
    end

    # Velocity of robot
    # @return [Hash] hash of speeds
    def speed
      {
        vx: @pos2d[:vx],
        vy: @pos2d[:vy],
        va: @pos2d[:va]
      }
    end

    # State of motor
    # @return [Boolean] true - on
    def enable
      @pos2d[:stall] == 1 
    end

    # Turn on\off motor
    # @param [Boolean] true - turn on 
    def enable=(val)
      try_with_error C.playerc_position2d_enable(@pos2d, val ? 1 : 0) 
    end

    # Stop robot set speed to 0
    def stop
      set_speed(vx: 0, vy: 0, va: 0)
    end

    # Check of robot state
    def stoped?
      speed[:vx] == 0 && speed[:vy] == 0 && speed[:va] == 0
    end

    def Position2d.finilazer(pos)
      lambda{
        try_with_error C.playerc_position2d_unsubscribe(pos)
        C.playerc_position2d_destroy(pos)
      }
    end
  end
end
