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
    @testfile = File.join(File.dirname(__FILE__), '..','..','assets','out_only')
    #@basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','structured')
    #@xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    #@corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    #@resource = @corpus.resources[1]
  end

  context 'writes a correct ToE structure' do

    it 'to a local file' do
      @toe_doc = Mexico::FileSystem::ToeDocument.new
      @toe_doc.add_standard_timeline('s')
      @timeline = @toe_doc.scales.first
      (1..4).each do |x|
        @toe_doc.layers << Mexico::FileSystem::Layer.new(identifier: 'layer01', name: "Layer #{x}")
      end
      # @todo add layer hierarchies
      vals = %w(yes all work and no play makes jack andsoon)
      (1..8).each do |n|
        puts @toe_doc.class.name
        @toe_doc.add_item(Mexico::FileSystem::Item.new(identifier: "i#{n}")) do |i|
          i.data = Mexico::FileSystem::Data.new(string_value: vals[n-1])
        end
      end

      # create predecessors and successors
      (0..6).each do |n|
        puts "i 1 exists? %s" % @toe_doc.items[n]
        puts "i 2 exists? %s" % @toe_doc.items[n+1]
        @toe_doc.items[n].item_links   << Mexico::FileSystem::ItemLink.new(target_object: @toe_doc.items[n+1], role: 'successor')
        @toe_doc.items[n+1].item_links << Mexico::FileSystem::ItemLink.new(target_object: @toe_doc.items[n],   role: 'predecessor')
      end

      # points, first layer
      (0..3).each do |n|
        @toe_doc.items[n].point_links   << Mexico::FileSystem::PointLink.new(target_object: @timeline, point: 100.0*(n+1))
        @toe_doc.items[n].layer_links   << Mexico::FileSystem::LayerLink.new(target_object: @toe_doc.layers[0])
      end

      # points, first layer
      (4..7).each do |n|
        @toe_doc.items[n].interval_links << Mexico::FileSystem::IntervalLink.new(target_object: @timeline, min: 100.0*(n+1), max: 100.0*(n+2))
        @toe_doc.items[n].layer_links    << Mexico::FileSystem::LayerLink.new(target_object: @toe_doc.layers[1])
      end

      File.open(File.join(@testfile,'construct_and_write_spec.toe'), "w:utf-8") do |file|
        file << @toe_doc.to_xml
      end
      @toe_doc.should_not be_nil
    end

  end

end