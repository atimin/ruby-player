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

    attr_reader :addr
    def initialize(addr, client, log_level)
      @addr, @client =  addr, client
      @log_level = log_level
    end

    def fill(hdr,msg)
      raise "Method `fill` is not implemented for `#{self.class}`"
    end

    def handle_response(hdr, msg)
      raise "Method `handle_response` is not implemented for `#{self.class}`"
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
