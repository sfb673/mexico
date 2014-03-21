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

describe Mexico::Util::FancyWriter do


  # set up an initial corpus representation from the example file
  before(:each) do
    @string = String.new

  end

  context 'FancyWriter' do

    it 'should write lines without method as they are' do
      @writer = Mexico::Util::FancyWriter.new(@string) do
        w "Foo"
      end
      @string.should eq "Foo\n"
    end

    it "should write comments without options as '# '" do
      @writer = Mexico::Util::FancyWriter.new(@string) do
        comment do
          w "Foo"
        end
      end
      @string.should eq "# Foo\n"
    end

    it "should write comments with options correctly" do
      @writer = Mexico::Util::FancyWriter.new(@string) do
        comment '// ' do
          w "Foo"
        end
      end
      @string.should eq "// Foo\n"
    end

    it "should export a complex example correctly." do
      @writer = Mexico::Util::FancyWriter.new(@string) do
        comment '# ' do
          line 'This is an example.'
          line 'This should be a block at the top.'
        end
        line 'config:'
        indent 4 do
          line 'setting:'
          indent 4 do
            line 'key: value.'
            comment do
              line 'This is an inside comment.'
            end
          end
        end
      end
      puts @string
    end
  end
end