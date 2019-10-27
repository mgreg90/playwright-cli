RSpec.describe Playwright::Cli::Lib::Finish do
  let(:runtime) do
    includer = Class.new
    includer.include Playwright::Cli::Lib::Finish
    includer.new
  end

  describe "#finish" do
    context "on success" do
      it "exits with status 0" do
        expect { runtime.finish :success }.to raise_error SystemExit do |err|
          expect(err.status).to eq 0
        end
      end
    end
    context "on failure" do
      it "exits with status 1" do
        expect { runtime.finish :failure }.to raise_error SystemExit do |err|
          expect(err.status).to eq 1
        end
      end
    end
  end
end