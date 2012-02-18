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
  # The actuator array interface provides access to an array of actuators.
  class ActArray < Device

    # Turn on all actuators
    # Be careful when turning power on that the array is not obstructed 
    # from its home position in case it moves to it (common behaviour)
    # @return self
    def power_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [1].pack("N"))
      self
    end

    # Turn off all actuators
    # Be careful when turning power on that the array is not obstructed 
    # from its home position in case it moves to it (common behaviour)
    # @return self
    def power_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [0].pack("N"))
      self
    end

  end
end
