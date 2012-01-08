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
  module CType
    class ClientStruct < FFI::Struct
      layout :id, :pointer,
            :host, :string,
            :port, :int,
            :transport, :int,
            :server, SockaddrInStruct,
            :connected, :int,
            :retry_limit, :int,
            :retry_time, :double,
            :mode, :uint8,
            :data_requested, :int,
            :data_received, :int
            #TODO Added devinfo, devicem, qitems 
            #:data, :string,
            #:write_xdrdata, :string,
            #:read_xdrdata, :string,
            #:read_xdrdata_len, :size_t
    end
  end
end
