# frozen_string_literal: true

require './lib/chess/game_piece'

describe GamePiece do
  subject(:game_piece) { described_class.new('white', 'player1', 'A1') }

  describe '#move' do
    valid_pos = 'D5'
    invalid_pos = 'A9'

    context 'when a valid position is entered' do
      it 'position changes to the entered position' do
        og_pos = game_piece.position
        expect { game_piece.move(valid_pos) }.to change { game_piece.position }.from(og_pos).to(valid_pos)
      end
    end
  end
end