# This file is part of the MExiCo gem.
# Copyright (c) 2012 Peter Menke, SFB 673, Universität Bielefeld
# http://www.sfb673.org
#
# MExiCo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# MExiCo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with MExiCo. If not, see
# <http://www.gnu.org/licenses/>.

# The Corpus core module contains methods for implementations of the
# corpus class that are independent of the implementation.
module Mexico::Core::CorpusCore
  
  #def included(x)
  #  puts "CorpusCore is now included in #{x}."  
  #end
  
  #def extended(x)
  #  puts "CorpusCore now extends #{x}."  
  #end
  
  # simple test method that can be called to see whether the module
  # was included successfully
  def core_included?
    true
  end  
  
end


