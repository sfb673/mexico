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

describe Mexico::Fiesta::Interfaces::ElanInterface do

  before(:each) do
    @basepath = File.join File.dirname(__FILE__), '..', '..'
    @assetspath = File.join @basepath, 'assets'
  end

  context 'Fiesta ' do
    context 'Interfaces ' do
      context 'Elan ' do
        it 'reads data from a test file' do
          path = File.join @assetspath, 'fiesta', 'elan'
          filename = File.join path, 'Trial04.eaf' #'ElanFileFormat.eaf'
          @fdoc = ::Mexico::Fiesta::Interfaces::ElanInterface.import(File.open(filename))
          File.open(File.join(path,'test.out.fst'),'w') do |f|
            f << @fdoc.to_xml
          end
        end

        it 'exports a FiESTA file to EAF' do
          @fdoc = ::Mexico::FileSystem::FiestaDocument.open(File.join(@assetspath, 'fiesta', 'elan', 'test.out.fst'))  # Fiesta::Interfaces::ElanInterface.import(File.open(filename))
          @fdoc.should_not be nil
          File.open(File.join(@assetspath, 'fiesta', 'elan', 'test.out.eaf'),'w') do |f|
            ::Mexico::Fiesta::Interfaces::ElanInterface::export(@fdoc, f)
          end
        end

        it 'imports and exports an EAF document and mostly preserves its structure and contents' do
          path = File.join @assetspath, 'fiesta', 'elan'
          filename = File.join path, 'Trial04.eaf'
          @fdoc = ::Mexico::Fiesta::Interfaces::ElanInterface.import(File.open(filename))
          # ::Mexico::FileSystem::FiestaDocument.open(File.join(@assetspath, 'fiesta', 'elan', 'test.out.fst'))  # Fiesta::Interfaces::ElanInterface.import(File.open(filename))
          @fdoc.should_not be nil
          File.open(File.join(@assetspath, 'fiesta', 'elan', 'Trial04.fst'),'w') do |f|
            f << @fdoc.to_xml
          end
          File.open(File.join(@assetspath, 'fiesta', 'elan', 'Trial04.OUT.eaf'),'w') do |f|
            ::Mexico::Fiesta::Interfaces::ElanInterface::export(@fdoc, f)
          end
        end


      end
    end
  end

end