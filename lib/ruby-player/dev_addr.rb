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
  class DevAddr
    include Common

    attr_reader :host, :robot, :interface, :index

    def initialize(addr = {})
      @host = addr[:host].to_i
      @robot = addr[:robot].to_i
      @interface = addr[:interface].to_i
      @index = addr[:index].to_i
    end

    def DevAddr.decode(str)
      ary = str.unpack("NNNN")
      DevAddr.new(host: ary[0], robot: ary[1], interface: ary[2], index: ary[3])
    end

    def encode
      [@host, @robot, @interface, @index].pack("NNNN")
    end

    def interface_name
      @interface_name ||= search_interface_name(@interface)
    end

    def ==(other)
      @host == other.host and @robot == other.robot and @interface == other.interface and @index == other.index
    end

    def to_s
      "device addr [#@host:#@robot] #@interface_name:#@index"
    end

    def to_a
      [@host, @robot, @interface, @index]
    end

    private
    def search_interface_name(code)
      name = search_const_name code, /PLAYER_[\w]*_CODE/ 
      name.to_s.scan(/PLAYER_([\w]*)_CODE/).join.downcase
    end
  end
end 
