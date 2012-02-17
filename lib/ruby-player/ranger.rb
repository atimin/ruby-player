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
  # The ranger proxy provides an interface to the ranger sensors built into robots
  # TODO Implement PLAYER_RANGER_DATA_RANGESTAMPED and PLAYER_RANGER_DATA_INTNSTAMPED
  #
  # @example
  #   ranger = robot.subscribe(:ranger, index: 0)
  #   ranger.rangers #=> [0.2, 0.1, 0.2]
  class Ranger < Device

    # Range data [m]
    # @return [Array] fot each sensor
    attr_reader :rangers

    # Intensity data [m]. 
    # @return [Array] fot each sensor
    attr_reader :intensities
 
    # Configuration of ranger
    # @see set_config
    attr_reader :config


    # Device geometry
    # @return [Hash] geometry { :px, :py. :pz, :proll, :ppitch, :pyaw, :sw, :sl, :sh, :sensors => [geom of sensors] }
    attr_reader :geom

    def initialize(addr, client)
      super
      @rangers = []
      @intensities = []
      @geom = {px: 0.0, py: 0.0, pz: 0.0, proll: 0.0, ppitch: 0.0, pyaw: 0.0, sw: 0.0, sl: 0.0, sh: 0.0, sensors: []}
      @config = { min_angle: 0.0, max_angle: 0.0, angular_res: 0.0, min_range: 0.0, max_range: 0.0, range_res: 0.0, frequecy: 0.0 }
    end
    
    # Query ranger geometry 
    # @return self
    def query_geom
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_GEOM)
      self
    end

    # Turn on ranger
    # @return self
    def turn_on!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [1].pack("N")) 
      self
    end
    
    # Turn off ranger
    def turn_off!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_POWER, [0].pack("N")) 
      self
    end

    def intensity_enable!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [1].pack("N"))
      self
    end

    def intensity_disable!
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_INTNS, [0].pack("N"))
      self
    end

    # Query ranger configuration
    def query_config
      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_GET_CONFIG)
      self
    end

    # Set config of ranger
    # @param [Hash] config params for setup
    # @option config :min_angle start angle of scans [rad] 
    # @option config :max_angle end angle of scans
    # @option config :angular_res scan resolution [rad]
    # @option config :min_range maximum range [m]
    # @option config :max_range minimum range [m]
    # @option config :range_res range resolution [m]
    # @option config :frequency scanning frequency [Hz]
    def set_config(config)
      data = [
        config[:min_angle].to_f || @ranger[:min_angle],
        config[:max_angle].to_f || @ranger[:max_angle],            
        config[:angular_res].to_f || @ranger[:angular_res],            
        config[:min_range].to_f || @ranger[:min_range],
        config[:max_range].to_f || @ranger[:max_range],
        config[:range_res].to_f || @ranger[:range_res],
        config[:frequecy].to_f || @ranger[:frequecy] 
      ]

      send_message(PLAYER_MSGTYPE_REQ, PLAYER_RANGER_REQ_SET_CONFIG, data.pack("G*"))
    end

    def fill(hdr, msg)
      case hdr.subtype
      when PLAYER_RANGER_DATA_RANGE
        data = msg.unpack("NNG*")
        @rangers = data[2..-1]
        debug "Get rangers #{@rangers.inspect}"
      when PLAYER_RANGER_DATA_INTNS
        data = msg.unpack("NNG*")
        @intensities = data[2..-1]
        debug "Get intensities #{@rangers.inspect}"
      when PLAYER_RANGER_DATA_GEOM
        read_geom(msg)
      else
        unexpected_message hdr
      end
    end

    def handle_response(hdr, msg)
      case hdr.subtype
      when PLAYER_RANGER_REQ_GET_GEOM
        read_geom(msg)
      when 2..4
        nil
      when PLAYER_RANGER_REQ_GET_CONFIG 
        read_config(msg)
      else
        unexpected_message hdr
      end
    end

    private
    def read_config(msg)
      fill_hash!(@config, msg.unpack("G*"))
    end
  
    def read_geom(msg)
      data = msg[0,72].unpack("G*")
      fill_hash!(@geom, data)
      debug("Get geom: " + geom_to_s(@geom))


      p_count =  msg[72,8].unpack("NN")
      p_count = p_count[0] + p_count[1] * 256
      poses = msg[80, 48*p_count].unpack("G" + (6*p_count).to_s)

      s_count = msg[80 + 48*p_count, 8].unpack("NN")
      s_count = s_count[0] + s_count[1] * 256
      sizes = msg[88 + 48*p_count, 24*s_count].unpack("G" +(3* s_count).to_s)

      p_count.times do |i|
        @geom[:sensors][i] ||= {}
        [:px, :py, :pz, :proll, :ppitch, :pyaw].each_with_index do |k,j|
          @geom[:sensors][i][k] = poses[6*i + j]
        end
        debug("Get poses for ##{i} sensor: px=%.2f, py=%.2f, pz=%.2f, proll=%.2f, ppitch=%.2f, pyaw=%.2f" % @geom[:sensors][i].values[0,6])
      end
      
      s_count.times do |i|
        @geom[:sensors][i] ||= {}
        [:sw, :sl, :sh].each_with_index do |k,j|
          @geom[:sensors][i][k] = sizes[3*i + j]
        end
        debug("Get sizes for ##{i} sensor: sw=%.2f, sl=%.2f, sh=%.2f" % @geom[:sensors][i].values[6,3])
      end

    end
  end
end 
