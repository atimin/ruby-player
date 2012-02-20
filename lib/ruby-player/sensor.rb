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

module Player
  class Sensor

    # State of sensor
    # @return [Hash] { :range, :intensity }
    attr_reader :state
    attr_reader :geom

    def initialize(index, ranger)
      @index, @ranger = index, ranger
      @state = { ranger: 0.0, intensity: 0.0 }
      @geom = {px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0,
        sw: 0.0, sl: 0.0, sh: 0.0
      }
    end
    
    # Range data [m]
    # @return [Float]
    def range
      @state[:range]
    end

    # Intensity data [m]. 
    # @return [Float]
    def intensity
      @state[:intensity]
    end
  end
end
