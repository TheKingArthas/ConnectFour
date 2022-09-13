import UIKit
class UIConstants {
	static func playerName(_ player: Player) -> String {
		switch player {
		case .playerOne:
			return NSLocalizedString("player_one_name", comment: "Player one name.")
		case .playerTwo:
			return NSLocalizedString("player_two_name", comment: "Player two name.")
		case .noPlayer:
			return NSLocalizedString("no_player_name", comment: "None player name.")
		}
	}

	static func playerChipImage(_ player: Player) -> UIImage {
		switch player {
		case .playerOne, .playerTwo:
			return UIImage(named: "Chip")!.withTintColor(UIColor.fromPlayer(player))
		case .noPlayer:
			return UIImage(named: "EmptySlot")!.withTintColor(.black.withAlphaComponent(0.5))
		}
	}
}
