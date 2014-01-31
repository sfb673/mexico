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

describe Mexico::FileSystem::FiestaDocument do

  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'

  end

  context 'Fiesta ' do
    context 'Read Fiesta files' do
      it 'reads data from a fiesta file' do
        @path = File.join @basepath, 'assets', 'fiesta', 'b6'
        @filename = File.join(@path,'test.out.fst')
        @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)
        @fdoc.should_not be nil
      end

      it 'writes data to a dot file' do
        @path = File.join @basepath, 'assets', 'fiesta', 'b6'
        @filename = File.join(@path,'test.out.fst')
        @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)
        @fdoc.should_not be nil
        @outfile = File.join(@path,'test.dot')
        File.open(@outfile, 'w') do |f|
          ::Mexico::Fiesta::Interfaces::DotInterface.instance.export @fdoc, f
        end
      end


      it 'handles maps' do
        @path = File.join @basepath, 'assets', 'fiesta', 'b6'
        @filename = File.join(@path,'map.fst')
        @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)
        @fdoc.should_not be nil
        puts "="*32
        @outfile = File.join(@path,'map.OUT.fst')
        File.open(@outfile, 'w') do |f|
          f << @fdoc.to_xml
        end
      end


      it 'reads layer connectors properly' do

        @path = File.join @basepath, 'assets', 'fiesta', 'b6'
        @filename = File.join(@path,'layer_connectors.fst')
        @fdoc = ::Mexico::FileSystem::FiestaDocument.open(@filename)
        @fdoc.layer_connectors.size.should be 2

        ffirst = @fdoc.layer_connectors.first
        ffirst.identifier.should eq 'chats_to_sentences'

      end

    end
  end
end