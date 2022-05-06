# frozen_string_literal: true

# mixin
module PieceMovement
  def step(c, delta = 1)
    [c.ord + delta].pack 'U'
  end

  def increment(c)
    step c, 1
  end

  def decrement(c)
    step c, -1
  end

  def find_path(curr_pos, dest)
    curr_pos = curr_pos.downcase
    dest = dest.downcase

    # Finds the path to destination based on if it is located
    # diagonally, vertically or horizontally from the current position.
    if dest[0] != curr_pos[0] && dest[1] != curr_pos[1]
      find_diagonal_path(curr_pos, dest)
    elsif dest[0] == curr_pos[0]
      find_vert_path(curr_pos, dest)
    else
      find_horiz_path(curr_pos, dest)
    end
  end

  def get_path(curr, dest, col_step, row_step, path = [])
    # Appends 'col-row' to path array until destination value is reached.
    # Returns path array.
    until curr == dest
      col = choose_step(col_step, curr[0])
      row = choose_step(row_step, curr[1])

      curr = "#{col}#{row}"

      path << curr unless curr == dest
    end

    path
  end

  def choose_step(string, val)
    # Increments, decrements or simply returns value based on input string.
    if string == 'increment'
      increment(val)
    elsif string == ''
      val
    else
      decrement(val)
    end
  end

  def find_diagonal_path(curr, dest)
    # Returns the descending or ascending diagonal path.
    return desc_diag(curr, dest) if dest[1] > curr[1]

    asc_diag(curr, dest)
  end

  def desc_diag(curr, dest)
    return get_path(curr, dest, 'increment', 'increment') if dest[0] > curr[0]

    # Decrements letter and increments num coordinate to simulate
    # downward diagonal movement to the left.
    get_path(curr, dest, 'decrement', 'increment')
  end

  def asc_diag(curr, dest)
    # Increments letter and decrements num coordinate to simulate
    # upward diagonal movement to the right.
    return get_path(curr, dest, 'increment', 'decrement') if dest[0] > curr[0]

    # Decrements both letter and num coordinate to simulate
    # upward diagonal movement to the left.
    get_path(curr, dest, 'decrement', 'decrement')
  end

  def find_vert_path(curr, dest)
    # Returns the descending or ascending vertical path.
    return desc_vert(curr, dest) if dest[1] > curr[1]

    asc_vert(curr, dest)
  end

  def desc_vert(curr, dest)
    # Increments num coordinate to simulate downward vertical movement.
    get_path(curr, dest, '', 'increment')
  end

  def asc_vert(curr, dest)
    get_path(curr, dest, '', 'decrement')
  end

  def find_horiz_path(curr, dest)
    # Returns the left or right horizontal path.
    return right_horiz(curr, dest) if dest[0] > curr[0]

    left_horiz(curr, dest)
  end

  def left_horiz(curr, dest)
    get_path(curr, dest, 'decrement', '')
  end

  def right_horiz(curr, dest)
    get_path(curr, dest, 'increment', '')
  end
end