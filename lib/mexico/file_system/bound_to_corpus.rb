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

# XML bound elements know the corpus object, the corpus file, and
# the nokogiri element they come from and can write changes back to
# that file.

module Mexico::FileSystem::BoundToCorpus
  
  attr_accessor :corpus
  
  #sets up the bound between the object and the corpus elements
  def bind_to_corpus(param_corpus)
    @corpus = param_corpus
    
    if self.respond_to?(:when_bound_to_corpus)
      self.when_bound_to_corpus
    end
    
  end
    
end