# This file is part of the MExiCo gem.
# Copyright (c) 2012 Peter Menke, SFB 673, Universität Bielefeld
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

describe Mexico::FileSystem::Trial do

  # set up an initial corpus representation from the example file
  before(:each) do
    @basepath = File.join(File.dirname(__FILE__), '..','..','assets','TESTCORPUS')
    @xml = File.open(File.join(@basepath,'Corpus.xml'),'rb') { |f| f.read }
    @corpus = Mexico::FileSystem::Corpus.from_xml(@xml, {:path => @basepath})
    @design = @corpus.designs.first
    @other_design = @corpus.designs[1]
    @trial = @corpus.trials.first
  end
  
  context "Attributes" do
    
    context "identifier" do
    
      it "should have accessor methods" do
        @trial.should respond_to(:identifier, :identifier=)  
      end
  
      it "should have the right type" do
        @trial.identifier.kind_of?(String).should be true
        @trial.identifier.should match /^\w[-\w\d_]*$/
      end
      
      it "should have the correct value" do
        @trial.identifier.should eq "example-trial"
      end
      
    end
    
    context "name" do
          
      it "should have accessor methods" do
        @trial.should respond_to(:name, :name=)  
      end
  
      it "should have the right type" do
        @trial.name.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @trial.name.should eq "Example Trial"
      end
      
    end
    
    context "description" do
          
      it "should have accessor methods" do
        @trial.should respond_to(:description, :description=)  
      end
  
      it "should have the right type" do
        @trial.description.kind_of?(String).should be true
      end
      
      it "should have the correct value" do
        @trial.description.should eq "Trial Description"
      end
      
    end
    
    context "running_number" do
    
      it "should have accessor methods" do
        @trial.should respond_to(:running_number, :running_number=)  
      end
  
      it "should have the right type" do
        @trial.running_number.kind_of?(Integer).should be true
      end
      
      it "should have the correct value" do
        @trial.running_number.should eq 1
      end
      
    
    end
    
    
  end


  context "Aggregated components" do
    
    it "should respond to id method" do
      @trial.should respond_to(:design_id)
    end
    
    it "should respond to object getter method" do
      @trial.should respond_to(:design)
    end
    
    it "should deliver the correct design object" do
      @trial.design.identifier.should eq @design.identifier
      @trial.design.name.should eq @design.name
      @trial.design.description.should eq @design.description
    end
    
    it "should, upon change, use the correct design object" do
      @trial.design.identifier.should eq @design.identifier
      @trial.design=@other_design
      @trial.design.identifier.should eq @other_design.identifier
    end
    
  end

end
