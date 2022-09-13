import UIKit

extension UIColor {
	static let tutorial = UIColor(named: "TutorialTextAndImageColor") ?? gray
	static let noPlayer = UIColor(named: "NoPlayerColor") ?? .gray
	static let playerOne = UIColor(named: "PlayerOneColor") ?? .gray
	static let playerTwo = UIColor(named: "PlayerTwoColor") ?? .gray
	static let restartGameButton = UIColor(named: "RestartGameButtonColor") ?? .gray
	static let restartMatchButton = UIColor(named: "RestartMatchButtonColor") ?? .gray
	static let scoresColor = UIColor(named: "ScoresColor") ?? .gray

	static func fromPlayer(_ player: Player) -> UIColor {
		switch player {
		case .playerOne:
			return .playerOne
		case .playerTwo:
			return .playerTwo
		case .noPlayer:
			return .noPlayer
		}
	}
}
