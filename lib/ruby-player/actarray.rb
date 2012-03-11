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

    attr_reader :state

    # Geometry of base actarray
    attr_reader :geom

    def initialize(dev, client)
      super
      @actuators = []
      @state  = { motor_state: 0 }
      @geom   = { px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0 }
    end

    # Check common power
    # @return [Boolean]
    def power?
      state[:motor_state] != 0
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
      @actuators[joint] ||= Actuator.new(joint, self)
    end

    # Tells all joints/actuators to attempt to move to the given positions.
    # @param [Array] poses
    # @return [ActArray] self
    def set_positions(poses)
      send_message(
        PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_MULTI_POS,
        ([poses.size] + poses).pack("Ng*")
      )
      self
    end

    # Tells all joints/actuators to attempt to move with the given speed.
    # @param [Array] speeds
    # @return [ActArray] self
    def set_speeds(speeds)
      send_message(
        PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_MULTI_SPEED,
        ([speeds.size] + speeds).pack("Ng*")
      )
      self
    end

    # Command to go to home position for all joints
    # @return [ActArray] self
    def go_home!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_HOME, [-1].pack("N"))
      self
    end

    # Command all joints to attempt to move with the given current
    # @param curr -current to move with
    # @return [ActArray] self
    def set_current_all(curr)
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_CURRENT, [-1, curr].pack("Ng"))
      self
    end
    
    # Tells all joints/actuators to attempt to move with the given current.
    # @param [Array] currents
    # @return [ActArray] self
    def set_currents(currents)
      send_message(
        PLAYER_MSGTYPE_CMD, PLAYER_ACTARRAY_CMD_MULTI_CURRENT,
        ([currents.size] + currents).pack("Ng*")
      )
      self
    end

    def each
      @actuators.each { |a| yield a }
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_ACTARRAY_DATA_STATE
        read_state(msg)
      else
        unexpected_message hdr
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_ACTARRAY_REQ_GET_GEOM
        read_geom(msg)
      else
        unexpected_message hdr
      end
    end

    private
    def read_state(msg)
      c = msg[0,4].unpack("NN")[0]
      msg[8..-5].unpack("a20" * c).each_with_index do |s,i|
        @actuators[i] ||= Actuator.new(i,self)
        @actuators[i].read_state(s)
        debug "Get state for actuator ##{i}: " + hash_to_sft(@actuators[i].state)
      end
      @state[:motor_state] = msg[-4,4].unpack("N")[0]
      debug "Get state: motor_state=%d" % @state[:motor_state]
    end

    def read_geom(msg)
      c = msg[0,4].unpack("N")[0]
      msg[8..-48].unpack("a80" * c).each_with_index do |s, i|
        @actuators[i] ||= Actuator.new(i,self)
        @actuators[i].read_geom(s)
        debug "Get geom for actuator ##{i}: " + hash_to_sft(@actuators[i].geom)
      end
      fill_hash!(@geom, msg[-48..-1].unpack("G6"))
      debug("Get geom: " + hash_to_sft(@geom))
    end
  end
end
