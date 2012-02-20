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
  # The power interface provides access to a robot's power subsystem
  class Power < Device
    
    # Power state
    #
    # *:valid* status bits. The driver will set the bits to indicate which fields it is using. Bitwise-and with PLAYER_POWER_MASK_X values to see which fields are being set.
    #
    # *:volts* Battery voltage [V]. 
    #
    # *:percent* Percent of full charge [%].
    #
    # *:joules* Energy stored [J]. 
    #
    # *:watts* Estimated current energy consumption (negative values) or aquisition (positive values) [W]. 
    #
    # *:charging* Charge exchange status: if 1, the device is currently receiving charge from another energy device
    #
    # @return [Hash] state
    attr_reader :state

    def initialize(addr, client)
      super
      @state = { valid: 0, volts: 0.0, percent: 0.0, joules: 0.0, watts: 0.0, charging: 0 }
    end
    
    # Request to change the charging policy
    # @param [Hash] policy
    # @option policy [Boolean] :enable_input boolean controlling recharging
    # @option policy [Boolean] :enable_output bolean controlling whether others can recharge from this device
    def set_charging_policy(policy={})
      data = [
        policy[:enable_input] ? 1 : 0,
        policy[:enable_output] ? 1 : 0
      ]
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_POWER_REQ_SET_CHARGING_POLICY, data.pack("NN"))
    end

    # Check volts valid
    def volts_valid?
      state[:valid].to_i & PLAYER_POWER_MASK_VOLTS > 0
    end

    # Check watts valid
    def watts_valid?
      state[:valid].to_i & PLAYER_POWER_MASK_WATTS > 0
    end

    # Check joules valid
    def joules_valid?
      state[:valid].to_i & PLAYER_POWER_MASK_JOULES > 0
    end

    # Check perecent valid
    def percent_valid?
      state[:valid].to_i & PLAYER_POWER_MASK_PERCENT > 0
    end

    # Check charging valid
    def charging_valid?
      state[:valid].to_i & PLAYER_POWER_MASK_CHARGING > 0
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_POWER_DATA_STATE
        read_state(msg)
      else
        undexpected_message hdr
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_POWER_REQ_SET_CHARGING_POLICY
        nil
      else
        undexpected_message hdr
      end
    end

    private
    def read_state(msg)
      fill_hash!(@state, msg.unpack("NggggN"))
      debug "Get state: " + hash_to_sft(@state)
    end
  end
end
