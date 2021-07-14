//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Андрей on 08.06.2021.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
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
                gradient: Gradient(colors: [.blue, .purple]),
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
        let gameEmojisTheme = emojisThemes[2]
        let gameEmojis = gameEmojisTheme.cards.shuffled().prefix(Int.random(in: 3...6))
        return MemoryGame<String>(
            name: gameEmojisTheme.name,
            color: gameEmojisTheme.color,
            gradient: gameEmojisTheme.gradient,
            numberOfPairsOfCards: gameEmojis.count
        ) { pairIndex in gameEmojis[pairIndex] }
    }
    
    static func setEmojisList(fromRange emojisRange: ClosedRange<Int>) -> [String] {
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
        var gradient: Gradient?
        var cards: [String]
    }
    
    // MARK: - Acces to the model
    
    var score: Int { model.score }
    var name: String { model.theme.name }
    var color: Color? { model.theme.color }
    var gradient: Gradient? { model.theme.gradient }
    var cards: [MemoryGame<String>.Card] { model.theme.cards }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
