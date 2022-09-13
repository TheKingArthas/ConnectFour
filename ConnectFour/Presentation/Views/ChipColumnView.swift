import UIKit

class ChipColumnView: UIStackView {
	convenience init(rows: Int) {
		self.init()
		self.axis = .vertical
		self.distribution = .fillEqually
		for _ in 1...rows {
			let chip = UIImageView()
			chip.setPlayerChipImage(.noPlayer)
			chip.contentMode = .scaleAspectFit
			self.addArrangedSubview(chip)
		}
	}

	func refreshWithColumn(column: [Player]) {
		var rowCounter: Int = column.count
		for row in self.arrangedSubviews {
			rowCounter -= 1
			(row as? UIImageView)?.setPlayerChipImage(column[rowCounter])
		}
	}
}
