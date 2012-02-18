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
  # The actuator of actarray
  # @see Player::ActArray
  class Actuator
    attr_reader :joint

    def initialize(joint, actarray)
      @joint, @actarray = joint, actarray
    end

    # Set speed for a joint for all subsequent movements
    # @param speed - speed setting in rad/s or m/s
    # @return self
    def set_speed_config(speed)
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_SPEED, [@joint, speed].pack("Ng"))
      self
    end
    
    # Set accelelarion for a joint for all subsequent movements
    # @param  accel - accelelarion setting in rad/s^2 or m/s^2
    # @return self
    def set_accel_config(accel)
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_ACCEL, [@joint, accel].pack("Ng"))
      self
    end
    
    # Set position for a joint
    # @param pos - position setting in rad or m
    # @return self
    def set_position(pos)
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_POS, [@joint, pos].pack("Ng"))
      self
    end
    
    # Set speed for a joint
    # @param seepd - speed setting in rad/s or m/s
    # @return self
    def set_speed(speed)
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_SPEED, [@joint, speed].pack("Ng"))
      self
    end

    # Command to go to home position
    # @return self
    def go_home!
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_HOME, [@joint].pack("N"))
      self
    end

    # Command a joint to attempt to move with the given current
    # @param curr -current to move with
    # @return self
    def set_current(curr)
      @actarray.send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_CURRENT, [@joint, curr].pack("Ng"))
      self
    end
  end
end 
