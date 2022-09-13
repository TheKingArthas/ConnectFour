import UIKit

class GameViewController: UIViewController {

	var game = Game(numberOfColumns: 7, numberOfRows: 6)
	@IBOutlet weak var boardChipsStackView: UIStackView!
	@IBOutlet weak var boardColumnsButtonsStackView: UIStackView!
	@IBOutlet weak var currentPlayerLabel: UILabel!
	@IBOutlet weak var playerOneScoreLabel: UILabel!
	@IBOutlet weak var playerTurnBackground: UIView!
	@IBOutlet weak var playerTwoScoreLabel: UILabel!
	@IBOutlet weak var restartGameButton: UIButton!
	@IBOutlet weak var restartMatchButton: UIButton!
	@IBOutlet weak var sceneBackgroundImageView: UIImageView!
	@IBOutlet weak var sceneTableImageView: UIImageView!
	@IBOutlet weak var sceneBoardShadowImageView: UIImageView!
	@IBOutlet weak var turnLabel: UILabel!
	@IBOutlet weak var tutorialClueLabel: UILabel!
	@IBOutlet weak var tutorialHandTappingImageView: UIImageView!
	@IBOutlet weak var tutorialShadowView: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupScene()
		setupFonts()
		setupBoard()
		setupButtons()
		updateScore()
		updatePlayerTurn()
		setupTutorial()
	}

	@IBAction func tutorialAllScreenButtonPressed(_ sender: Any) {
		tutorialShadowView.isHidden = true
	}

	@IBAction func columnButtonPressed(sender: UIButton) {
		addChipAtColumn(columnNumber: sender.tag)
	}

	@IBAction func restartMatchButtonPressed(_ sender: UIButton) {
		let confirmationAlert = UIAlertController(title: NSLocalizedString("restart_match", comment: "Restart match."),
												  message: NSLocalizedString("restart_match_confirmation_message",
																			 comment: "Confirmation message."),
												  preferredStyle: .alert)
		let restarMatch = UIAlertAction(title: NSLocalizedString("confirm", comment: "Confirm."),
										style: .destructive) {_ in
			self.restartMatch()
		}
		let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel."), style: .default) {_ in
		}
		confirmationAlert.addAction(restarMatch)
		confirmationAlert.addAction(cancel)
		present(confirmationAlert, animated: true)
	}

	@IBAction func restartGameButtonPressed(_ sender: UIButton) {
		let confirmationAlert = UIAlertController(title: NSLocalizedString("restart_game", comment: "Restart game."),
												  message: NSLocalizedString("restart_game_confirmation_message",
																			 comment: "Confirmation message."),
												  preferredStyle: .alert)
		let restarMatch = UIAlertAction(title: NSLocalizedString("confirm", comment: "Confirm."),
										style: .destructive) {_ in
			self.resetScore()
			self.restartMatch()
		}
		let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: "Cancel."), style: .default) {_ in
		}
		confirmationAlert.addAction(restarMatch)
		confirmationAlert.addAction(cancel)
		present(confirmationAlert, animated: true)
	}

	private func setupFonts() {
		currentPlayerLabel.font = .bubblegumSansRegular(size: 48)
		turnLabel.font = .bubblegumSansRegular(size: 32)
		for label in [playerOneScoreLabel, playerTwoScoreLabel, restartMatchButton.titleLabel,
					  restartGameButton.titleLabel] {
			label!.font = .bubblegumSansRegular(size: 26)
		}
		for scoreLabel in [playerOneScoreLabel, playerTwoScoreLabel] {
			scoreLabel?.textColor = .scoresColor
		}
	}

	private func setupBoard() {
		for column in 1...game.numberOfColumns {
			boardChipsStackView.addArrangedSubview(ChipColumnView(rows: game.numberOfRows))
			let button = UIButton()
			button.tag = column
			button.addTarget(self, action: #selector(columnButtonPressed(sender:)), for: .touchUpInside)
			boardColumnsButtonsStackView.addArrangedSubview(button)
		}
		boardChipsStackView.distribution = .fillEqually
		boardChipsStackView.layer.cornerRadius = 20
		boardChipsStackView.backgroundColor = UIColor(patternImage: UIImage(named: "BoardBackground")!)
		boardChipsStackView.tintColor = .clear
		boardColumnsButtonsStackView.distribution = .fillEqually
	}

	private func setupTutorial() {
		tutorialShadowView.backgroundColor = .white.withAlphaComponent(0.75)
		tutorialHandTappingImageView.image = UIImage(named: "HandTapping")?.withTintColor(.tutorial)
		tutorialClueLabel.font = .bubblegumSansRegular(size: 32)
		tutorialClueLabel.textColor = .tutorial
		tutorialClueLabel.numberOfLines = 2
		tutorialClueLabel.textAlignment = .center
		tutorialClueLabel.text = NSLocalizedString("tutorial_clue", comment: "Tutorial clue.")
	}

	private func addChipAtColumn(columnNumber: Int) {
		if game.addChipAtColumn(columnNumber) {
			updateColumn(columnNumber: columnNumber)
			updatePlayerTurn()
			if game.matchStatus == .notStarted {
				restartMatch()
				presentMatchOverAlert()
			}
		} else {
			let alert = UIAlertController(title: NSLocalizedString("invalid_move", comment: "Invalid move."),
										  message: NSLocalizedString("try_again", comment: "Try again."),
										  preferredStyle: .alert)
			let confirm = UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default)
			alert.addAction(confirm)
			present(alert, animated: true)
		}
	}

	private func setupScene() {
		sceneBackgroundImageView.image = UIImage(named: "SceneBackground")
		sceneTableImageView.image = UIImage(named: "SceneTable")
		sceneBoardShadowImageView.image = UIImage(named: "SceneBoardShadow")
		playerTurnBackground.layer.cornerRadius = 25
	}

	private func setupButtons() {
		for button in [restartGameButton, restartMatchButton] {
			button?.tintColor = .white
			button?.layer.borderWidth = 5
			button?.layer.borderColor = UIColor.white.cgColor
			button?.layer.cornerRadius = 25
		}
		restartGameButton.backgroundColor = .restartGameButton
		restartMatchButton.backgroundColor = .restartMatchButton
	}

	private func updateColumn(columnNumber: Int) {
		(boardChipsStackView.arrangedSubviews[columnNumber - 1] as? ChipColumnView)!
			.refreshWithColumn(column: game.columnByNumber(columnNumber))
	}

	private func updatePlayerTurn() {
		currentPlayerLabel.text = String(format: NSLocalizedString("player_plus_name", comment: "Player with name."),
										 (UIConstants.playerName(game.currentTurn)))
		playerTurnBackground.backgroundColor = UIColor.fromPlayer(game.currentTurn)
		currentPlayerLabel.textColor = .white
		turnLabel.textColor = .white
	}

	private func updateScore() {
		playerOneScoreLabel.text = String(format: NSLocalizedString("score", comment: "Score."),
										  UIConstants.playerName(.playerOne), game.score(.playerOne))
		playerTwoScoreLabel.text = String(format: NSLocalizedString("score", comment: "Score."),
										  UIConstants.playerName(.playerTwo), game.score(.playerTwo))
	}

	private func resetScore() {
		game.resetScore()
		updateScore()
	}

	private func restartMatch() {
		game.resetBoard()
		for column in 1...game.numberOfColumns {
			updateColumn(columnNumber: column)
		}
		updateScore()
		updatePlayerTurn()
	}

	private func presentMatchOverAlert() {
		var message: String
		switch game.lastWinner {
		case .playerOne, .playerTwo:
			message = String(format: NSLocalizedString("player_won", comment: "Player who won."),
							 UIConstants.playerName(game.lastWinner))
		case .noPlayer:
			message = NSLocalizedString("draw", comment: "Draw.")
		}
		let notification = UIAlertController(title: NSLocalizedString("match_over", comment: "Match over."),
											 message: message,
											 preferredStyle: .alert)
		notification.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "Ok"), style: .default))
		present(notification, animated: true)
	}
}
