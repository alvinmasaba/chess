# frozen_string_literal: true

require './lib/chess/game_piece'
require './lib/chess/game'
require './lib/chess/player'

describe Game do
  describe '#check' do
    context 'when King is in check' do
      subject(:in_check) { described_class.new }

      it 'changes in_check to true' do
        # Places white Queen directly adjacent to black King at E8.
        in_check.player2.pieces.each do |piece|
          piece.position = 'E7' if piece.is_a?(Queen)
        end

        opp = in_check.player2
        in_check.check(opp)

        expect(in_check.turn.in_check).to be_truthy
      end
    end

    context 'when King is not in check' do
      subject(:not_in_check) { described_class.new }

      it 'expect in_check to be false' do
        # Places white Queen out of range of black King at E8.
        not_in_check.player2.pieces.each do |piece|
          piece.position = 'D4' if piece.is_a?(Queen)
        end

        expect(not_in_check.turn.in_check).to be false
      end
    end
  end

  describe '#checkmate' do
    context 'when King is in checkmate' do
      subject(:in_checkmate) { described_class.new }

      it 'the game is finished' do
        in_checkmate.turn.pieces.each do |piece|
          # Places white Queen at F2.
          piece.position = 'F2' if piece.is_a?(Queen)
          # Places white bishop at C5.
          piece.position = 'C5' if piece.position == 'F8'
        end

        in_checkmate.player2.pieces.each do |piece|
          # Moves pawn at E2.
          piece.position = 'E4' if piece.position == 'E2'
        end

        # Changes turn as checkmate runs after turn completion.
        in_checkmate.turn = in_checkmate.player2

        in_checkmate.checkmate(in_checkmate.player1)

        expect(in_checkmate.finished).to be_truthy
      end
    end

    context 'when King is not in checkmate' do
      subject(:no_checkmate) { described_class.new }

      it 'the game is not finished' do
        # Places pieces in a non-checkmate position.
        no_checkmate.turn.pieces.each do |piece|
          piece.position = 'F5' if piece.is_a?(Queen)
          piece.position = 'C5' if piece.position == 'F8'
        end

        no_checkmate.player2.pieces.each do |piece|
          piece.position = 'E4' if piece.position == 'E2'
        end

        no_checkmate.turn = no_checkmate.player2
        no_checkmate.checkmate(no_checkmate.player1)

        expect(no_checkmate.finished).to be(false)
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
  let(:game_board) { instance_double(GameBoard) }
  subject(:pawn_move) { described_class.new('B7') }

  valid_pos = 'B6'
  valid_first_move = 'B5'
  invalid_pos = 'C1'
  adj_pos = 'C6'

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

    context 'when a backward position is entered' do
      subject(:pawn_move) { described_class.new('B5') }

      it 'returns false' do
        expect(pawn_move.valid_pos?('B6')).to_not be_truthy
      end
    end

    context 'when its current position is entered' do
      it 'returns false' do
        expect(pawn_move.valid_pos?(pawn_move.position)).to_not be_truthy
      end
    end
  end

  describe '#adjacent_opp' do
    context 'when a diagonal position containing an opp piece is entered' do
      before do
        allow(pawn_move).to receive(:find_piece).and_return(GamePiece.new('C2', :black))
      end

      it 'returns true' do
        pawn_move.board = GameBoard.new
        expect(pawn_move.adjacent_opp(adj_pos)).to be_truthy
      end
    end

    context 'when a diagonal position containing own piece is entered' do
      before do
        allow(pawn_move).to receive(:find_piece).and_return(GamePiece.new('C2', :white))
      end

      it 'returns false' do
        pawn_move.board = GameBoard.new
        expect(pawn_move.adjacent_opp(adj_pos)).to_not be_truthy
      end
    end

    context 'when a diagonal position containing no piece is entered' do
      before do
        allow(pawn_move).to receive(:find_piece).and_return("\u0020")
      end

      it 'returns false' do
        pawn_move.board = GameBoard.new
        expect(pawn_move.adjacent_opp(adj_pos)).to_not be_truthy
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
