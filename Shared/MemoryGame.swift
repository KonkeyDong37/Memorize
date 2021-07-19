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
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        var alreadyViewed: Bool = false
    }
}
