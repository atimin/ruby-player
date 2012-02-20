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
    include Enumerable

    def initialize(dev, client)
      super
      @acts = []
    end

    # Turn on power all actuators
    # Be careful when turning power on that the array is not obstructed 
    # from its home position in case it moves to it (common behaviour)
    # @return [ActArray] self
    def power_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [1].pack("N"))
      self
    end

    # Turn off power all actuators
    # Be careful when turning power on that the array is not obstructed 
    # from its home position in case it moves to it (common behaviour)
    # @return [ActArray] self
    def power_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_POWER, [0].pack("N"))
      self
    end

    # Turn on brakes all actuators
    # @return [ActArray] self
    def brakes_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_BRAKES, [1].pack("N"))
      self
    end

    # Turn off brakes all actuators
    # @return [ActArray] self
    def brakes_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_BRAKES, [0].pack("N"))
      self
    end

    # Query actarray geometry 
    # @return [ActArray] self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_REQ_GET_GEOM)
      self
    end

    # Get single actuator
    # @param joint - number of actuator
    # @return [Actuator] actuator
    def [](joint)
      @acts[joint] ||= Actuator.new(joint, self)
    end

    # Tells all joints/actuators to attempt to move to the given positions.
    # @param [Array] poses
    # @return [ActArray] self
    def set_positions(poses)
      send_message(
        PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_POS,
        ([poses.size] + poses).pack("Ng*")
      )
      self
    end

    # Tells all joints/actuators to attempt to move with the given speed.
    # @param [Array] speeds
    # @return [ActArray] self
    def set_speeds(speeds)
      send_message(
        PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_SPEED,
        ([speeds.size] + speeds).pack("Ng*")
      )
      self
    end

    # Command to go to home position for all joints
    # @return [ActArray] self
    def go_home!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_HOME, [-1].pack("N"))
      self
    end

    # Command all joints to attempt to move with the given current
    # @param curr -current to move with
    # @return [ActArray] self
    def set_current_all(curr)
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_CURRENT, [-1, curr].pack("Ng"))
      self
    end
    
    # Tells all joints/actuators to attempt to move with the given current.
    # @param [Array] currents
    # @return [ActArray] self
    def set_currents(currents)
      send_message(
        PLAYER_MSGTYPE_REQ, PLAYER_ACTARRAY_CMD_MULTI_CURRENT,
        ([currents.size] + currents).pack("Ng*")
      )
      self
    end

    def each
      @acts.each { |a| yield a }
    end
  end
end
