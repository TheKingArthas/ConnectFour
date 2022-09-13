import XCTest
@testable import ConnectFour

class GameTests: XCTestCase {

	var game: Game!

	override func setUp() {
		game = Game(numberOfColumns: 7, numberOfRows: 6)
	}

	func testInitialTurn() throws {
		XCTAssertEqual(game.currentTurn, .playerOne)
	}

	func testSwapedTurn() throws {
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(game.currentTurn, .playerTwo)
	}

	func testAddChipSucceed() throws {
		XCTAssertTrue(game.addChipAtColumn(1))
	}

	func testAddChipFailed() throws {
		for _ in 1...6 {
		  _ = game.addChipAtColumn(1)
	  }
	  XCTAssertFalse(game.addChipAtColumn(1))
	}

	func testPlayerOneWon() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func testPlayerTwoWon() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		addChipsAtColumns([3, 2])
		XCTAssertEqual(game.lastWinner, .playerTwo)
	}

	func testPlayerOneWinCounter() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(1, game.matchsWon[.playerOne])
	}

	func testDraw() throws {
		for column in 1...3 {
			for _ in 1...6 {
				_ = game.addChipAtColumn(column)
			}
		}
		_ = game.addChipAtColumn(7)
		for _ in 1...6 {
			_ = game.addChipAtColumn(4)
		}
		_ = game.addChipAtColumn(7)
		for column in 5...6 {
			for _ in 1...6 {
				_ = game.addChipAtColumn(column)
			}
		}
		for _ in 1...4 {
			_ = game.addChipAtColumn(7)
		}
		XCTAssertEqual(.noPlayer, game.lastWinner)
	}

	func testPlayerTwoWinCounter() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		addChipsAtColumns([3, 2])
		XCTAssertEqual(1, game.matchsWon[.playerTwo])
	}

	func test4ChipsHorizontallyTogether() throws {
		var position = 1
		for _ in 1...3 {
			addChipsAtColumns([position, 5])
			position += 1
		}
		_ = game.addChipAtColumn(4)
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func test4ChipsVerticallyTogether() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		addChipsAtColumns([3, 2])
		XCTAssertEqual(game.lastWinner, .playerTwo)
	}

	func test4ChipsVerticallyTogetherAlternative() throws {
		addChipsAtColumns([2, 1])
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func test4ChipsDiagonallyTogether() throws {
		addChipsAtColumns([1, 2, 2, 6, 3, 3, 3, 4, 4, 4, 4])
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func test4ChipsDiagonallyTogetherAlternative() throws {
		addChipsAtColumns([1, 2, 2, 6, 3, 3, 3, 4, 4, 4, 4])
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func test4ChipsDiagonallyTogetherOtherPosition() throws {
		addChipsAtColumns([2, 3, 3, 3, 4, 4, 4, 4, 5, 2, 5, 1])
		XCTAssertEqual(game.lastWinner, .playerTwo)
	}

	func test4ChipsReverseDiagonallyTogether() throws {
		addChipsAtColumns([4, 4, 4, 4, 3, 3, 3, 6, 2, 2, 1])
		XCTAssertEqual(game.lastWinner, .playerOne)
	}

	func testMatchIsntStarted() throws {
		XCTAssertEqual(.notStarted, game.matchStatus)
	}

	func testMatchIstStarted() throws {
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(.started, game.matchStatus)
	}

	func testMatchIsntStartedAfterRestart() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(.notStarted, game.matchStatus)
	}

	func testPlayerAt() throws {
		_ = game.addChipAtColumn(1)
		XCTAssertEqual(.playerOne, game.playerAt(column: 1, row: 1))
	}

	func testColumn() throws {
		for _ in 1...6 {
			_ = game.addChipAtColumn(1)
		}
		XCTAssertEqual([.noPlayer, .playerOne, .playerTwo, .playerOne, .playerTwo, .playerOne, .playerTwo],
					   game.columnByNumber(1))
	}

	func testResetScore() throws {
		for _ in 1...3 {
			addChipsAtColumns([1, 2])
		}
		_ = game.addChipAtColumn(1)
		game.resetScore()
		XCTAssertEqual([0, 0], [game.score(.playerOne), game.score(.playerTwo)])
	}

	private func addChipsAtColumns(_ columnsNumbers: [Int]) {
		for column in columnsNumbers {
			_ = game.addChipAtColumn(column)
		}
	}
}
