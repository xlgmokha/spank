require "spec_helper"

describe Spank::IOC do
  after :each do
    Spank::IOC.unbind
  end

  context "when bound to a container" do
    let(:container) { double }
    let(:component) { double }

    before :each do
      container.stub(:resolve).with(:idbconnection).and_return(component)
      Spank::IOC.bind_to(container)
    end

    let(:result) { Spank::IOC.resolve(:idbconnection) }

    it "resolves the item from the container" do
      result.should == component
    end
  end

  context "when nothing is bound" do
    it "raises a meaningful exception" do
      expect { Spank::IOC.resolve(:food) }.to raise_error(Spank::ContainerError)
    end
  end
end
