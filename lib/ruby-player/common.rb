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

require "isna"

module Player
  module Common
    private
    def debug(msg)
      if @log_level == :debug
        puts log_msg(:debug, msg)
      end
    end

    def notice(msg)
      if [:debug, :notice].include?(@log_level)
        puts log_msg(:notice, msg).to_ansi.normal
      end
    end

    def warn(msg)
      if [:debug, :log, :warn].include?(@log_level)
        puts log_msg(:warn, msg).to_ansi.blue
      end
    end

    def error(msg)
      if [:debug, :log, :warn, :debug].include?(@log_level)
        puts log_msg(:error, msg).to_ansi.red
      end
    end

    def log_msg(level, msg)
        "[ruby-player][#{level}]\t #{@addr.interface_name}:#{@addr.index}\t#{msg}"
    end

    def raise_error(err_msg)
      error err_msg
      raise StandardError.new(err_msg)
    end

    def search_const_name(value, tmpl)
      tmpl = Regexp.new(tmpl.to_s)
      consts = Player.constants.select { |c| c =~ tmpl}
      consts.each do |c|
        return c.to_s if Player.module_eval(c.to_s) == value
      end
      ""
    end

    def unexpected_message(hdr)
      warn "Get unexpection message type #{hdr.type_name}::#{hdr.subtype_name} for #@addr"
    end

    def geom_to_s(geom)
      "px=%.2f, py=%.2f, pz=%.2f, proll=%.2f, ppitch=%.2f, pyaw=%.2f, sw=%.2f, sl=%.2f, sh=%.2f" % geom.values
    end

    def pose_to_s(pose)
      "px=%.2f, py=%.2f, pz=%.2f, proll=%.2f, ppitch=%.2f, pyaw=%.2f" % pose.values
    end

    def size_to_s(size)
      "sw=%.2f, sl=%.2f, sh=%.2f" % size.values
    end
  end
end
