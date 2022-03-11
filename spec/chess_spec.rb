# frozen_string_literal: true

require './lib/chess/game_piece'

describe GamePiece do
  subject(:game_piece) { described_class.new('A1') }

  describe '#move' do
    valid_pos = 'D5'
    invalid_pos = 'A9'

    context 'when a valid position is entered' do
      it 'position changes to the entered position' do
        og_pos = game_piece.position
        expect { game_piece.move(valid_pos) }.to change { game_piece.position }.from(og_pos).to(valid_pos)
      end
    end

    context 'when an invalid position is entered' do
      it 'does not change its position' do
        og_pos = game_piece.position
        game_piece.move(invalid_pos)
        expect(game_piece.position).to eql(og_pos)
      end
    end

    context 'when an invalid position is entered' do
      it 'puts an error message' do
        expect(game_piece).to receive(:puts).with('Invalid move.')
        game_piece.move(invalid_pos)
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

