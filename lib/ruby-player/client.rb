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
  # The client object manages the connection with the Player server
  #
  # @example
  #
  #   require 'ruby-player'
  #   Player::Client.connect("localhost") do |robot|
  #     pos2d = robot[:position2d, 0]
  #     ranger = robot[:ranger, 0]
  #     pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
  #     robot.loop do
  #       puts "Position: x=#{pos2d.odometry[:px]}, y=#{pos2d.odometry[:py]}, a=#{pos2d.odometry[:pa]}"
  #       puts "Ranger data: #{ranger.ranges.join(",")}"
  #     end
  #   end
  class Client
    include CType
    include Common 

    module C
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_client_create, [:pointer, :string, :int], :pointer
      attach_function :playerc_client_destroy, [:pointer],  :void
      attach_function :playerc_client_connect, [:pointer], :int
      attach_function :playerc_client_disconnect, [:pointer],  :int


      attach_function :playerc_client_read, [:pointer],  :void
    end

    # Initialize client
    # @param [String] host host address
    # @param port number of port default 6665  
    def initialize(host, port=6665)
      @client = ClientStruct.new(C.playerc_client_create(nil, host, port.to_i))

      try_with_error C.playerc_client_connect(@client)

      ObjectSpace.define_finalizer(self, Client.finilazer(@client))
      if block_given?
        yield self
        close
      else
        self
      end
    end

    class << self
      alias_method :connect, :new
    end

    # Read data from server and update all subscribed proxy objects
    def read
      C.playerc_client_read(@client) 
    end

    # Get proxy object
    #
    # @example 
    #   pos2d = client[:position2d, 0]
    #
    # @param type type name of proxy object
    # @param index index of proxy object
    # @return proxy object
    def [](type, index)
      type_name = type.to_s.capitalize
      (eval type_name).send(:new, @client, index)
    end

    # Check connection
    def closed?
      @client[:connected] == 0
    end

    # Close connection
    def close
      try_with_error C.playerc_client_disconnect(@client)
    end

    # Loop for control code
    #
    # @example
    #   cl.loop(0.5) do
    #     #...you control code
    #   end
    #
    # @param period period cicles in seconds
    def loop(period=1.0)
      while(true) do
        read
        yield
        sleep(period.to_f)
      end
    end

    def Client.finilazer(client)
      lambda do
        C.playerc_client_disconnect(client) if client[:connected] > 0
        C.playerc_client_destroy(client)
      end
    end
  end
end
