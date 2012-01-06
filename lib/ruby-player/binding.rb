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

#structs
require File.dirname(__FILE__) + "/binding/sockaddr_in_t"
require File.dirname(__FILE__) + "/binding/constants"
require File.dirname(__FILE__) + "/binding/devaddr"
require File.dirname(__FILE__) + "/binding/device_t"
require File.dirname(__FILE__) + "/binding/position2d_t"
require File.dirname(__FILE__) + "/binding/client_t"

#funcs
require File.dirname(__FILE__) + "/binding/diagnostic"
require File.dirname(__FILE__) + "/binding/position2d"
require File.dirname(__FILE__) + "/binding/client"
