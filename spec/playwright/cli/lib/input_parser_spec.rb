RSpec.describe Playwright::Cli::Lib::InputParser do
  describe "#parsed?" do
    let(:command) { Class.new(Playwright::Cli::Lib::Base).new }
    let(:parser) { Playwright::Cli::Lib::InputParser.new([], command) }
    context "before #parse! has been called" do
      it "returns false" do
        expect(parser.parsed?).to be false
      end
    end
    context "after #parse! has been called" do
      before { parser.parse! }
      it "returns true" do
        expect(parser.parsed?).to be true
      end
    end
  end

  context "with a kitchen sink example" do
    let(:argv) { [] }
    before do
      @command = Class.new(Playwright::Cli::Lib::Base) do
        option :str_option, short: :s, type: :string, desc: 'does a thing'
        option :bool_option, desc: 'prints some extra nonsense'
        arguments :name, :message
      end
      @parser = Playwright::Cli::Lib::InputParser.new(argv, @command)
      @parser.parse!
    end
    describe "#banner"
    describe "#options" do
      context "after #parse! is called" do
        it "returns an options object" do
          expect(@parser.options).to be_a Playwright::Cli::Lib::OptionCollection
        end
        context "when the long option is passed" do
          let(:argv) { ["--str-option" "wow"] }
          it "the options object contains the string option" do
            expect(@parser.options.str_option).to eq('wow')
          end
        end
      end
    end
    describe "#args_and_subcommands"
  end
end