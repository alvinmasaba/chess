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
  end
end
