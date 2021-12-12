//
//  MemoryGame.swift
//  Memorize
//
//  Created by Андрей on 08.06.2021.
//

import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var theme: Theme
    var score: Int = 0
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { theme.cards.indices.filter { theme.cards[$0].isFaceUp }.only }
        set {
            for index in theme.cards.indices {
                theme.cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let choosenIndex = theme.cards.firstIndex(matching: card), !theme.cards[choosenIndex].isFaceUp, !theme.cards[choosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if theme.cards[choosenIndex].content == theme.cards[potentialMatchIndex].content {
                    theme.cards[choosenIndex].isMatched = true
                    theme.cards[potentialMatchIndex].isMatched = true
                    score += 2
                } else if theme.cards[potentialMatchIndex].alreadyViewed {
                    score -= 1
                }
                theme.cards[choosenIndex].isFaceUp = true
                theme.cards[choosenIndex].alreadyViewed = true
                theme.cards[potentialMatchIndex].alreadyViewed = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = choosenIndex
            }
        }
    }
    
    init(name: String, color: Color?, numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        theme = Theme(name: name, color: color, cards: [Card]())
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            theme.cards.append(Card(content: content, id: pairIndex*2))
            theme.cards.append(Card(content: content, id: pairIndex*2+1))
        }
        theme.cards.shuffle()
    }
    
    struct Theme {
        var name: String
        var color: Color?
        var cards: [Card]
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        var alreadyViewed: Bool = false
        
        //MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches card before a certian amount
        // of time asses durring with e card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is steel is face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how match time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        
        // whether the card was mathed during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusRemaining > 0
        }
        
        // wether we are currently face up, unmatched and have not yet used up the bonsu window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
