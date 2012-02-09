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
  # The ranger proxy provides an interface to the ranger sensors built into robots
  #
  # @example
  class Ranger < Device
    include Common

    def initialize(addr, client, log_level)
      super
    end
    
    # Query ranger geometry 
    # @return self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_GEOM)
      self
    end

    # Turn on ranger
    # @return self
    def turn_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [1].pack("N")) 
      self
    end
    
    # Turn off ranger
    def turn_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [0].pack("N")) 
      self
    end

    def intensity_enable!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [1].pack("N"))
      self
    end

    def intensity_disable!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [0].pack("N"))
      self
    end

    def set_config(config={})
      warn "Setting configuration has not implemented yet"
    end

    # Count of sensors 
    # Return [Integer] count
    def element_count
      @ranger[:element_count]
    end


    # Set config of ranger
    # @param [Hash] config params for setup
    # @option config :min_angle start angle of scans [rad] 
    # @option config :max_angle end angle of scans
    # @option config :angular_res scan resolution [rad]
    # @option config :min_range maximum range [m]
    # @option config :max_range minimum range [m]
    # @option config :range_res range resolution [m]
    # @option config :frequency scanning frequency [Hz]
    def set_config(config)
      args = [
        config[:min_angle].to_f || @ranger[:min_angle],
        config[:max_angle].to_f || @ranger[:max_angle],            
        config[:angular_res].to_f || @ranger[:angular_res],            
        config[:min_range].to_f || @ranger[:min_range],
        config[:max_range].to_f || @ranger[:max_range],
        config[:range_res].to_f || @ranger[:range_res],
        config[:frequecy].to_f || @ranger[:frequecy] 
      ]

    end

    # Configuration of ranger
    # @see set_config
    def config
      {  
        min_range:    @ranger[:min_angle],
        max_range:    @ranger[:max_angle],            
        angular_res:  @ranger[:angular_res],            
        min_range:    @ranger[:min_range],
        max_range:    @ranger[:max_range],
        range_res:    @ranger[:range_res],
        frequecy:     @ranger[:frequecy] 
      }
    end

    # Range data [m]
    # @return [Array] fot each sensor
    def ranges
      @ranger[:ranges].read_array_of_type(
        FFI::Type::DOUBLE,
        :read_double,
        @ranger[:ranges_count]
      )
    end

    # Intensity data [m]. 
    # @return [Array] fot each sensor
    def intensities
      @ranger[:intensities].read_array_of_type(
        FFI::Type::DOUBLE, 
        :read_double, 
        @ranger[:intensities_count]
      )
    end

    # Scan bearings in the XY plane [radians]. 
    # @return [Array] fot each sensor
    def bearings
      @ranger[:bearings].read_array_of_type(
        FFI::Type::DOUBLE, 
        :read_double, 
        @ranger[:bearings_count]
      )
    end
  end
end 
