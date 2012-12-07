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

# The +IdRef+ module provides a simple mechanism to map IDREF attributes
# in an XML document to Ruby objects that are stored elsewhere in the
# object tree. They are retrieved and accessed via the central corpus
# object.
module Mexico::FileSystem::IdRef

  # Defines a foreign key reference for an object. By default, it will
  # refer to the corresponding collection in the top-level corpus, and
  # it will retrieve the object via its +identifier+ field.
  def id_ref(field_name)
    
    pluralized_field_name = "#{field_name}s"
    field_name_id = "#{field_name}_id"
    
    define_method field_name do
      inst_var = instance_variable_get("@#{field_name}")
      inst_var = instance_variable_set("@#{field_name}", @corpus.send(pluralized_field_name).first{|x| x.identifier==instance_variable_get("@#{field_name_id}") }) if inst_var.nil?
      return inst_var
    end
    
    define_method "#{field_name}=" do |param|
      instance_variable_set("@#{field_name_id}", param.identifier)
      instance_variable_set("@#{field_name}", param)
    end
    
  end
  
end