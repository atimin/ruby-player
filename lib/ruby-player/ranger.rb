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
  #   ranger = client[:ranger, 0]
  #   client.read
  #
  #   # Ranger data for each sensor in m
  #   ranger.rangers #=> [0.214, 0.211]
  class Ranger
    include CType
    include Common

    module C
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_ranger_create, [:pointer, :int],  :pointer
      attach_function :playerc_ranger_destroy, [:pointer],  :void
      attach_function :playerc_ranger_subscribe, [:pointer, :int],  :int
      attach_function :playerc_ranger_unsubscribe, [:pointer],  :int

      attach_function :playerc_ranger_power_config, [:pointer, :uint8],  :int
      attach_function :playerc_ranger_intns_config, [:pointer, :uint8],  :int
      attach_function :playerc_ranger_set_config, [:pointer] + [:double] * 7,  :int
      attach_function :playerc_ranger_get_config, [:pointer] + [:pointer] * 7,  :int
    end

    def initialize(client, index)
      @ranger =  RangerStruct.new(C.playerc_ranger_create(client, index))
      try_with_error C.playerc_ranger_subscribe(@ranger, PLAYER_OPEN_MODE)

      ObjectSpace.define_finalizer(self, Ranger.finilazer(@ranger))
    end

    # Count of sensors 
    # Return [Integer] count
    def element_count
      @ranger[:element_count]
    end

    # Power control
    # @param enable nil or false power off
    def power_enable=(enable)
      try_with_error C.playerc_ranger_power_config(@ranger, enable ? 1 : 0)
    end

    # Enable intensity
    # @param enable nil or false disable 
    def intensity_enable=(enable)
      try_with_error C.playerc_ranger_intns_config(@ranger, enable ? 1 : 0)
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

      try_with_error C.playerc_ranger_set_config(@ranger, *args)
    end

    # Configuration of ranger
    # @see set_config
    def config
      try_with_error C.playerc_ranger_get_config(@ranger, *([nil] * 7))
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

    def Ranger.finilazer(ranger)
      lambda{
        try_with_error C.playerc_ranger_unsubscribe(pos)
        C.playerc_ranger_destroy(pos)
      }
    end
  end
end 
