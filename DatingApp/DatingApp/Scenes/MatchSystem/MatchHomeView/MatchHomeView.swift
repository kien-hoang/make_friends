//
//  MatchHomeView.swift
//  DatingApp
//
//  Created by Radley Hoang on 20/11/2021.
//

import SwiftUI

struct MatchHomeView: View {
    private let buttons = ActionButton.buttons
    private let cards: [Card] = Card.cards
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    ForEach(cards, id: \.id) { card in
                        CardView(card: card)
                            .shadow(radius: 5)
                    }
                }
                
                Spacer()
                HStack {
                    Spacer()
                    ForEach(buttons, id: \.id) { button in
                        Button(action: {
                            
                        }) {
                            Image(systemName: button.image)
                                .font(.system(size: 23, weight: .heavy))
                                .foregroundColor(button.color)
                                .frame(width: button.height, height: button.height)
                                .modifier(ButtonBG())
                                .cornerRadius(button.height/2)
                                .modifier(ThemeShadow())
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            
            
            
        }
    }
}

struct MatchHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchHomeView()
    }
}

struct ActionButton {
    let id: Int
    let image: String
    let color: Color
    let height: CGFloat
    
    static let buttons = [
        ActionButton(id: 0,
                     image: "arrow.counterclockwise",
                     color: Color(UIColor(red: 247/255, green: 181/255, blue: 50/255, alpha: 1)),
                     height: 47),
        ActionButton(id: 1,
                     image: "xmark",
                     color: Color(UIColor(red: 250/255, green: 73/255, blue: 95/255, alpha: 1)),
                     height: 55),
        ActionButton(id: 2,
                     image: "star.fill",
                     color: Color(UIColor(red: 38/255, green: 172/255, blue: 250/255, alpha: 1)),
                     height: 47),
        ActionButton(id: 3,
                     image: "suit.heart.fill",
                     color: Color(UIColor(red: 60/255, green: 229/255, blue: 184/255, alpha: 1)),
                     height: 55),
        ActionButton(id: 4,
                     image: "bolt.fill",
                     color: .purple,
                     height: 47)
    ]
}

struct Card: Identifiable {
    let id: UUID = UUID()
    let name: String
    let age: Int
    let desc: String
    let image: String
    
    static let cards: [Card] = [
        Card(name: "Dakota Johnson", age: 29, desc: "Love", image: "img_dj"),
        Card(name: "Angelina Jolie", age: 29, desc: "Beauty", image: "img_aj"),
        Card(name: "Brie Larson", age: 22, desc: "Dancer", image: "img_bl"),
        Card(name: "Emma Watson", age: 19, desc: "Moody", image: "img_ew"),
        Card(name: "Gal Gadot", age: 25, desc: "DC", image: "img_gg"),
        Card(name: "Natalie Portman", age: 29, desc: "Thor's", image: "img_np"),
        Card(name: "Selena", age: 23, desc: "Singer", image: "img_sg"),
        Card(name: "Scarlet Johnson", age: 31, desc: "Dog Lover", image: "img_sj"),
        Card(name: "Taylor Swift", age: 29, desc: "Music", image: "img_ts"),
    ]
    
}
