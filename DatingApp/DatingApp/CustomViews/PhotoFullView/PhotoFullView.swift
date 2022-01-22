//
//  PhotoFullView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/01/2022.
//

import SwiftUI
import Kingfisher

struct PhotoFullView: View {
    @Binding var isShowPhotoFullView: Bool
    let imageUrl: URL
    
    var body: some View {
        ZStack {
            Color(Asset.Colors.Global.black100.color)
                .ignoresSafeArea()
            KFImage(imageUrl)
                .resizable()
                .placeholder {
                    Rectangle()
                        .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .overlay(
                            Image(Asset.Global.icPlaceholderLogo.name)
                                .resizable()
                                .frame(width: 100, height: 100)
                        )
                }
                .scaledToFit()
                .ignoresSafeArea()
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
            if value.translation.width < 0 {
                // left
            }
            if value.translation.width > 0 {
                // right
            }
            if value.translation.height < 0 {
                // up
            }
            
            if value.translation.height > 0 {
                // down
                isShowPhotoFullView = false
            }
        }))
    }
}

struct PhotoFullView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoFullView(isShowPhotoFullView: Binding.constant(true),
                      imageUrl: URL(string: "http://babystar.vn/wp-content/uploads/2020/05/644cc7bf483cb262eb2d.jpg")!)
    }
}
