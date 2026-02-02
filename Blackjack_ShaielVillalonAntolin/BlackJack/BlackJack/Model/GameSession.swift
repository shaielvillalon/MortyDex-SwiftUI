//
//  GameSession.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//

import Foundation

final class GameSession {
    static let shared = GameSession()
    private init () {}
    
    //Historial
    var history: [GameResult] = []
    
    var playerName: String = "Jugador"
}

