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
  #     pos2d = robot.subscribe("position2d", index: 0)
  #     pos2d.set_speed(vx: 1, vy: 0, va: 0.2)
  #     #main loop
  #     robot.loop do
  #       puts "Position: x=%{px}, y=%{py}, a=%{pa}" % pos2d.position
  #     end
  #   end
  class Client < Device
    include Common 

    attr_reader :log_level

    # Initialize client
    # @param [String] host host of Player server 
    # @param [Hash] opts client options
    # @option opts :port port of connection
    # @option opts :log_level level of log messages [:debug,:notice, :warn, :error] default :notice
    def initialize(host, opts = {})
      port = opts[:port] || 6665
      @log_level = (opts[:log_level] || :notice).to_sym

      @socket = TCPSocket.new(host, port)
      @addr = DevAddr.new(host: 0, robot: 0, interface: PLAYER_PLAYER_CODE, index: 0)
      @client = self
      @devices = []

      banner = @socket.read(PLAYER_IDENT_STRLEN)
      notice "Connect with #{banner} in #{host}:#{port}"
      send_message PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DATAMODE, [PLAYER_DATAMODE_PULL].pack("N")

      debug "Set delivery mode in PULL"

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
    def read!
      send_message PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DATA, ""
      while read[0].type != PLAYER_MSGTYPE_SYNCH
      end
      nil
    end

    # Get proxy object
    #
    # @example 
    #   pos2d = client.subscribe(:position2d, index: 0)
    # 
    # @param [String,Symbol] type interface type name 
    # @param [Hash] opts of subscribing
    # @option opts :index index of device (default 0)
    # @option opts :access access level (default PLAYER_OPEN_MODE)
    def subscribe(type, opts = {})
      code = instance_eval("PLAYER_#{type.to_s.upcase}_CODE")
      index = opts[:index] || 0
      access = opts[:access] || PLAYER_OPEN_MODE

      notice "Subscribing to #{type}:#{index}"
      data = DevAddr.new(interface: code, index: index).to_a + [access, 0, 0]
      send_message PLAYER_MSGTYPE_REQ, PLAYER_PLAYER_REQ_DEV, data.pack("N*")

      read!
      
      @devices.select { |d| d.addr.interface == code && d.addr.index == index}.first
    end

    # Check connection
    def closed?
      @socket.closed?
    end

    # Close connection
    def close
      @socket.close
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
        read!
        yield
        sleep(period.to_f)
      end
    end

    def write(hdr, msg)
      send_header hdr
      @socket.write msg 
      @socket.flush
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when 0
        nil
      when PLAYER_PLAYER_REQ_DEV
        # read device identifier
        dev = DevAddr.decode(msg[0,PLAYERXDR_DEVADDR_SIZE])
        # read the granted access and driver name
        data = msg[PLAYERXDR_DEVADDR_SIZE,8].unpack("N*")
        access = data[0]
        # read driver name
        drv_name = msg[-data[1]-2..-1]

        if access == PLAYER_ERROR_MODE
          raise_error "Error subscribing to " + dev.interface_name + ":" + dev.index 
        end
        
        debug "Got response: #{dev.interface_name}:#{dev.index} (driver name - #{drv_name})"

        @devices << make_device(dev)
      when PLAYER_PLAYER_REQ_DATAMODE, PLAYER_PLAYER_REQ_DATA
        nil
      else
        warn "Don't implement ACK for subtype = #{hdr.subtype}"  
      end
    end
    
    private
    def make_device(dev)
      intf = dev.interface_name
      klass = Player.constants.each { |c| break c if c.to_s.downcase == intf }
      instance_eval(klass.to_s).send(:new, dev, self)
    end

    def read
      hdr = read_header
      msg = @socket.read(hdr.size)

      case hdr.type
      # Data message
      when PLAYER_MSGTYPE_DATA
        debug "Data for #{hdr.dev_addr.interface_name}:#{hdr.dev_addr.index}"
        fill_device hdr, msg

      # Acknowledgement response message
      when PLAYER_MSGTYPE_RESP_ACK
        if hdr.dev_addr.interface != PLAYER_PLAYER_CODE
          handle_response_device(hdr, msg)
        else
          handle_response(hdr, msg)
        end
      when PLAYER_MSGTYPE_RESP_NACK
        warn "NACK for subtype = #{hdr.subtype} from #{hdr}"
      when PLAYER_MSGTYPE_SYNCH
        nil
      else
        warn "Unknow message type = #{hdr.type} received in read()"
      end
      [hdr, msg]
    end

    def handle_response_device(hdr, msg)
      @devices.each do |dev|
        dev.handle_response(hdr, msg) if dev.addr == hdr.dev_addr
      end
    end

    def fill_device(hdr, msg)
      @devices.each do |dev|
        dev.fill(hdr, msg) if dev.addr == hdr.dev_addr
      end
    end

    def send_header(hdr)
      @socket.write hdr.encode
      @socket.flush
      debug "Send #{hdr}"
    end

    def read_header
      hdr = Header.decode(@socket.read(PLAYERXDR_MSGHDR_SIZE))
      debug "Read #{hdr}"
      hdr
    end
  end
end
