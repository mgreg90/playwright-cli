RSpec.describe Playwright::Cli::Lib::Io do
  let(:io) { Playwright::Cli::Lib::IoClass.new }
  describe "#say" do
    it "outputs the text" do
      expect { io.say "Wow!" }.to output("Wow!\n".cyan.bold).to_stdout
    end
  end

  describe "#ask" do
    before do
      allow($stdin).to receive(:gets).and_return('')
    end
    context "when asking a boolean question" do
      it "outputs the text" do
        expect { io.ask "Are you male?" }.to output("Are you male? [yN] \n".yellow).to_stdout
      end
      context "with a response" do
        before do
          allow($stdin).to receive(:gets).and_return('y')
        end
        it "returns the response" do
          expect(io.ask "Are you male?").to eq true
        end
      end
      context "with no response and a default" do
        before do
          allow($stdin).to receive(:gets).and_return("\n")
        end
        it "returns the default" do
          expect(io.ask "Are you male?", default: true).to eq true
        end
      end
    end
    context "when asking a string question" do
      before do
        allow($stdin).to receive(:gets).and_return('James')
      end
      context "when inline flag is true" do
        it "outputs the question inline" do
          expect { io.ask "What's your name?", type: :string, inline: true }.to output("What's your name? ".yellow).to_stdout
        end
      end
      it "outputs the question" do
        expect { io.ask "What's your name?", type: :string }.to output("What's your name?\n".yellow).to_stdout
      end
      it "stores the response" do
        response = io.ask "What's your name?", type: :string
        expect(response).to eq 'James'
      end
      context "when there is a default" do
        it "outputs the text" do
          expect { io.ask "What's your name?", type: :string, default: "Thomas" }.to output("What's your name? [default: 'Thomas']\n".yellow).to_stdout
        end
      end
    end
    context "when the type is invalid" do
      it "throws a Playwright::Cli::ValidationError" do
        expect { io.ask "What time is it?", type: :time }.to raise_error(Playwright::Cli::ValidationError)
      end
    end
  end

  describe "#warn" do
    it "outputs the text" do
      msg = "Careful! XYZ is will be deprecated in v2.0.0"
      expect { io.warn msg }.to output("#{msg}\n".yellow.bold).to_stdout
    end
  end

  describe "#error" do
    it "outputs the text" do
      msg = "Careful! XYZ is will be deprecated in v2.0.0"
      expect { io.error msg }.to output("#{msg}\n".red.bold).to_stdout
    end
  end
end