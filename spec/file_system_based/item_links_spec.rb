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

describe Mexico::FileSystem::Resource do

  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','fiesta','elan')
    @file = File.open(File.join(@basepath,'ElanFileFormat.eaf'),'rb') { |f| f.read }
    @fiesta_document = ::Mexico::Fiesta::Interfaces::ElanInterface.instance.import(@file)
  end

  context 'our little corpus on the prairie' do

    context 'should link from first design to two trials' do

      it 'should have the method' do
        puts @fiesta_document.scales
      end

    end

  end

  context 'item linking' do

    it 'should behave correctly before testing' do
      puts @fiesta_document.items.size
      @fiesta_document.layers.each do |layer|
        puts layer.name
        #puts "  /#{layer.items}/"
        #puts "  /#{layer.items.class.name}/"
        puts "  /#{layer.items.size}/"
        layer.items.each do |i|
          puts "    #{i.data.string_value}"
          i.item_links.each do |ili|
            puts "      -(#{ili.role})-> #{ili.target_object}"
          end
        end
      end
    end

    it 'should behave correctly before testing' do
      l1 = Mexico::FileSystem::Layer.new(identifier: 'test1', name: 'test1')
      l2 = Mexico::FileSystem::Layer.new(identifier: 'test2', name: 'test2')
      @fiesta_document.layers << l1
      @fiesta_document.layers << l2

      puts "L1: %s" % l1
      puts "L2: %s" % l2

      # add items
      # link them
      # check if additional links occur in the correct way
    end

  end

end