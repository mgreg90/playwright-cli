RSpec.describe Playwright::Cli do
  it "has a version number" do
    expect(Playwright::Cli::VERSION).not_to be nil
  end

  describe Playwright::Cli::Base do
    describe "#version" do
      context "when a version is set" do
        let(:inheritor) do
          Class.new(Playwright::Cli::Base) do
            root 'test'
            version '0.0.1'
          end
        end
        it "returns the version number from the class" do
          expect(inheritor.version).to eq '0.0.1'
        end
        it "returns the version number from the instance" do
          expect(inheritor.new.version).to eq '0.0.1'
        end
      end
    end

    describe "#root" do
      context "when a root is set" do
        before do
          class Inheritor < Playwright::Cli::Base
            root 'my-command'
          end
        end
        it "returns the root from the class" do
          expect(Inheritor.root).to eq 'my-command'
        end
        it "returns the root from the instance" do
          expect(Inheritor.new.root).to eq 'my-command'
        end
      end
    end

    describe "#arguments" do
      context "when arguments are set" do
        before do
          class Inheritor < Playwright::Cli::Base
            arguments %i(name age)
          end
        end
        it "returns the arguments from the class" do
          expect(Inheritor.arguments).to eq [:name, :age]
        end
        it "returns the arguments from the instance" do
          expect(Inheritor.new.arguments).to eq [:name, :age]
        end
        it "shortened alias #args works from the class" do
          expect(Inheritor.args).to eq [:name, :age]
        end
        it "shortened alias #args works from the instance" do
          expect(Inheritor.new.args).to eq [:name, :age]
        end
      end
    end

    describe "#option" do
      let(:inheritor) do
        Class.new(Playwright::Cli::Base) do
          option :option1, short: :o, type: :string
          option :option2
        end
      end
      context "setting all inputs" do
        it "sets the option" do
          expect(inheritor.options[0].name).to eq :option1
          expect(inheritor.options[0].short).to eq :o
          expect(inheritor.options[0].type).to eq :string
        end
      end
      context "using defaults" do
        it "sets the option" do
          expect(inheritor.options[1].name).to eq :option2
          expect(inheritor.options[1].short).to be_nil
          expect(inheritor.options[1].type).to eq :boolean
        end
      end
      context "when options are set" do
        let(:option1) do
          Playwright::Cli::Option.new(
            name: :option1,
            short: :o,
            type: :string
          )
        end
        let(:option2) { Playwright::Cli::Option.new(name: :option2) }
        it "returns the options from the class" do
          expect(inheritor.options).to eq [option1, option2]
        end
        it "returns the options from the instance" do
          expect(inheritor.new.options).to eq [option1, option2]
        end
      end
      context "when there are two inheritors" do
        let(:inheritor2) do
          Class.new(Playwright::Cli::Base) do
            option :option3
          end
        end
        it "they do not share attributes" do
          expect(inheritor.options.length).to eq 2
          expect(inheritor2.options.length).to eq 1
        end
      end
    end

    describe "#subcommand" do
      context "when subcommand is a playwright class" do
        let(:my_subcommand) { Class.new(Playwright::Cli::Base) }
        let(:inheritor) do
          subc = my_subcommand
          Class.new(Playwright::Cli::Base) do
            subcommand subc
          end
        end
        it "should register the subcommand" do
          expect(inheritor.subcommands[0]).to eq(my_subcommand)
        end
      end
      context "when subcommand is not a playwright class" do
        let(:my_subcommand) { Class.new }
        it "should raise a validation error" do
          subc = my_subcommand
          expect do
            Class.new(Playwright::Cli::Base) do
              subcommand subc
            end
          end.to raise_error(Playwright::Cli::ValidationError)
        end
      end
      context "when subcommand is a string" do
        let(:my_subcommand) { 'my-subcommand' }
        it "should raise a validation error" do
          subc = my_subcommand
          expect do
            Class.new(Playwright::Cli::Base) do
              subcommand subc
            end
          end.to raise_error(Playwright::Cli::ValidationError)
        end
      end
    end
  end
end
