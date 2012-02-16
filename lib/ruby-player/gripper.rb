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
  # Gripper interface.
  #
  # The gripper interface provides access to a robotic gripper. 
  # A gripper is a device capable of closing around and carrying an object 
  # of suitable size and shape. On a mobile robot, a gripper is typically mounted near the floor on the front, 
  # or on the end of a robotic limb. Grippers typically have two "fingers" that close around an object. i
  # Some grippers can detect whether an objcet is within the gripper (using, for example, light beams). 
  # Some grippers also have the ability to move the a carried object into a storage system, 
  # freeing the gripper to pick up a new object, and move objects from the storage system back into the gripper.
  class Gripper < Device
    # The gripper interface returns the current state of the gripper 
    # and information on a potential object in the gripper. 
    #
    # *:state* may be PLAYER_GRIPPER_STATE_OPEN, PLAYER_GRIPPER_STATE_CLOSED, 
    # PLAYER_GRIPPER_STATE_MOVING or PLAYER_GRIPPER_STATE_ERROR. 
    #
    # *:beams* provides information on how far into the gripper an object is. 
    # For most grippers, this will be a bit mask, with each bit representing whether 
    # a beam has been interrupted or not.
    #
    # *:stored* - Number of currently stored objects
    #
    # @return [Hash] { :state, :beams, :stored }
    attr_reader :state


    # Geometry data of gripper
    #
    # *:pose* - Gripper pose, in robot cs (m, m, m, rad, rad, rad). 
    #
    # *:outer_size* - Outside dimensions of gripper (m, m, m). 
    #
    # *:inner_size* - Inside dimensions of gripper, i.e. 
    #
    # *:number_beams* - Number of breakbeams the gripper has.
    #
    # *:capacity* - Capacity for storing objects - if 0, then the gripper can't store. 
    #
    # @return [Hash] { :pose => {:px,:py,:pz,:proll,:ppitch,:pyaw,
    #   :outer_size => { :sw, :sl, :sh },
    #   :inner_size => { :sw, :sl, :sh },
    #   :number_beams, :capacity
    #   }
    attr_reader :geom

    def initialize(addr, client)
      super
      @state = { state: PLAYER_GRIPPER_STATE_OPEN, beams: 0, stored: 0 }
      @geom = {
        pose: { px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0 },
        outer_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        inner_size: { sw: 0.0, sl: 0.0, sh: 0.0 },
        number_beams: 0,
        capacity: 0
      }
    end

    # Query gripper geometry 
    # @return self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_GEOM)
      self
    end

    # Check openinig
    def open?
      state[:state] & PLAYER_GRIPPER_STATE_OPEN > 0
    end

    # Check closing
    def closed?
      state[:state] & PLAYER_GRIPPER_STATE_CLOSED > 0
    end
    
    # Check moving
    def moving?
      state[:state] & PLAYER_GRIPPER_STATE_MOVING > 0
    end

    # Check error
    def error?
      state[:state] & PLAYER_GRIPPER_STATE_ERROR > 0
    end

    # Tells the gripper to open
    def open!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_OPEN)
      self
    end

    # Tells the gripper to close
    def close!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_CLOSE)
      self
    end
    
    # Tells the gripper to stop
    def stop!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_STOP)
      self
    end

    # Tells the gripper to store whatever it is holding.
    def store!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_STORE)
      self
    end

    # Tells the gripper to retrieve a stored object (so that it can be put back into the world).
    # The opposite of store.
    def retrieve!
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_GRIPPER_CMD_RETRIEVE)
      self
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_GRIPPER_DATA_STATE
        read_state(msg)
      else
        undexpected_message hdr
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_GRIPPER_REQ_GET_GEOM
        read_geom(msg)
      else
        undexpected_message hdr
      end
    end

    private
    def read_state(msg)
      fill_hash!(@state, msg.unpack("NNN"))
      debug("Get gripper state state=%d, beams=%d, stored=%d" % @state.values)
    end

    def read_geom(msg)
      data = msg.unpack("G12NN")
      fill_hash!(@geom[:pose], data)
      debug "Get gripper pose: " + pose_to_s(@geom[:pose])

      fill_hash!(@geom[:outer_size], data)
      debug "Get gripper outer size: " + size_to_s(@geom[:outer_size])

      fill_hash!(@geom[:inner_size], data)
      debug "Get gripper inner size: " + size_to_s(@geom[:inner_size])

      @geom[:number_beams] = data.shift
      @geom[:capacity] = data.shift
      debug("Get number_beams=%{number_beams}, capacity=%{capacity}" % @geom)
    end
  end
end
