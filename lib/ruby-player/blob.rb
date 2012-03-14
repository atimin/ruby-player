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
  # Classs describing a single blob. 
  class Blob
    # @return [Hash] blob description => { :id, :color, :area, :x, :y, :left, :right, :top, :bottom, :range }
    attr_reader :state

    def initialize(index, blobfinder)
      @index, @blobfinder = index, blobfinder
      @state = { id: 0, color: 0, area: 0, x: 0, y: 0, left: 0, right: 0, top: 0, bottom: 0, range: 0.0 }
    end

    # Blob id
    # @return [Integer]
    def id
      state[:id]
    end

    # A descriptive color for the blob (useful for gui's). 
    # @return [Integer]
    def color
      state[:color]
    end

    # The blob area [pixels]. 
    # @return [Integer]
    def area
      state[:area]
    end

    # The blob centroid [pixels]. 
    def x
      state[:x]
    end
    
    # The blob centroid [pixels]. 
    def y
      state[:y]
    end

    # Bounding box for the blob [pixels]. 
    def left
      state[:left]
    end

    # Bounding box for the blob [pixels]. 
    def right 
      state[:right]
    end

    # Bounding box for the blob [pixels]. 
    def top
      state[:top]
    end

    # Bounding box for the blob [pixels]. 
    def bottom
      state[:bottom]
    end

    # Range to the blob center [m].
    def range
      state[:range]
    end
  end
end
