//
//  LikesCellView.swift
//  DatingApp
//
//  Created by Radley Hoang on 24/02/2022.
//

import SwiftUI
import Kingfisher

struct LikesCellView: View {
    @StateObject var cellViewModel: LikesCellViewModel
    var itemWidth = (__SCREEN_WIDTH__ - 20 * 2 - 10) / 2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            KFImage(URL(string: cellViewModel.user.images.first ?? ""))
                .placeholder {
                    Image(Asset.Global.icPlaceholderLogo.name)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(
                            Rectangle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.color))
                                .frame(width: itemWidth, height: itemWidth * 1.5)
                                .cornerRadius(12)
                        )
                }
                .resizable()
                .scaledToFill()
                .frame(width: itemWidth, height: itemWidth * 1.5)
                .cornerRadius(12)
                .clipped()
            
            HStack {
                HStack {
                    Spacer()
                    Image(Asset.Global.swipeDislike.name)
                        .resizable()
                        .frame(width: 45, height: 45)
                        .background(
                            Circle()
                                .fill(.white)
                                .frame(width: 28, height: 28)
                                .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.2), radius: 4, x: 0, y: 0)
                        )
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.white.opacity(0.3))
                .contentShape(Rectangle())
                .onTapGesture {
                    cellViewModel.likeOrDislike(direction: .left)
                }
                
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 2, height: 50)
                
                HStack {
                    Spacer()
                    Image(Asset.Global.swipeLike.name)
                        .resizable()
                        .frame(width: 45, height: 45)
                        .background(
                            Circle()
                                .fill(.white)
                                .frame(width: 28, height: 28)
                                .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.2), radius: 4, x: 0, y: 0)
                        )
                    Spacer()
                }
                .frame(height: 50)
                .background(Color.white.opacity(0.3))
                .contentShape(Rectangle())
                .onTapGesture {
                    cellViewModel.likeOrDislike(direction: .right)
                }
            }
        }
    }
}

//struct LikesCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesCellView()
//    }
//}
