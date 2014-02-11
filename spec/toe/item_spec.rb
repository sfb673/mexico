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

require 'spec_helper'

describe Mexico::FileSystem::Item do

  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','mexico')
    @corpus = Mexico::FileSystem::Corpus.open(@basepath)
    @trans_resource = @corpus.resources[1]
    @anno_file = @trans_resource.local_files.find{ |i| i.identifier=="mexico-transcription-toe" }
    @trans_resource.load
    @annodoc = @trans_resource.document
    @i = @annodoc.items[0]
  end


  it "has an items collection" do
    @trans_resource.should_not eq nil
    @trans_resource.document.should_not eq nil
    @trans_resource.document.should respond_to(:items)
  end

  it "has twelve items inside the collection" do
    @annodoc.items.size.should be 12
  end

  it "has a first item with working accessors" do
    @i.should respond_to(:identifier)
    @i.should respond_to(:data)
  end

  it 'has the correct identifier' do
    @i.identifier.should eq 'i1'
    puts "Data:   %s" % @i.data
    puts "String: %s" % @i.data.string_value
    puts "Int:    %s" % @i.data.int_value

  end


end