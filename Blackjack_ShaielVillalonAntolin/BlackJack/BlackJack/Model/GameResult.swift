//
//  GameResult.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//


import Foundation

struct GameResult: Codable {
    let playerName: String
    let playerScore: Int
    let botScore: Int
    let result: String
    let date: Date
}
