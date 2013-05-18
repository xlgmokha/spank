require "spec_helper"

describe Spank::IOC do
  context "when bound to a container" do
    let(:container) { fake }
    let(:component) { fake }

    before :each do
      container.stub(:resolve).with(:idbconnection).and_return(component)
      Spank::IOC.bind_to(container)
    end

    let(:result) { Spank::IOC.resolve(:idbconnection) }

    it "should resove items from that container" do
      result.should == component
    end
  end
end
