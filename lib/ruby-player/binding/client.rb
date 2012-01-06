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
#
module Player
  module Binding 
    module Client
      extend FFI::Library
      ffi_lib "playerc"

      attach_function :playerc_client_create, [:pointer, :string, :int], :pointer
      attach_function :playerc_client_destroy, [:pointer],  :void
      attach_function :playerc_client_connect, [:pointer], :int
      attach_function :playerc_client_disconnect, [:pointer],  :int


      attach_function :playerc_client_read, [:pointer],  :void
    end
  end
end
