# frozen_string_literal: true

require './lib/chess/game_piece'
require './lib/chess/game'

describe Game do
  subject(:game_move) { described_class.new }
  let(:game_piece) { instance_double(GamePiece, color: :white) }
  let(:opp_piece) { instance_double(GamePiece, color: :black) }

  # A method that can select a GamePiece at a specific position
  describe 'select_piece' do
    valid_pos = 'B8'
    invalid_pos = 'D3'
    opp_pos = 'B1'

    context 'when a valid position is entered' do
      before do
        allow(game_move).to receive(:gets).and_return(valid_pos)
        allow(game_move).to receive(:valid_pos?).with(valid_pos).and_return(true)
        allow(game_move).to receive(:find_piece).with(valid_pos, game_move.board).and_return(game_piece)
      end
      it 'changes :selected_piece to the GamePiece at that board position' do
        expect { game_move.select_piece }.to change { game_move.selected_piece }.from(nil).to(game_piece)
      end
    end

    context 'when an invalid position is entered twice' do
      before do
        allow(game_move).to receive(:gets).and_return(invalid_pos, invalid_pos, valid_pos)
        allow(game_move).to receive(:valid_pos?).with(valid_pos).and_return(true)
        allow(game_move).to receive(:find_piece).with(valid_pos, game_move.board).and_return(game_piece)
      end

      it 'calls valid_board_pos? 3 times' do
        expect(game_move).to receive(:valid_pos?).exactly(3).times
        game_move.select_piece
      end
    end

    context 'when an opponents piece is selected' do
      before do
        allow(game_move).to receive(:gets).and_return(opp_pos, opp_pos, valid_pos)
        allow(game_move).to receive(:valid_pos?).and_return(true, true, true)
        allow(game_move).to receive(:color_match?).and_return(false, false, true)
      end

      it 'calls valid_pos? 3 times' do
        expect(game_move).to receive(:valid_pos?).exactly(3).times
        game_move.select_piece
      end
    end
  end
end

describe GamePiece do
  subject(:game_piece) { described_class.new('A1') }

  describe '#move' do
    valid_pos = 'D5'
    invalid_pos = 'A9'

    context 'when a valid position is entered' do
      before do
        allow(game_piece).to receive(:gets).and_return(valid_pos)
      end

      it 'position changes to the entered position' do
        og_pos = game_piece.position
        expect { game_piece.move }.to change { game_piece.position }.from(og_pos).to(valid_pos)
      end
    end

    context 'when an invalid position is entered twice' do
      before do
        allow(game_piece).to receive(:puts)
        allow(game_piece).to receive(:gets).and_return(invalid_pos, invalid_pos, valid_pos)
      end

      it 'puts an error message twice' do
        expect(game_piece).to receive(:puts).with('Invalid move.').twice
        game_piece.move
      end
    end
  end
end

describe Pawn do
  subject(:pawn_move) { described_class.new('B1') }

  valid_pos = 'B2'
  valid_first_move = 'B3'
  invalid_pos = 'C1'

  describe '#move' do
    context 'when a valid position is entered and first_move is true' do
      before do
        allow(pawn_move).to receive(:gets).and_return(valid_pos)
        allow(pawn_move).to receive(:valid_pos?).with(valid_pos).and_return(true)
      end

      it 'changes first_move to false' do
        expect { pawn_move.move }.to change { pawn_move.first_move }.from(true).to(false)
      end
    end
  end

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
