//
//  HistoryDetailViewController.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//

import UIKit

class HistoryDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var scoresLabel: UILabel!

    var game: GameResult?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let game = game else { return }
            
            nameLabel.text = "\(game.playerName)"
            
            let fmt = DateFormatter()
            fmt.dateStyle = .medium
            fmt.timeStyle = .short
            dateLabel.text = "\(fmt.string(from: game.date))"
            
            let lower = game.result.lowercased()
            if lower.contains("empate") {
                resultLabel.text = "🤝 Empate"
            } else if lower.contains("ganaste") {
                resultLabel.text = "🏆 Ganador: \(game.playerName)"
            } else if lower.contains("perdiste") {
                resultLabel.text = "💀 Ganador: Bot"
            } else {
                resultLabel.text = game.result
            }
            
            
            scoresLabel.text = "Jugador: \(game.playerScore)   Bot: \(game.botScore)"
        }
}


