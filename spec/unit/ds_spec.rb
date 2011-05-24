

require 'spec_helper'


describe DS::MetaHash do
  before(:each) do
    class Dummy < DS::MetaHash
      field :name, :required => true
      field :location, :default => 'hyderabad'
      field :id
    end
    @report ||= Dummy.new
  end
  
  describe 'should have three fields' do
    it { Dummy.fields.size.should == 3 }
    it { Dummy.fields[:location][:default].should == 'hyderabad' }
    it { Dummy.fields[:name][:required].should == true }
  end
  
  context '#instance' do
    before { 
      @report = Dummy.new 
      @report.id = 1
    }
    it { @report.location.should == 'hyderabad' }
    it { @report.id.should == 1 }
    
  end
  
end