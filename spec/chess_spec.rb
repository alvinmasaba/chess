# frozen_string_literal: true

require './lib/chess/game_piece'
require './lib/chess/game'
require './lib/chess/player'

describe Game do
  describe '#check' do
    context 'when opponent\'s King is in check' do
      subject(:opp_in_check) { described_class.new }

      it 'returns true' do
        # It is player1's turn by default, so place one of their [white]
        # pieces adjacent to player2's [black] king. In this case, because
        # the king is at E1, we place a white queen directly in front of it
        # at E2.

        opp_in_check.turn.pieces.each do |piece|
          piece.position = 'E2' if piece.is_a?(Queen)
        end

        expect(opp_in_check.check).to be_truthy
      end

      it 'changes opponent\'s in_check to true' do
        opp_in_check.board.board[1] = Array.new(8, "\u0020")

        opp_in_check.turn.pieces.each do |piece|
          piece.position = 'B4' if piece.is_a?(Queen)
        end

        opp_in_check.check

        expect(opp_in_check.player2.in_check).to be_truthy
      end
    end

    context 'when opponent\'s King is not in check' do
      subject(:not_in_check) { described_class.new }

      it 'returns false' do
        # Should return false at start of game
        expect(not_in_check.check).to be false
      end

      it 'does not change opponent\'s in_check to true' do
        not_in_check.check

        expect(not_in_check.player2.in_check).to_not be_truthy
      end
    end
  end
end

describe Player do
  subject(:player_move) { described_class.new('Player 1', :white) }
  let(:game_board) { instance_double(GameBoard) }
  let(:player_piece) { instance_double(GamePiece, color: :white) }
  let(:opp_piece) { instance_double(GamePiece, color: :black) }
end

describe Pawn do
  subject(:pawn_move) { described_class.new('B1') }

  valid_pos = 'B2'
  valid_first_move = 'B3'
  invalid_pos = 'C1'

  describe '#valid_pos?' do
    context 'when a valid position is entered' do
      it 'returns true' do
        expect(pawn_move.valid_pos?(valid_pos)).to be_truthy
      end
    end

    context 'when first_move is true and the move is two spaces away vertically' do
      it 'returns true' do
        pawn_move.first_move = true
        expect(pawn_move.valid_pos?(valid_first_move)).to be_truthy
      end
    end

    context 'when first_move is false and the move is two spaces away vertically' do
      it 'returns false' do
        pawn_move.first_move = false
        expect(pawn_move.valid_pos?(valid_first_move)).to_not be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(pawn_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(pawn_move.valid_pos?(pawn_move.position)).to_not be_truthy
      end
    end
  end
end

describe Rook do
  subject(:rook_move) { described_class.new('D5') }

  describe '#valid_pos?' do
    valid_pos = 'D8'
    invalid_pos = 'A2'

    context 'when a valid position is entered' do
      it 'returns true' do
        expect(rook_move.valid_pos?(valid_pos)).to be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(rook_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(rook_move.valid_pos?(rook_move.position)).to_not be_truthy
      end
    end
  end
end

describe Bishop do
  subject(:bishop_move) { described_class.new('G4') }

  describe '#valid_pos?' do
    valid_pos = 'D7'
    invalid_pos = 'B7'

    context 'when a valid position is entered' do
      it 'returns true' do
        expect(bishop_move.valid_pos?(valid_pos)).to be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(bishop_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(bishop_move.valid_pos?(bishop_move.position)).to_not be_truthy
      end
    end
  end
end

describe Knight do
  subject(:knight_move) { described_class.new('E5') }

  describe '#valid_pos?' do
    valid_pos = 'C6'
    invalid_pos = 'A1'

    context 'when a valid position is entered' do
      it 'returns true' do
        expect(knight_move.valid_pos?(valid_pos)).to be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(knight_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(knight_move.valid_pos?(knight_move.position)).to_not be_truthy
      end
    end
  end
end

describe Queen do
  subject(:queen_move) { described_class.new('C1') }

  describe '#valid_pos?' do
    valid_horizontal = 'H1'
    valid_diagonal = 'F4'
    valid_vertical = 'C7'
    invalid_pos = 'H2'

    context 'when a valid horizontal position is entered' do
      it 'returns true' do
        expect(queen_move.valid_pos?(valid_horizontal)).to be_truthy
      end
    end

    context 'when a valid vertical position is entered' do
      it 'returns true' do
        expect(queen_move.valid_pos?(valid_vertical)).to be_truthy
      end
    end

    context 'when a valid diagonal position is entered' do
      it 'returns true' do
        expect(queen_move.valid_pos?(valid_diagonal)).to be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(queen_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(queen_move.valid_pos?(queen_move.position)).to_not be_truthy
      end
    end
  end
end

describe King do
  subject(:king_move) { described_class.new('G7') }

  describe '#valid_pos?' do
    valid_horizontal = 'F7'
    valid_diagonal = 'H6'
    valid_vertical = 'G8'
    invalid_pos = 'E7'

    context 'when a valid horizontal position is entered' do
      it 'returns true' do
        expect(king_move.valid_pos?(valid_horizontal)).to be_truthy
      end
    end

    context 'when a valid vertical position is entered' do
      it 'returns true' do
        expect(king_move.valid_pos?(valid_vertical)).to be_truthy
      end
    end

    context 'when a valid diagonal position is entered' do
      it 'returns true' do
        expect(king_move.valid_pos?(valid_diagonal)).to be_truthy
      end
    end

    context 'when an invalid position is entered' do
      it 'returns false' do
        expect(king_move.valid_pos?(invalid_pos)).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(king_move.valid_pos?(king_move.position)).to_not be_truthy
      end
    end
  end
end
