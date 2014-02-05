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

describe Mexico::FileSystem::Scale do


  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','mexico-testcorpus','mexico')
    @corpus = Mexico::FileSystem::Corpus.open(@basepath)
    @trans_resource = @corpus.resources[1]
    @anno_file = @trans_resource.local_files.find{ |i| i.identifier=="mexico-transcription-toe" }
    @trans_resource.load
    @annodoc = @trans_resource.document
  end


  it "has a scales collection" do
    @trans_resource.should_not eq nil
    @trans_resource.document.should_not eq nil
    @trans_resource.document.should respond_to(:scales)
  end

  it "has one scale inside the collection" do
    @annodoc.scales.size.should be 1
  end

  it "has a scale with working accessors" do
    scale = @annodoc.scales[0]
    scale.should respond_to(:identifier)
    scale.should respond_to(:name)
    scale.should respond_to(:unit)
    scale.should respond_to(:dimension)
    scale.should respond_to(:role)
    scale.should respond_to(:mode)
    scale.should respond_to(:continuous?)
  end

  context "has a scale with" do
    # continuous="true" id="timeline" name="Timeline" mode="ratio" dimension="time" unit="s" role="single timeline"

    it "identifier" do
      @annodoc.scales[0].identifier.should eq "timeline"
    end

    it "name" do
      @annodoc.scales[0].name.should eq "Timeline"
    end

    it "unit" do
      @annodoc.scales[0].unit.should eq "s"
    end

    it "dimension" do
      @annodoc.scales[0].dimension.should eq "time"
    end

    it "role" do
      @annodoc.scales[0].role.should eq "single timeline"
    end

    it "mode" do
      @annodoc.scales[0].mode.should eq "ratio"
    end

    it "continuous" do
      @annodoc.scales[0].continuous?.should eq true
    end

  end


end