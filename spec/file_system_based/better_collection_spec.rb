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
include Mexico::FileSystem

describe Mexico::FileSystem::FiestaDocument do

  # set up an initial corpus representation from the example file
  before(:each) do
    #@basepath = File.join(File.dirname(__FILE__), '..','..','assets','TESTCORPUS')
    #@corpus = Mexico::FileSystem::Corpus.open(@basepath)

    @fiesta_document = FiestaDocument.new

    @scale = @fiesta_document.add_standard_timeline("s")

    @foo_layer = @fiesta_document.add_layer Layer.new identifier: 'foo', name: 'lily'
    @bar_layer = @fiesta_document.add_layer Layer.new identifier: 'bar', name: 'lotus'


    @item1 = @fiesta_document.add_item(identifier: 'i1') do |i|
      i.data = Mexico::FileSystem::Data.new(string_value: 'lion')
      i.add_layer_link(Mexico::FileSystem::LayerLink.new(target_object: @foo_layer))
    end


    @item2 = @fiesta_document.add_item(identifier: 'i2') do |i|
      i.data = Mexico::FileSystem::Data.new(string_value: 'tiger')
      i.add_layer_link(Mexico::FileSystem::LayerLink.new(target_object: @bar_layer))
    end

    @item3 = @fiesta_document.add_item(identifier: 'i1') do |i|
      i.data = Mexico::FileSystem::Data.new(string_value: 'bear')
      i.add_layer_link(Mexico::FileSystem::LayerLink.new(target_object: @bar_layer))
    end

  end

  context 'ActiveRecord-like collections' do


    it 'should detect the helper modules' do

      expect do
        ::Mexico
        ::Mexico::Util
      end.to_not raise_error

    end

    context 'Scales' do

      it 'should return the correct scale when asked for a string-based identifier' do
        @fiesta_document.scales(@scale.identifier).should eq @scale
        @fiesta_document.scales('other').should be nil
      end

      it 'should filter scales correctly by unit' do
        @fiesta_document.scales(unit: 's').should include(@scale)
        @fiesta_document.scales(unit: 'ms').should be_empty
      end

      it 'should filter scales correctly by dimension' do
        @fiesta_document.scales(dimension: Mexico::FileSystem::Scale::DIM_TIME).should include(@scale)
        @fiesta_document.scales(dimension: Mexico::FileSystem::Scale::DIM_SPACE).should be_empty
      end

      it 'should filter scales correctly by regexp id' do
        @fiesta_document.scales(identifier: /time/).should include(@scale)
        @fiesta_document.scales(identifier: /cauliflower/).should be_empty
      end

      it 'should select scales correctly by index' do
        @fiesta_document.scales(0).should eq @scale
      end

    end


    context 'Layers' do

      it 'should return the correct layer when asked for a string-based identifier' do
        @fiesta_document.layers(@foo_layer.identifier).should eq @foo_layer
        @fiesta_document.layers(@bar_layer.identifier).should eq @bar_layer
      end

      context 'hash-based filtering' do

        it 'should return the correct layers when given a hash with string values' do
          @fiesta_document.layers(name: @foo_layer.name).should eq [@foo_layer]
          @fiesta_document.layers(name: @bar_layer.name).should eq [@bar_layer]
          @fiesta_document.layers(identifier: @foo_layer.identifier).should eq [@foo_layer]
          @fiesta_document.layers(identifier: @bar_layer.identifier).should eq [@bar_layer]
          @fiesta_document.layers(identifier: @foo_layer.identifier, name: @foo_layer.name).should eq [@foo_layer]
          @fiesta_document.layers(identifier: @bar_layer.identifier, name: @bar_layer.name).should eq [@bar_layer]
          @fiesta_document.layers(identifier: @foo_layer.identifier, name: @bar_layer.name).should eq []
        end

        it 'should return the correct layers when given a hash with regexp values' do
          @fiesta_document.layers(name: /lil.*/).should eq [@foo_layer]
          @fiesta_document.layers(name: /lot.*/).should eq [@bar_layer]
          @fiesta_document.layers(name: /l.*/).should include(@foo_layer, @bar_layer)
        end

      end

    end

  end

  context 'Items' do

    it 'should return the correct item when asked for a string-based identifier' do
      @fiesta_document.items(@item1.identifier).should eq @item1
      @fiesta_document.items(@item2.identifier).should eq @item2
    end

    it 'should return the correct layers when given a hash with string values' do
      @fiesta_document.items(identifier: 'i1').should include(@item1)
      @fiesta_document.items(data: 'tiger').should include(@item2)
    end

  end


end