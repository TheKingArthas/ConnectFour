// MARK: - Enums

enum MatchStatus {
	case notStarted, started
}

public class Game {

	// MARK: - Public properties

	public var lastWinner: Player
	public var numberOfColumns: Int {
		get {
			return board.numberOfColumns
		}
	}
	public var numberOfRows: Int {
		get {
			return board.numberOfRows
		}
	}
	private (set) var matchStatus: MatchStatus
	private (set) var currentTurn: Player
	private (set) var matchsWon: [Player: Int]

	// MARK: - Private properties

	private var board: Board

	// MARK: - Initialization

	init(numberOfColumns: Int, numberOfRows: Int) {
		board = Board(numberOfColumns: numberOfColumns, numberOfRows: numberOfRows)
		lastWinner = .noPlayer
		matchStatus = .notStarted
		matchsWon = [.playerOne: 0, .playerTwo: 0]
		currentTurn = .playerOne
	}

	// MARK: - Public methods

	public func addChipAtColumn(_ column: Int) -> Bool {
		if matchStatus == .notStarted {
			matchStatus = .started
		}
		if board.add(chipOwner: currentTurn, atColumn: column) {
			if board.lastChipAddedAt != nil && board.areFourChipsConnectedAt(column: board.lastChipAddedAt!.column,
																			 row: board.lastChipAddedAt!.row) {
				endMatch(winner: currentTurn)
			} else if board.remainingMoves == 0 {
				endMatch(winner: .noPlayer)
			} else {
				swapTurn()
			}
			return true
		}
		return false
	}

	public func playerAt(column: Int, row: Int) -> Player {
		return board.playerAt(column: column, row: row)
	}

	public func resetBoard() {
		matchStatus = .notStarted
		currentTurn = .playerOne
		board.reset()
	}

	public func resetScore() {
		matchsWon[.playerOne] = 0
		matchsWon[.playerTwo] = 0
	}

	public func score(_ player: Player) -> Int {
		return matchsWon[player]!
	}

	public func columnByNumber(_ columnNumber: Int) -> [Player] {
		return board.columnByNumber(columnNumber)
	}

	// MARK: - Private methods

	private func swapTurn() {
		if currentTurn == .playerOne {
			currentTurn = .playerTwo
		} else {
			currentTurn = .playerOne
		}
	}

	private func endMatch(winner: Player) {
		if winner != .noPlayer {
			matchsWon[winner]! += 1
		}
		lastWinner = winner
		resetBoard()
	}
}
