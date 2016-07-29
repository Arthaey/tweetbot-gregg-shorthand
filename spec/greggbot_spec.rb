RSpec.describe Greggbot do
  before(:all) { $stderr.reopen(File.new("/dev/null", "w")) }

  subject(:bot) { Greggbot.new("config.yaml.example") }
  subject(:real_bot) { Greggbot.new("config.yaml") } # TODO: create test account

  context "with config file" do
    it "should read secret keys & tokens" do
      expect(bot.access_token).to    eq("ACCESS TOKEN")
      expect(bot.access_secret).to   eq("ACCESS TOKEN SECRET")
      expect(bot.consumer_key).to    eq("CONSUMER API KEY")
      expect(bot.consumer_secret).to eq("CONSUMER API SECRET")
    end

    it "should set the logger level" do
      expect(bot.logger.level).to eq(Logger::DEBUG)
    end
  end

  context "when logging in" do
    it "should succeed with good credentials" do
      real_bot.login!
      expect(real_bot.twitter.user).to_not be_nil
    end

    it "should fail with bad credentials" do
      bot.login!
      expect { bot.twitter.user }.to raise_error(Twitter::Error::Unauthorized)
    end
  end
end
