//
//  MatchHomeViewCell.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/12/2021.
//

import SwiftUI
import Kingfisher

struct MatchHomeCellView: View {
    @StateObject var cellViewModel: MatchHomeCellViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top) {
                    let url = !cellViewModel.user.images.isEmpty ? cellViewModel.user.images[cellViewModel.currentImageIndex] : ""
                    KFImage(URL(string: url))
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay(
                                    Image(Asset.Global.icPlaceholderLogo.name)
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                )
                        }
                        .scaledToFill()
                        .frame(maxWidth: geo.size.width)
                        .clipped()
                    
                    HStack {
                        ForEach(0..<cellViewModel.numberPageControl(), id: \.self) { index in
                            Rectangle()
                                .fill(index == cellViewModel.currentImageIndex ? Color.white : Color.black.opacity(0.4))
                                .frame(height: 2)
                        }
                    }
                    .padding([.leading, .trailing, .top], 8)
                    .opacity(cellViewModel.isShowPageControl() ? 1 : 0)
                }
                
                Infomation(cellViewModel: cellViewModel)
                    .padding(.all, 20)
                    .background(
                        LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                    )
            }
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
    
    struct Infomation: View {
        @ObservedObject var cellViewModel: MatchHomeCellViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(cellViewModel.getInformation())
                    .style(font: .lexendMedium, size: 28, color: Asset.Colors.Global.white100.color)
                    .padding(.bottom, 8)
                
                HStack {
                    Image(Asset.Global.icLocation.name)
                    Text(cellViewModel.getLocationDistance())
                        .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.white100.color)
                    
                    Spacer()
                    Image(Asset.Global.swipeBack.name)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .fill(Color(Asset.Colors.Global.white100.color))
                                .frame(width: 50, height: 50)
                                .offset(x: 1, y: 0)
                        )
                        .padding(.trailing, 30)
                        .onTapGesture {
                            cellViewModel.showPreviousImage()
                        }
                    
                    Image(Asset.Global.swipeNext.name)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .background(
                            Circle()
                                .fill(Color(Asset.Colors.Global.white100.color))
                                .frame(width: 50, height: 50)
                                .offset(x: -2, y: 0)
                        )
                        .onTapGesture {
                            cellViewModel.showNextImage()
                        }
                }
            }
        }
    }
}

struct MatchHomeViewCell_Previews: PreviewProvider {
    static var previews: some View {
        MatchHomeCellView(cellViewModel: MatchHomeCellViewModel(user: User()))
    }
}
