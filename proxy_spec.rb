require "spec_helper"

module Booty
  describe Proxy do
    let(:sut) { Proxy.new(target) }
    let(:target) { fake }

    context "when invoking a method" do
      before { sut.greet('blah') }

      it "should send the message to the target" do
        target.should have_received(:greet, 'blah')
      end
    end

    context "when an interceptor is registered" do
      context "when invoking a method" do
        let(:interceptor) { fake }

        before :each do
          sut.add_interceptor(:greet, interceptor)
          sut.greet("blah")
        end
        it "should allow the interceptor to intercept the call" do
          interceptor.should have_received(:intercept)
        end
      end
      context "when invoking a method with a block" do
        it "should pass the block to the target" do
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
      it "should raise an error" do
        expect { Proxy.new("blah").goodbye }.to raise_error
      end
    end
  end
end
