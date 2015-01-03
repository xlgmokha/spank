describe Spank::IOC do
  after :each do
    Spank::IOC.unbind
  end

  context "when bound to a container" do
    let(:container) { double }
    let(:component) { double }

    before :each do
      allow(container).to receive(:resolve).with(:dbconnection).and_return(component)
      Spank::IOC.bind_to(container)
    end

    it "resolves the item from the container" do
      expect(Spank::IOC.resolve(:dbconnection)).to eq(component)
    end
  end

  context "when nothing is bound" do
    it "raises a meaningful exception" do
      expect { Spank::IOC.resolve(:food) }.to raise_error(Spank::ContainerError)
    end
  end
end
