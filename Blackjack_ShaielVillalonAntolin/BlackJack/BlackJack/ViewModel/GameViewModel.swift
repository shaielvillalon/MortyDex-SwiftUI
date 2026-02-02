//
//  GameViewModel.swift
//  BlackJack
//
//  Created by Shaiel Villalon Antolin on 8/11/25.
//

import Foundation

class GameViewModel {
    
    private var deckID: String = ""
    private var playerCards: [Card] = []
    private var botCards: [Card] = []
    private var hasEndedGame = false
    
    //Accesores solo lecturas
    var playerCardsPublic: [Card] { playerCards }
    var botCardsPublic: [Card] { botCards }
    
    var updateCard: (() -> Void)?
    var updateStatus: ((String) -> Void)?
    var endedGame: ((GameResult) -> Void)?
    
    func startgame () {
        playerCards.removeAll()
        botCards.removeAll()
        updateStatus?("")
        createNewDeck()
        hasEndedGame = false
        
    }
    
    private func createNewDeck () {
        guard let url = URL(string: "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1") else {
            updateStatus?("Url invalida")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let deckResponse = try JSONDecoder().decode(DeckResponse.self, from: data)
                self.deckID = deckResponse.deck_id
                self.initialDeal ()
            } catch {
                print ("Error al crear el mazo")
            }
            
        }
        task.resume()
    }
    
    private func initialDeal () {
        
        drawCards(count: 2) { cards in //Peticion para robar 2 cartas
            guard let cards = cards, cards.count == 2 else { return }
            self.playerCards.append(cards[0])
            self.botCards.append(cards[1])
            self.updateCard?()
        }


    }
    
    private func drawCards (count: Int, completion: @escaping ([Card]?) -> Void) {
        
        guard !deckID.isEmpty else { completion(nil);return }
        let url = URL(string: "https://deckofcardsapi.com/api/deck/\(deckID)/draw/?count=\(count)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {completion(nil); return }
            do {
                let respuesta = try JSONDecoder().decode(DeckResponse.self, from: data)
                completion(respuesta.cards)
            } catch {
                print ("Error al mostrar cartas")
                completion(nil)
            }
            
        }.resume()
        
    }
    
    
    func botTurn(completion: @escaping () -> Void) {
        
        guard botCards.count < 6 else {
            completion()
            return
        }
        
        if total(for: botCards) < 17 {
            drawCards(count: 1) { cards in
                guard let card = cards?.first else { return }
                self.botCards.append(card)
                self.updateCard?()
                self.botTurn(completion: completion)
            }
        } else {
            completion()
        }
    }
    
    
    func total (for cards: [Card]) -> Int {
        
        var total = 0
        var aces = 0
        
        for card in cards {
            let valor = cardValue (card)
            total = total + valor
            if valor == 11 { aces = aces + 1}
        }
        
        while total > 21 && aces > 0 {
            total = total - 10 //El valor del as pasa de ser 11 a ser 1, segun conviene
            aces = aces - 1
        }
        return total
    }
    
    
    func cardValue ( _ card: Card) -> Int {
        
        switch card.value {
            case "JACK", "QUEEN", "KING": return 10
            case "ACE": return 11
            default: return Int(card.value) ?? 0
        }
        
    }
    
    func endGame() {
        
        guard !hasEndedGame else { return }
        hasEndedGame = true
        
        let playerScore = total(for: playerCards)
        let botScore = total(for: botCards)
        var message = ""
        
        if playerScore > 21 {
            message = "Te pasaste de 21, perdiste"
        } else if botScore > 21 || playerScore > botScore {
            message = "Ganaste"
        } else if playerScore == botScore {
            message = "Empate"
        } else {
            message = "Perdiste"
        }
        
        let result = GameResult(
            playerName: GameSession.shared.playerName,
            playerScore: playerScore,
            botScore: botScore,
            result: message,
            date: Date()
        )
        
        //GameSession.shared.history.append(result)
        
        //GameSession.shared.history.insert(result, at: 0)
        updateStatus?(message)
        endedGame?(result)
        
    }
    
    func playerDrawCard(completion: @escaping () -> Void) {
        
        guard playerCards.count < 6 else {
            updateStatus?("Limite de cartas alcanzado")
            return
        }
        
        drawCards (count: 1) { cards in
            guard let card = cards?.first else { return }
            self.playerCards.append(card)
            self.updateCard?()
            completion()
        }
    }
    
    
}
