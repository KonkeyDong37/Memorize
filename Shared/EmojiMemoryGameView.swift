//
//  EmojiMemoryGameView.swift
//  Shared
//
//  Created by Андрей on 05.06.2021.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State var gameStarted = false
    
    var body: some View {
        ZStack {
            if !gameStarted {
                Button(action: {
                    gameStarted.toggle()
                }, label: {
                    Text("New game")
                        .padding()
                        .padding(.horizontal, 20)
                        .foregroundColor(.purple)
                        .font(Font.system(size: 28, weight: .bold))
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.purple, style: StrokeStyle(lineWidth: 3))
                        )
                })
            } else {
                VStack {
                    HStack {
                        Text(viewModel.name)
                            .font(.title)
                            .frame(alignment: .trailing)
                        Spacer()
                        Text("Score: \(viewModel.score)")
                    }
                    Divider()
                    HStack {
                        Grid(viewModel.cards) { card in
                            CardView(card: card)
                                .padding(5)
                                .onTapGesture {
                                    viewModel.choose(card: card)
                                }
                        }
                    }
                }
            }
        }
        .foregroundColor(viewModel.color)
        .padding()
    }
}

struct CardView: View {
    
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            if card.isFaceUp || !card.isMatched {
                ZStack {
                    Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(110-90), clockwise: true)
                        .padding(6)
                        .opacity(0.6)
                    Text(card.content)
                        .font(Font.system(size: fontSize(for: geometry.size)))
                }
                .cardify(isFaceUp: card.isFaceUp)
            }
        }
    }
    
    // MARK: - Drawning Constatns
    
    private func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game, gameStarted: true)
            .preferredColorScheme(.light)
    }
}
