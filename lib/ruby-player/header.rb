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
  # Header of message
  class Header
    include Common

    attr_reader :dev_addr, :type, :subtype, :time, :seq, :size

    def initialize(param = {})
      @dev_addr = param[:dev_addr]
      @type = param[:type].to_i
      @subtype = param[:subtype].to_i
      @time = param[:time] || Time.now.to_f / 1000
      @seq = param[:seq].to_i
      @size = param[:size].to_i

    end

    def Header.decode(str)
      dev_addr = DevAddr.decode(str[0,16])
      type, subtype, time, seq, size = str[16,24].unpack("NNGNN")
      Header.new(dev_addr: dev_addr, type: type, subtype: subtype, time: time, seq: seq, size: size)
    end

    def Header.from_a(ary)
      Header.decode ary.pack("NNNNNNGNN")
    end

    def encode
      @dev_addr.encode + [@type, @subtype, @time, @seq, @size].pack("NNGNN")
    end

    def ==(other)
      @dev_addr == other.dev_addr and @type == other.type and @subtype == other.subtype and @time == other.time and @seq == other.seq and @size == other.size
    end

    def to_s
      "header to #@dev_addr of message [type=#{type_name}, subtype=#{subtype_name}, size=#@size]"
    end

    def type_name
      @type_name ||= search_msg_type_name(@type)
    end

    def subtype_name
      @subtype_name ||= search_msg_subtype_name(dev_addr.interface_name, type_name, @subtype)
    end

    private
    def search_msg_type_name(type)
      name = search_const_name type, /PLAYER_MSGTYPE_[\w]*/
      if name != ""
        name[7..-1]
      else
        type.to_s
      end
    end

    def search_msg_subtype_name(interface_name, type_name, subtype)
      type_prefix = type_name == "MSGTYPE_RESP_ACK" ? "" : type_name.split("_")[-1] 
      name = search_const_name subtype, "PLAYER_" + interface_name.upcase + "_" + type_prefix + ".*"
      if name != ""
        name[7..-1]
      else
        subtype.to_s
      end
    end
  end
end 
