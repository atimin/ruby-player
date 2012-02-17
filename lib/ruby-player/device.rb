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
require "socket"

module Player
  # Basic class for all intrefaces
  class Device
    include Common
  
    # Device address
    attr_reader :addr

    def initialize(addr, client)
      @addr, @client =  addr, client
      @log_level = client.log_level
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
  end
end
