require 'spec_helper'
require 'lib/office'

describe Office do
  let(:office) { Office.new(name: "TechM", address: "CV Ramanagar, Bangalore") }

  it "is named TechM" do
    office.name.should == "TechM"
  end

  it "name has to be mandatory" do
    office.name.should be_true
  end
  
  it "should have more than 8 employees" do
    office.employees > 8
  end
  
  describe "#address" do
    it "has one address" do
      office.get_location.should be_true
    end
    
    it "should be in BNangalore" do
      office.get_location.include("Bangalore")
    end
  end
end
