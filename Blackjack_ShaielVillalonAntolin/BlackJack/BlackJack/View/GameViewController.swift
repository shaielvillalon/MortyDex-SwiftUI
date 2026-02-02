//
//  GameViewController.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 5/11/25.
//


import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var botStack: UIStackView!
    
    @IBOutlet weak var playerStack: UIStackView!
    
    
    @IBOutlet weak var botName: UILabel!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var requestCardButton: UIButton!
    
    @IBOutlet weak var standButton: UIButton!
    
    @IBOutlet weak var newgameButton: UIButton!
    
    
    var playerNameValue: String = "Jugador"
    
    private let viewModel = GameViewModel()
    
    
    override func viewDidLoad () {
        super.viewDidLoad()
        setupBindings()
        
        requestCardButton.isEnabled = false
        standButton.isEnabled = false
        newgameButton.isEnabled = true
        
        navigationItem.title = "Jugar"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupBindings() {
        viewModel.updateCard = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateCards(for: self.playerStack, with: self.viewModel.playerCardsPublic)
                self.updateCards(for: self.botStack, with: self.viewModel.botCardsPublic)
                self.updateScore()
            }
        }
        
        viewModel.updateStatus = { [weak self] message in
            DispatchQueue.main.async {
                self?.status.text = message
            }
        }
        
        viewModel.endedGame = { [weak self] res in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.requestCardButton.isEnabled = false
                self.standButton.isEnabled = false
                self.newgameButton.isEnabled = true
                
                self.showResModal(for: res)
            }
        }
    }
    
    private func showResModal(for res: GameResult) {
        let alert = UIAlertController(
            title: res.result,
            message: "Introduce tu nombre para guardar la partida",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Tu nombre"
            textField.text = GameSession.shared.playerName
        }
        
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            let nameInput = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalName = nameInput?.isEmpty == false ? nameInput! : "Jugador"
            
            let savedResult = GameResult(playerName: finalName, playerScore: res.playerScore, botScore: res.botScore, result: res.result, date: res.date)
            
            GameSession.shared.history.insert(savedResult, at: 0)
            GameSession.shared.playerName = finalName
            
        }
        
        alert.addAction(saveAction)
        present(alert, animated: true)
        
    }
    
    
    @IBAction func requestCardButtonAction(_ sender: UIButton) {
        
        viewModel.playerDrawCard {
            DispatchQueue.main.async {
                self.updateScore()
            }
        }
         
    }
    
    
    @IBAction func standButtonAction(_ sender: UIButton) {
        
        viewModel.botTurn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.viewModel.endGame()
            }
        }
        
    }
    
    
    
    @IBAction func newGameButtonAction(_ sender: UIButton) {
        
        requestCardButton.isEnabled = true
        standButton.isEnabled = true
        newgameButton.isEnabled = false
        
        viewModel.startgame()
        
    }
    
    
    private func updateCards (for stack: UIStackView, with cards: [Card]) {
        
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for card in cards {
            let img = UIImageView()
            img.contentMode = .scaleAspectFit
            img.widthAnchor.constraint(equalToConstant: 55).isActive = true
            img.heightAnchor.constraint(equalToConstant: 100).isActive = true
            if let url = URL(string: card.image) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            img.image = image
                        }
                    }
                    
                }.resume()
            }
            stack.addArrangedSubview(img)
        }
        
    }
    
    private func updateScore () {
        let playerScore = viewModel.total(for: viewModel.playerCardsPublic)
        let botScore = viewModel.total(for: viewModel.botCardsPublic)
        playerName.text = "Jugador: \(playerScore)"
        botName.text = "Bot: \(botScore)"
        
        if playerScore > 21 {
            viewModel.endGame()
        }
    }
    
    
}
