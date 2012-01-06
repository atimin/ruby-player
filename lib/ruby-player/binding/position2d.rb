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
#
module Player
  module Binding 
    module Position2d
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_position2d_create, [:pointer, :int],  :pointer
      attach_function :playerc_position2d_destroy, [:pointer],  :void
      attach_function :playerc_position2d_subscribe, [:pointer, :int],  :int
      attach_function :playerc_position2d_unsubscribe, [:pointer],  :int

      attach_function :playerc_position2d_get_geom, [:pointer], :int
      attach_function :playerc_position2d_set_cmd_vel, [:pointer, :double, :double, :double, :int], :int
      attach_function :playerc_position2d_set_cmd_car, [:pointer, :double, :double], :int
      attach_function :playerc_position2d_enable, [:pointer, :int], :int
    end
  end
end
