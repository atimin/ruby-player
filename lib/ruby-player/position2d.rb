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

require File.dirname(__FILE__) + "/binding"

module Player
  # The position2d proxy provides an interface to a mobile robot base
  #
  # @example
  #   # get proxy object
  #   pos2d = client[:position2d, 0]
  #   # setup speed (vx, vy, va) of robot
  #   pos2d.set_vel(1.2, 0.1, 0.3)
  #
  #   #update data from server
  #   client.read
  #   #read velocityand position by X,Y and angle
  #   pos2d.vel #=> [1.2, 0.1, 0.3]
  #   pos2d.pose #=> [0.2321, 0,01, 0.2]
  class Position2d
    include Binding
    include Binding::Diagnostic
    include Binding::Position2d

    def initialize(client, index)
      @pos2d =  Position2dStruct.new(playerc_position2d_create(client, index))
      try_with_error playerc_position2d_subscribe(@pos2d, PLAYER_OPEN_MODE)

      ObjectSpace.define_finalizer(self, Position2d.finilazer(@pos2d))
    end

    # Position of robot
    # @return [Array] array coordinats [x,y,angle]
    def pose
      [px, py, pa]
    end

    # Position x
    def px
      @pos2d[:px]
    end

    # Position y
    def py
      @pos2d[:py]
    end

    # Angle
    def pa
      @pos2d[:pa]
    end

    # Set speed of robot. All speeds are defined in the robot coordinate system.
    # @param vx forward speed (m/s)
    # @param vy sideways speed (m/s); this field is used by omni-drive robots only. 
    # @param va rotational speed (rad/s).     
    def set_vel(vx, vy, va)
      try_with_error playerc_position2d_set_cmd_vel(@pos2d, vx.to_f, vy.to_f, va.to_f, 0)
    end

    # Set speed of carlike robot
    # @param vx forward speed (m/s)
    # @param a angle robot (rad).     
    def set_car(vx, a)
      try_with_error playerc_position2d_set_cmd_car(@pos2d, vx, a)
    end

    # Velocity of robot
    # @return [Array] array of speeds [vx,vy,va]
    def vel
      [vx, vy, va]
    end

    # Forward speed (m/s)
    def vx
      @pos2d[:vx]
    end

    # Sideways speed (m/s); this field is used by omni-drive robots only. 
    def vy
      @pos2d[:vy]
    end

    # Rotational speed (rad/s).     
    def va
      @pos2d[:va]
    end

    # State of motor
    # @return [Boolean] true - on
    def enable
      @pos2d[:stall] == 1 
    end

    # Turn on\off motor
    # @param [Boolean] true - turn on 
    def enable=(val)
      try_with_error playerc_position2d_enable(@pos2d, val ? 1 : 0) 
    end

    def Position2d.finilazer(pos)
      lambda{
        try_with_error playerc_position2d_unsubscribe(pos)
        playerc_position2d_destroy(pos)
      }
    end
  end
end
