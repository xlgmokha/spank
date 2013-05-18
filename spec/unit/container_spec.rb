require "spec_helper"

module Booty
  describe Container do
    let(:sut) { Container.new }

    describe "when resolving an item that has been registered" do
      let(:registered_item) { Object.new }
      before :each do
        sut.register(:item) do
          registered_item
        end
      end
      before :each do
        @result = sut.resolve(:item) 
      end
      it "should return the registered item" do
        @result.should == registered_item
      end
    end
    describe "when resolving the container" do
      it "should return itself" do
        sut.resolve(:container).should == sut
      end
    end
    describe "when multiple items are registered with the same key" do
      let(:jeans) { fake }
      let(:dress_pants) { fake }
      before :each do
        sut.register(:pants) { jeans }
        sut.register(:pants) { dress_pants }
      end
      context "when resolving a single item" do
        before :each do
          @result = sut.resolve(:pants)
        end
        it "should return the first one registered" do
          @result.should == jeans
        end
      end
      context "when resolving all items" do
        before :each do
          @results = sut.resolve_all(:pants)
        end
        it "should return them all" do
          @results.should == [jeans, dress_pants]
        end
      end
      context "when resolving all items for an unknown key" do
        it "should return an empty array" do
          sut.resolve_all(:shirts).should be_empty
        end
      end
    end
    context "when a component is registered as a singleton" do
      before :each do
        sut.register(:singleton) { fake }.as_singleton
      end
      it "should return the same instance of that component each time it is resolved" do
        sut.resolve(:singleton).should == sut.resolve(:singleton)
      end
    end
    context "when invoking the factory method" do
      before :each do
        sut.register(:item){ |item| @result = item }
        sut.resolve(:item)
      end
      it "should pass the container through to the block" do
        @result.should == sut
      end
    end
    context "when automatically resolving dependencies" do
      class Child
        def initialize(mom,dad)
        end
        def greeting(message)
        end
      end

      context "when the dependencies have been registered" do
        let(:mom) { fake }
        let(:dad) { fake }
        before :each do
          sut.register(:mom) { mom }
          sut.register(:dad) { dad }
        end
        it "should be able to glue the pieces together automatically" do
          sut.build(Child).should be_a_kind_of(Child)
        end
      end
      context "when a component cannot automatically be constructed" do
        it "should raise an error" do
          expect { sut.build(Child) }.to raise_error(ContainerError)
        end
      end
    end
    context "when registering an interceptor" do
      class TestInterceptor
        attr_reader :called
        def intercept(invocation)
          @called = true
          invocation.proceed
        end
      end
      class TestCommand
        attr_reader :called, :received
        def run(input)
          @called = true
          @received = input
        end
      end
      let(:command) { TestCommand.new }
      let(:interceptor) { TestInterceptor.new }

      before :each do
        sut.register(:command) { command }.intercept(:run).with(interceptor)
        sut.resolve(:command).run("hi")
      end

      it "should allow the interceptor to intercept calls to the target" do
        interceptor.called.should be_true
      end

      it "should forward the args to the command" do
        #command.should have_received(:run, 'hi')
        command.called.should be_true
        command.received.should == ['hi']
      end
    end
  end
end
