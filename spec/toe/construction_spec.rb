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

describe Mexico::FileSystem::ToeDocument do

  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','structured')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    @resource = @corpus.resources[1]
  end

  context 'should yield a correct xml representation when constructed from scratch' do

    it 'has a local file' do
      local_file = @resource.local_files[0]
    end

    it 'can read annotation data' do
      @resource.load.should_not eq nil
    end

    it 'has two items' do
      @resource.load
      @resource.document.items.size.should be 2
    end

    it 'responds to the item link collection' do
      @resource.load.items[0].should respond_to :item_links
    end
    it 'responds to the layer link collection' do
      @resource.load.items[0].should respond_to :layer_links
    end

    it 'responds to the interval link collection' do
      @resource.load.items[0].should respond_to :interval_links
    end

    it 'responds to the point link collection' do
      @resource.load.items[0].should respond_to :point_links
    end

    it 'has items with correct number of linked layers' do
      @resource.load
      (0..1).each do |n|
        @resource.document.items[n].layer_links.size.should eq 1
      end
    end

    it 'has items with correctly linked layers' do
      @resource.load
      (0..1).each do |n|
        @resource.document.items[n].layer_links[0].target_object.should eq @resource.document.layers[0]
      end
    end

    it 'has items with correct number of linked items' do
      @resource.load
      (0..1).each do |n|
        @resource.document.items[n].item_links.size.should eq 1
      end
    end

    context 'has items with correctly linked other-items' do

      it "has first item with correct item target" do
        @resource.load
        puts "i0 :       %s" % @resource.document.items[0].object_id
        puts "i1 :       %s" % @resource.document.items[1].object_id
        puts "i0 link t: %s" % @resource.document.items[0].item_links[0].target_object.object_id
        puts "i1 link t: %s" % @resource.document.items[1].item_links[0].target_object.object_id
        @resource.document.items[0].item_links[0].target_object.should eq @resource.document.items[1]
      end

      it "has second item with correct item target" do
        @resource.load
        @resource.document.items[1].item_links[0].target_object.should eq @resource.document.items[0]
      end

      it "has first item with correct role" do
        @resource.load
        @resource.document.items[0].item_links[0].role.should eq "successor"
      end

      it "has second item with correct role" do
        @resource.load
        @resource.document.items[1].item_links[0].role.should eq "predecessor"
      end
    end

  end

end