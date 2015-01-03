module Spank
  describe Proxy do
    subject { Proxy.new(target) }
    let(:target) { double("target", :greet => nil) }

    context "when invoking a method" do
      before { subject.greet('blah') }

      it "sends the message to the target" do
        expect(target).to have_received(:greet).with('blah')
      end
    end

    context "when an interceptor is registered" do
      context "when invoking a method" do
        let(:interceptor) { double('interceptor', :intercept => "") }

        before :each do
          subject.add_interceptor(:greet, interceptor)
          subject.greet("blah")
        end
        it "allows the interceptor to intercept the call" do
          expect(interceptor).to have_received(:intercept)
        end
      end

      context "when invoking a method with a block" do
        it "passes the block to the target" do
          proxy = Proxy.new([])
          expect do
            proxy.each do |x|
              raise StandardError
            end
          end.to raise_error
        end
      end
    end

    context "when invoking a method that is not defined on the target" do
      it "raises an error" do
        expect { Proxy.new("blah").goodbye }.to raise_error
      end
    end
  end
end
