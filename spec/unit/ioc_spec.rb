describe Spank::IOC do
  after :each do
    Spank::IOC.unbind
  end

  context "when bound to a container" do
    let(:container) { double }
    let(:component) { double }
    let(:jeans) { double }
    let(:dress_pants) { double }

    before :each do
      allow(container).to receive(:resolve).
        with(:dbconnection).
        and_return(component)
      allow(container).to receive(:resolve_all).
        with(:pants).
        and_return([jeans, dress_pants])
      Spank::IOC.bind_to(container)
    end

    it "resolves the item from the container" do
      expect(Spank::IOC.resolve(:dbconnection)).to eq(component)
    end

    it "resolves all items from the container" do
      expect(Spank::IOC.resolve_all(:pants)).to match_array([
        jeans,
        dress_pants
      ])
    end
  end

  context "when nothing is bound" do
    it "raises a meaningful exception" do
      expect { Spank::IOC.resolve(:food) }.to raise_error(Spank::ContainerError)
      expect do
        Spank::IOC.resolve_all(:pants)
      end.to raise_error(Spank::ContainerError)
    end
  end
end
