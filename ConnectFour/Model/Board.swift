struct Position {
	var column: Int
	var row: Int
}

public class Board {

    // MARK: - Public properties

	var remainingMoves: Int {
		get {
			 return numberOfColumns * numberOfRows - movesCounter
		}
	}
	private (set) var lastChipAddedAt: Position?
	private (set) var numberOfColumns: Int
	private (set) var numberOfRows: Int

    // MARK: - Private properties

	private var structure: [[Player]]
	private var movesCounter: Int

    // MARK: - Initialization

	public init(numberOfColumns: Int, numberOfRows: Int) {
		structure = [[Player]]()
		self.numberOfColumns = numberOfColumns
		self.numberOfRows = numberOfRows
		for _ in 0...numberOfColumns {
			var row = [Player]()
			for _ in 0...numberOfRows {
				row.append(.noPlayer)
			}
			structure.append(row)
		}
		lastChipAddedAt = nil
		movesCounter = 0
    }

    // MARK: - Public methods

    public func add(chipOwner: Player, atColumn: Int) -> Bool {
		if chipOwner != .noPlayer {
			if isValidMove(column: atColumn) {
				if playerAt(column: atColumn, row: numberOfRows) == .noPlayer {
					var row = numberOfRows
					while row > 1 && playerAt(column: atColumn, row: row - 1) == .noPlayer {
						row -= 1
					}
					structure[atColumn][row] = chipOwner
					movesCounter += 1
					lastChipAddedAt = Position(column: atColumn, row: row)
					return true
				}
			}
        }
		return false
    }

	public func playerAt(column: Int, row: Int) -> Player {
		return structure[column][row]
	}

	public func areFourChipsConnectedAt(column: Int, row: Int) -> Bool {
		return max(countEqualConsecutiveChipsHorizontallyOn(column: column, row: row),
				   countEqualConsecutiveChipsVerticallyOn(column: column, row: row),
				   countEqualConsecutiveChipsDiagonallyOn(column: column, row: row),
				   countEqualConsecutiveChipsReverseDiagonallyOn(column: column, row: row)
		) >= 4
	}

	public func reset() {
		movesCounter = 0
		clean()
	}

	public func columnByNumber(_ columnNumber: Int) -> [Player] {
		return structure[columnNumber]
	}

    // MARK: - Private methods

    private func clean() {
        for column in 1...numberOfColumns {
			for row in 1...numberOfRows {
				structure[column][row] = .noPlayer
			}
        }
		lastChipAddedAt = nil
    }

	private func isValidMove(column: Int) -> Bool {
		return (1...numberOfColumns).contains(column) && structure[column][numberOfRows] == .noPlayer
	}

	private func isValidPosition(column: Int, row: Int) -> Bool {
		return (1...numberOfColumns).contains(column) && (1...numberOfRows).contains(row)
	}

	private func countEqualConsecutiveChipsHorizontallyOn(column: Int, row: Int) -> Int {
		let player = playerAt(column: column, row: row)
		var counter = 1
		var reviewPositionColumn = column
		var reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn + 1, row: row)
				&& playerAt(column: reviewPositionColumn + 1, row: reviewPositionRow) == player {
			reviewPositionColumn += 1
			counter += 1
		}
		reviewPositionColumn = column
		reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn - 1, row: row)
				&& playerAt(column: reviewPositionColumn - 1, row: reviewPositionRow) == player {
			reviewPositionColumn -= 1
			counter += 1
		}
		return counter
	}

	private func countEqualConsecutiveChipsVerticallyOn(column: Int, row: Int) -> Int {
		let player = playerAt(column: column, row: row)
		var counter = 1
		let reviewPositionColumn = column
		var reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn, row: reviewPositionRow - 1)
				&& playerAt(column: reviewPositionColumn, row: reviewPositionRow - 1) == player {
			reviewPositionRow -= 1
			counter += 1
		}
		return counter
	}

	private func countEqualConsecutiveChipsDiagonallyOn(column: Int, row: Int) -> Int {
		let player = playerAt(column: column, row: row)
		var counter = 1
		var reviewPositionColumn = column
		var reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn - 1, row: reviewPositionRow - 1)
				&& playerAt(column: reviewPositionColumn - 1, row: reviewPositionRow - 1) == player {
			reviewPositionColumn -= 1
			reviewPositionRow -= 1
			counter += 1
		}
		reviewPositionColumn = column
		reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn + 1, row: reviewPositionRow + 1)
				&& playerAt(column: reviewPositionColumn + 1, row: reviewPositionRow + 1) == player {
			reviewPositionColumn += 1
			reviewPositionRow += 1
			counter += 1
		}
		return counter
	}

	private func countEqualConsecutiveChipsReverseDiagonallyOn(column: Int, row: Int) -> Int {
		let player = playerAt(column: column, row: row)
		var counter = 1
		var reviewPositionColumn = column
		var reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn + 1, row: reviewPositionRow - 1)
				&& playerAt(column: reviewPositionColumn + 1, row: reviewPositionRow - 1) == player {
			reviewPositionColumn += 1
			reviewPositionRow -= 1
			counter += 1
		}
		reviewPositionColumn = column
		reviewPositionRow = row
		while isValidPosition(column: reviewPositionColumn - 1, row: reviewPositionRow + 1)
				&& playerAt(column: reviewPositionColumn - 1, row: reviewPositionRow + 1) == player {
			reviewPositionColumn -= 1
			reviewPositionRow += 1
			counter += 1
		}
		return counter
	}
}
