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

require "ruby-player/version"
require "ruby-player/constants"
require "ruby-player/common"

#basic classes
require "ruby-player/dev_addr"
require "ruby-player/header"
require "ruby-player/device"
require "ruby-player/client"

#interfaces
require "ruby-player/actuator"
require "ruby-player/actarray"
require "ruby-player/blob"
require "ruby-player/gripper"
require "ruby-player/position2d"
require "ruby-player/power"
require "ruby-player/sensor"
require "ruby-player/ranger"


