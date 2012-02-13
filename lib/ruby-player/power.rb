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
  # The power interface provides access to a robot's power subsystem
  class Power < Device
    
    # Power state
    # :valid status bits. The driver will set the bits to indicate which fields it is using. Bitwise-and with PLAYER_POWER_MASK_X values to see which fields are being set.
    # :volts Battery voltage [V]. 
    # :percent Percent of full charge [%].
    # :joules Energy stored [J]. 
    # :watts Estimated current energy consumption (negative values) or aquisition (positive values) [W]. 
    # :charging Charge exchange status: if 1, the device is currently receiving charge from another energy device
    # @return [Hash] state
    attr_reader :state

    def initialize(addr, client)
      super
      @state = { valid: 0, volts: 0.0, percent: 0.0, joules: 0.0, watts: 0.0, charging: 1 }
    end
  end
end
