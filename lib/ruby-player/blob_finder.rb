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
  # The blobfinder interface provides access to devices that detect blobs in images
  class BlobFinder < Device
    
    # Blobfinder data
    # @return [Hash] iby defult{ width: 0.0, height: 0.0, blobs: [] }
    attr_reader :state

    # Tracking color
    # @see #set_color
    # @return [Hash] by default { channel: 0, rmin: 0, rmax: 0, gmin: 0, gmax: 0, bmin: 0, bmax: 0 }
    attr_reader :color

    # Imager params.
    # @see #set_imager_params
    # @return [Hash] by default { brightness: 0, contrast: 0, colormode: 0, autogain: 0 }
    attr_reader :imager_params 

    def initialize(dev, client)
      super
      @blobs = []
      @state = { width: 0.0, height: 0.0, blobs: @blobs }
      @color = { channel: 0, rmin: 0, rmax: 0, gmin: 0, gmax: 0, bmin: 0, bmax: 0 }
      @imager_params = { brightness: 0, contrast: 0, colormode: 0, autogain: 0 }
    end

    # Query color settings
    # @return [BlobFinder] self
    def query_color
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_GET_COLOR)
      self
    end

    # Set tracking color.
    #`@param [Hash] color
    # @option [Integer] color :chanel For devices that can track multiple colors, indicate which color channel we are defining with this structure. 
    # @option [Integer] color :rmin RGB minimum and max values (0-255) 
    # @option [Integer] color :rmax RGB maximum and max values (0-255) 
    # @option [Integer] color :gmin RGB minimum and max values (0-255) 
    # @option [Integer] color :gmax RGB maximum and max values (0-255) 
    # @option [Integer] color :bmin RGB minimum and max values (0-255) 
    # @option [Integer] color :bmax RGB maximum and max values (0-255) 
    # @return [BlobFinder] self
    def set_color(color={})
      data = [
        color[:channel] || @color[:channel],
        color[:rmin] || @color[:rmin],
        color[:rmax] || @color[:rmax],
        color[:gmin] || @color[:gmin],
        color[:gmax] || @color[:gmax],
        color[:bmin] || @color[:bmin],
        color[:bmax] || @color[:bmax],
      ]

      send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_SET_COLOR, data.pack("N*"))
      self
    end
    
    # Set imager params 
    # Imaging sensors that do blob tracking generally have some sorts of image quality parameters that you can tweak.
    # @param [Hash] params
    # @option [Integer] params :brightness brightness (0-255)
    # @option [Integer] params :contrast contrast (0-255)
    # @option [Integer] params :color color mode (0=RGB/AutoWhiteBalance Off, 1=RGB/AutoWhiteBalance On, 2=YCrCB/AWB Off, 3=YCrCb/AWB On) 
    # @option [Integer] params :autogain auto gain (0=off, 1=on)
    # @return [BlobFinder] self
    def set_imager_params(params={})
      data = [
        params[:brightness] || @imager_params[:brightness],
        params[:contrast] || @imager_params[:contrast],
        params[:colormode] || @imager_params[:colormode],
        params[:autogain] || @imager_params[:autogain]
      ]

      send_message(PLAYER_MSGTYPE_REQ, PLAYER_BLOBFINDER_REQ_SET_IMAGER_PARAMS, data.pack("N*"))
      self
    end
  end
end
