module Spank
  describe Container do
    subject { Container.new }

    describe "when resolving an item that has been registered" do
      let(:registered_item) { Object.new }

      before :each do
        subject.register(:item) do
          registered_item
        end
      end

      it "returns the registered item" do
        expect(subject.resolve(:item)).to eql(registered_item)
      end
    end

    describe "when resolving the container" do
      it "returns itself" do
        expect(subject.resolve(:container)).to eql(subject)
      end
    end

    describe "when multiple items are registered with the same key" do
      let(:jeans) { double("jeans") }
      let(:dress_pants) { double("dress pants") }

      before :each do
        subject.register(:pants) { jeans }
        subject.register(:pants) { dress_pants }
      end

      context "when resolving a single item" do
        it "returns the first one registered" do
          expect(subject.resolve(:pants)).to eql(jeans)
        end
      end

      context "when resolving all items" do
        it "returns them all" do
          expect(subject.resolve_all(:pants)).to match_array([jeans, dress_pants])
        end
      end

      context "when resolving all items for an unknown key" do
        it "returns an empty array" do
          expect(subject.resolve_all(:shirts)).to be_empty
        end
      end
    end

    context "when a component is registered as a singleton" do
      before :each do
        subject.register(:singleton) { Object.new }.as_singleton
      end

      it "returns the same instance of that component each time it is resolved" do
        expect(subject.resolve(:singleton)).to eql(subject.resolve(:singleton))
      end
    end

    context "when invoking the factory method" do
      it "passes the container through to the block" do
        result = nil
        subject.register(:item){ |item| result = item }
        subject.resolve(:item)
        expect(result).to eql(subject)
      end
    end

    context "when automatically resolving dependencies" do
      class Child
        attr_reader :mom, :dad

        def initialize(mom,dad)
          @mom = mom
          @dad = dad
        end
        def greeting(message)
        end
      end

      context "when the dependencies have been registered" do
        let(:mom) { double("mom") }
        let(:dad) { double("dad") }

        before :each do
          subject.register(:mom) { mom }
          subject.register(:dad) { dad }
        end

        it "glues the pieces together automatically" do
          child = subject.build(Child)
          expect(child).to be_a_kind_of(Child)
          expect(child.mom).to eql(mom)
          expect(child.dad).to eql(dad)
        end
      end

      context "when a component cannot automatically be constructed" do
        it "raises an error" do
          expect { subject.build(Child) }.to raise_error(ContainerError)
        end
      end
    end

    context "when registering interceptors" do
      class TestInterceptor
        attr_reader :called, :name
        def initialize(name)
          @name = name
          @called = false
        end
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
      let(:interceptor) { TestInterceptor.new("first") }
      let(:other_interceptor) { TestInterceptor.new("second") }

      before :each do
        subject.register(:command) { command }.intercept(:run).with(interceptor).and(other_interceptor)
        subject.register(:single_command) { command }.intercept(:run).with(interceptor)
        subject.resolve(:command).run("hi")
      end

      it "allows the first interceptor to intercept calls to the target" do
        expect(interceptor.called).to be_truthy
      end

      it "allows the second interceptor to intercept calls to the target" do
        expect(other_interceptor.called).to be_truthy
      end

      it "forwards the args to the command" do
        expect(command.called).to be_truthy
        expect(command.received).to match_array(['hi'])
      end
    end
  end
end
