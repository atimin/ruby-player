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
  # Gripper interface.
  #
  # The gripper interface provides access to a robotic gripper. 
  # A gripper is a device capable of closing around and carrying an object 
  # of suitable size and shape. On a mobile robot, a gripper is typically mounted near the floor on the front, 
  # or on the end of a robotic limb. Grippers typically have two "fingers" that close around an object. i
  # Some grippers can detect whether an objcet is within the gripper (using, for example, light beams). 
  # Some grippers also have the ability to move the a carried object into a storage system, 
  # freeing the gripper to pick up a new object, and move objects from the storage system back into the gripper.
  class Gripper
    def initialize(addr, client)
      super
      @data = { state: PLAYER_GRIPPER_STATE_OPEN, beams: 0, stored: 0 }
    end
 
  end
end
