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
require "socket"

module Player
  class Device
    include Common
  
    # Device address
    attr_reader :addr

    # Device geometry
    # @return [Hash] geometry { :px, :py. :pz, :roll, :pitch, :yaw, :sw, :sl, :sh }
    attr_reader :geom
 

    def initialize(addr, client, log_level)
      @addr, @client =  addr, client
      @log_level = log_level

      @geom = {px: 0.0, py: 0.0, pz: 0.0, roll: 0.0, pitch: 0.0, yaw: 0.0, sw: 0.0, sl: 0.0, sh: 0.0}
    end

    def fill(hdr,msg)
      raise_error "Method `fill` isn't implemented for `#{self.class}`"
    end

    def handle_response(hdr, msg)
      raise_error "Method `handle_response` isn't implemented for `#{self.class}`"
    end
   
    private
    def send_message(type, subtype, msg="")
      @client.write( Header.new(
          dev_addr: @addr,
          type: type,
          subtype: subtype,
          size: msg.bytesize), msg)
    end

    def read_geom(msg)
      data = msg.unpack("G*")
      [:px,:py,:pz, :roll,:pitch,:yaw, :sw,:sl,:sh].each_with_index do |k,i|
        @geom[k] = data[i]
      end
      debug("Get geom px=%.2f py=%.2f pz=%.2f; roll=%.2f, pitch=%.2f, yaw=%.2f, sw=%.2f, sl=%.2f, sh=%.2f" % @geom.values)
    end
  end
end
