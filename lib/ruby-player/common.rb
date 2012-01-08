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
  module Common
    module C
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_error_str, [],  :string
    end

    private
    def try_with_error(result)
      raise StandardError.new(C.playerc_error_str) if result != 0
    end
  end
end
