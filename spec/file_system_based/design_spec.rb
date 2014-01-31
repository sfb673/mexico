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

describe Mexico::FileSystem::Design do

  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','TESTCORPUS')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    @design = @corpus.designs.first
  end
  
  context "Attributes" do
    
    context "identifier" do
    
      it "should have accessor methods" do
        @design.should respond_to(:identifier, :identifier=)  
      end
  
      it "should have the right type" do
        @design.identifier.kind_of?(String).should be true
        @design.identifier.should match /^\w[-\w\d_]*$/
      end
      
      it "should have the correct value" do
        @design.identifier.should eq "example-design"
      end
      
    end
    
    context "name" do
          
      it "should have accessor methods" do
        @design.should respond_to(:name, :name=)  
      end
  
      it "should have the right type" do
        @design.name.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @design.name.should eq "Example Design"
      end
      
    end
    
    context "description" do
          
      it "should have accessor methods" do
        @design.should respond_to(:description, :description=)  
      end
  
      it "should have the right type" do
        @design.description.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @design.description.should eq "Design Description"
      end
      
    end
    
  end


  context "Aggregated components" do

    it 'should have one or more design components' do
      @design.should respond_to(:design_components)
      @design.design_components.size.should eq 1
    end

    it 'should return correct values for the first design component' do
      @design.design_components[0].identifier.should eq 'example-design-component'
      @design.design_components[0].name.should eq 'Example Design Component'
      @design.design_components[0].media_type.should eq ::Mexico::Constants::MediaTypes::VIDEO
    end

  end

end
