require "./connect_four.rb"

describe TokenNodes do
  let(:token) { TokenNodes.new("2, 4") }

  describe "#self_connections" do
    it "returns a hash with all values as nils" do
      token.self_connections.each_value do |link|
        expect(link).to be_nil
      end
    end
  end

  describe "#connect_checker" do
    before do
      @old_token = double("Token")
      allow(@old_token).to receive(:data) { @coord }
    end
    
    context "when given a token it can connect to" do
      it "returns the @down connection" do
        @coord = "1, 4"
        token.connect_checker(@old_token)

        expect(token.down).to eql(@old_token)
      end

      it "returns the @left connection" do
        @coord = "2, 3"
        token.connect_checker(@old_token)

        expect(token.left).to eql(@old_token)
      end

      it "returns the @right connection" do
        @coord = "2, 5"
        token.connect_checker(@old_token)

        expect(token.right).to eql(@old_token)
      end

      it "returns the @l_down connection" do
        @coord = "1, 3"
        token.connect_checker(@old_token)

        expect(token.l_down).to eql(@old_token)
      end

      it "returns the @r_down connection" do
        @coord = "1, 5"
        token.connect_checker(@old_token)

        expect(token.r_down).to eql(@old_token)
      end
    end

    context "when given a token it cannot connect to" do
      it "returns without attaching to a connection" do 
        @coord = "3, 6"
        token.connect_checker(@old_token)

        token.self_connections.each_value do |link|
          expect(link).to be_nil
        end
      end
    end
  end
end


describe Cage do
  let(:cage) { Cage.new }

  describe "display_cage" do
    it "shows the connect four game cage" do
      @displayed = "\n 1  2  3  4  5  6  7\n[ ][ ][ ][ ][ ][ ][ ]\n[ ][ ][ ][ ][ ][ ][ ]\n[ ][ ][ ][ ][ ][ ][ ]\n[ ][ ][ ][ ][ ][ ][ ]\n[ ][ ][ ][ ][ ][ ][ ]\n[ ][ ][ ][ ][ ][ ][ ]\n"
      expect(cage.display_cage).to eql(@displayed)
    end
  end

  describe "#players_move" do
    before do
      @player_1 = double("player")
      allow(@player_1).to receive(:icon) { "0" }
      @move = 7
    end

    context "when cage is empty" do 
      it "returns location of player icon" do
        expect(cage.players_move(@player_1, @move)).to eql("1, 7")
      end
    end

    context "when cage column is full" do
      it "returns false" do
        1.upto(6) do
          cage.players_move(@player_1, @move)
        end

        expect(cage.players_move(@player_1, @move)).to eq(false)
      end
    end   
  end
end


describe Player do
  let(:player) { Player.new(0) }

  describe "#player_move" do
    before { allow($stdout).to receive(:write) }

    context "when passed correct input" do
      it "should return the input" do
        allow($stdin).to receive(:gets).and_return ("7")
        expect(player.player_move).to eql(7)
      end
    end

    context "when given wrong input" do
      it "should reject a number not 1-7" do
        allow($stdin).to receive(:gets).and_return("9")
        expect(player.player_move).to eq(false)
      end

      it "should reject anything not a number" do
        allow($stdin).to receive(:gets).and_return("true")
        expect(player.player_move).to eq(false)
      end
    end
  end


  describe "#get_icon_location" do
    before do
      @cage = double ("Cage")
      @choice = 4
    end

    context "when given a valid move" do
      it "should return true" do
        allow(@cage).to receive(:players_move).and_return("2, 4")
        expect(player.get_icon_location(@cage, @choice)).to eq(true)
      end
    end

    context "when given an invalid move" do
      it "should return false" do
        allow(@cage).to receive(:players_move).and_return(false)
        expect(player.get_icon_location(@cage, @choice)).to eq(false)
      end
    end
  end
end

describe Game do
  let(:game) { Game.new }
  
  describe "#winner_check" do
    context "neither player is the winner" do
      it { expect(game.winner_check).to eql(false) }
    end

    context "player 1 is the winner" do
      it "returns player mark" do
        allow(game.player1).to receive(:winner).and_return(true)
        expect(game.winner_check).to eql(true)
      end
    end
  end
 
end