# encoding: utf-8
# This file is part of the MExiCo gem.
# Copyright (c) 2012-2014 Peter Menke, SFB 673, Universität Bielefeld
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

# This module contains various helper methods.
module Mexico::Util::FancyContainer

  #module ClassMethods

  def add_fancy_container(container_name, p_back_collection_name=nil)
    back_collection_name = p_back_collection_name.nil? ? "#{container_name.to_s}_container" : p_back_collection_name
    define_method(container_name) do |*args|
      coll = Array.new(instance_variable_get("@#{back_collection_name}"))
      if args.is_a?(Enumerable)
        if args.length==1
          if args.first.is_a?(String)
            # one argument in string form: assume an identifier, return a single object or nil
            return instance_variable_get("@#{back_collection_name}").find{|x| x.identifier == args.first }
          end
          if args.first.is_a?(Hash)
            # one argument in string form: assume a hash with conditions
            args.first.each do |key,val|
              if val.is_a?(String)
                coll.select!{|c| c.send(key).to_s==val }
              elsif val.is_a?(Regexp)
                coll.select!{|c| c.send(key).to_s=~val }
              end
            end
            return coll
          end
          if args.first.is_a?(Integer)
            return coll[args.first]
          end
        end
      end
      # otherwise:
      orig_coll = instance_variable_get("@#{back_collection_name}")
      orig_coll = [] if orig_coll.nil?
      Array.new(orig_coll)
    end
  end
end
