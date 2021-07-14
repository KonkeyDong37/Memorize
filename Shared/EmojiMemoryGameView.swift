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
                            CardView(card: card, gradient: viewModel.gradient)
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
    var gradient: Gradient?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if card.isFaceUp {
                    RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                    RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                    Text(card.content)
                } else {
                    if !card.isMatched {
                        if let gradient = gradient {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius).fill()
                        }
                    }
                }
            }
            .font(Font.system(size: fontSize(for: geometry.size)))
        }
    }
    
    // MARK: - Drawning Constatns
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3.0
    func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
            .preferredColorScheme(.light)
    }
}
