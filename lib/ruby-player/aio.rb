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
  # The aio interface provides access to an analog I/O device.
  class AIO < Device
    include Enumerable

    attr_reader :state

    def initialize(dev, client)
      super
      @state = { voltages: [] }
    end

    # The samples [V] 
    # @retrun [Array]
    def voltages
      state[:voltages]
    end

    # The aio interface allows for the voltage level on one output to be set
    # @param id [Integer] which I/O output to command.
    # @param voltage [Float] voltage level to set. 
    # @return [AIO] self
    def set_voltage(id, voltage)
      send_message(PLAYER_MSGTYPE_CMD, PLAYER_AIO_CMD_STATE, [id, voltage].pack("Ng"))
      self
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_AIO_DATA_STATE
        read_state(msg)
      else
        unexpected_message hdr
      end
    end

    # Get single sample [V]
    # @return [Float]
    def [](id)
      state[:voltages][id] 
    end

    # @see #set_voltage
    def []=(id, voltage)
      set_voltage(id, voltage) 
    end

    def each
      state[:voltages].each { |v| yield v }  
    end

    private
    def read_state(msg)
      data = msg.unpack("NNg*")
      @state[:voltages] = data[2..-1]
      debug "Got voltages #{data[2..-1]}"
    end
  end
end
