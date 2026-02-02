//
//  Card.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 7/11/25.
//


import Foundation

struct Card: Codable {
    let code: String
    let image: String
    let value: String
    let suit: String
}


struct DeckResponse: Codable {
    let success: Bool
    let deck_id: String
    let remaining: Int
    let shuffled: Bool?
    let cards: [Card]?
}
