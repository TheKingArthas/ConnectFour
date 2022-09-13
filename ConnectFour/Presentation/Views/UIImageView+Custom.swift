import UIKit

extension UIImageView {
	func setPlayerChipImage(_ player: Player) {
		switch player {
		case .playerOne:
			self.image = UIConstants.playerChipImage(.playerOne)
		case .playerTwo:
			self.image = UIConstants.playerChipImage(.playerTwo)
		case .noPlayer:
			self.image = UIConstants.playerChipImage(.noPlayer)
		}
	}
}
