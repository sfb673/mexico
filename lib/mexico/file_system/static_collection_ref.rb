# This file is part of the MExiCo gem.
# Copyright (c) 2012, 2013 Peter Menke, SFB 673, Universität Bielefeld
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
module Mexico::FileSystem::StaticCollectionRef

  # Defines a foreign key reference for an object. By default, it will
  # refer to the corresponding collection in the top-level corpus, and
  # it will retrieve the object via its +identifier+ field.
  def collection_ref(field_identifier, field_class, field_collection, default)
    
    field_name = field_identifier.to_s
    pluralized_field_name = "#{field_name}s"
    field_name_id = "#{field_name}_id"
    
    define_method field_name do
      if instance_variable_get("@#{field_name}").nil?
        self.send("#{field_name}=", instance_variable_get("@#{field_name_id}"))
        # self.instance_variable_set("@#{field_name}", instance_variable_get("@#{field_name_id}"))
      end
      return instance_variable_get("@#{field_name}")
    end
    
    define_method "#{field_name}=" do |param|
      #instance_variable_set("@#{field_name_id}", param.identifier)
      #instance_variable_set("@#{field_name}", param)

      if param.nil?
        instance_variable_set "@#{field_name}", default # Mexico::Constants::MediaTypes::OTHER
      elsif param.kind_of?(String)
        #@media_type = Mexico::Constants::MediaTypes::ALL.find{|m| m.identifier==new_media_type.to_s}
        instance_variable_set "@#{field_name}", field_collection.find{|i| i.identifier==param.to_s}
        if instance_variable_get("@#{field_name}").blank?
          instance_variable_set "@#{field_name}", default
        end
      elsif param.kind_of?(field_class)
        instance_variable_set "@#{field_name}", param
      end
      @media_type_id = @media_type.identifier
      instance_variable_set "@#{field_name_id}", instance_variable_get("@#{field_name}").identifier
      return instance_variable_get("@#{field_name}")
    end
    
  end
  
end