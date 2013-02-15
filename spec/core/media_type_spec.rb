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

require 'spec_helper'

describe Mexico::Core::MediaType do
  
  
  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','TESTCORPUS')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    @resource = @corpus.resources.first
  end
  
  context 'Read MediaType field' do

    it 'should respond to all methods' do
      @resource.should respond_to(:media_type_id)
      @resource.should respond_to(:media_type)
      @resource.should respond_to(:media_type_id=)
      @resource.should respond_to(:media_type=)
    end

    it 'should default to OTHER if not given' do
      @resource.media_type_id.should be nil
      @resource.media_type.should eq Mexico::Constants::MediaTypes::OTHER
    end

    

  end

end