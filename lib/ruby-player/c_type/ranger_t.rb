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
    class RangerStruct < FFI::Struct
      layout  :info, DeviceStruct,
              :element_count, :uint32,
              :min_angle, :double,
              :max_angle, :double,
              :angular_res, :double,
              :min_range, :double,
              :max_range, :double,
              :range_res, :double,
              :frequecy, :double,
              :device_pose, Pose3dStruct,
              :device_size, BBox3dStruct,
              :element_poses, :pointer,
              :element_sizes, :pointer,
              :ranges_count, :uint32,
              :ranges, :pointer,
              :intensities_count, :uint32,
              :intensities, :pointer,
              :bearings_count, :uint32,
              :bearings, :pointer,
              :points_count, :uint32,
              :points, :pointer
    end
  end
end

