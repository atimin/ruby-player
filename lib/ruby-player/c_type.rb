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
require "ffi"

module Player
  module CType
    PLAYER_MAX_DRIVER_STRING_LEN = 64
    # Device access mode: open
    PLAYER_OPEN_MODE = 1
    #Device access mode: close
    PLAYER_CLOSE_MODE = 2
    #Device access mode: error
    PLAYER_ERROR_MODE = 3
  end
end

#structs
require File.dirname(__FILE__) + "/c_type/sockaddr_in_t"
require File.dirname(__FILE__) + "/c_type/devaddr"
require File.dirname(__FILE__) + "/c_type/device_t"
require File.dirname(__FILE__) + "/c_type/pose3d_t"
require File.dirname(__FILE__) + "/c_type/bbox3d_t"
require File.dirname(__FILE__) + "/c_type/position2d_t"
require File.dirname(__FILE__) + "/c_type/ranger_t"
require File.dirname(__FILE__) + "/c_type/client_t"
