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
    class DeviceStruct < FFI::Struct
      layout  :id, :pointer,
              :client, :pointer,
              :addr, DevAddrStruct,
              :drivername, [:char, PLAYER_MAX_DRIVER_STRING_LEN],
              :subcribed, :int,
              :datatime, :double,
              :lasttime, :double,
              :fresh, :int,
              :freshdgeom, :int,
              :freshconfig, :int,
              :putmsg, :pointer,
              :user_data, :pointer,
              :callback_count, :int,
              :calback, [:pointer, 4],
              :calback_data, [:pointer, 4]
    end
  end
end
