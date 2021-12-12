//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Андрей on 08.06.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojisThemes = [
            Theme(
                name: "Helloween",
                color: .orange,
                cards: ["👻","🎃","🕷","👽","👾","🤖","👿","💀","🧠","👀","🧟‍♀️","🧛‍♂️"]
            ),
            Theme(
                name: "Animals",
                color: Color("#CD853F"),
                cards: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐻‍❄️","🐨","🐯","🦁","🐮","🐷","🐸","🐵"]
            ),
            Theme(
                name: "Flags",
                color: .blue,
                cards: ["🏳️‍🌈","🇺🇳","🇦🇺","🇦🇹","🇧🇬","🇧🇷","🇬🇧","🏴󠁧󠁢󠁥󠁮󠁧󠁿","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇭🇺","🇻🇪","🇻🇮","🇩🇪"]
            ),
            Theme(
                name: "Food",
                color: Color(hex: "f9bb96"),
                cards: setEmojisList(fromRange: 0x1F34F...0x1F36F)
            ),
            Theme(
                name: "Thing",
                color: .gray,
                cards: ["⌚️","📱","💻","⌨️","🖥","🖨","🖲","🕹","🗜","💿","💾","📼","📷","📹","🎥"]
            ),
            Theme(
                name: "Cars",
                color: .blue,
                cards: setEmojisList(fromRange: 0x1F697...0x1F6A2))
        ]
        let gameEmojisTheme = emojisThemes.randomElement()!
        let gameEmojis = gameEmojisTheme.cards.shuffled().prefix(Int.random(in: 3...6))
        return MemoryGame<String>(
            name: gameEmojisTheme.name,
            color: gameEmojisTheme.color,
            numberOfPairsOfCards: gameEmojis.count
        ) { pairIndex in gameEmojis[pairIndex] }
    }
    
    private static func setEmojisList(fromRange emojisRange: ClosedRange<Int>) -> [String] {
        var emojis = [String]()
        for i in emojisRange {
            let c = String(UnicodeScalar(i) ?? "-")
            emojis.append(c)
        }
        return emojis
    }
    
    struct Theme {
        var name: String
        var color: Color?
        var cards: [String]
    }
    
    // MARK: - Acces to the model
    
    var score: Int { model.score }
    var name: String { model.theme.name }
    var color: Color? { model.theme.color }
    var cards: [MemoryGame<String>.Card] { model.theme.cards }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
