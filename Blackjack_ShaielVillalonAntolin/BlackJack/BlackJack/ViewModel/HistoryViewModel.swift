//
//  HistoryViewModel.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//

import Foundation

class HistoryViewModel {
    var history: [GameResult] {
        return GameSession.shared.history.sorted { $0.date > $1.date }
    }
    
    func clearHistory () {
        GameSession.shared.history.removeAll()
    }
}

