//
//  LikesView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI

struct LikesView: View {
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            VStack(spacing: 30) {
                Image(systemName: "camera")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                    .rotationEffect(.degrees(20))
                HStack(spacing: 40) {
                    Image(systemName: "music.note.list")
                        .foregroundColor(.blue).opacity(0.7)
                    Image(systemName: "photo")
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees(-20))
                }
                .font(.system(size: 60))
            }
            VStack(spacing: 20) {
                Text("Tính năng đang phát triển")
                    .style(font: .lexendBold, size: 18, color: Asset.Colors.Global.black100.color)
                Text("Hãy nâng cấp lên bản Pro để biết được ai đã thích bạn.")
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
            }
            Spacer()
        }
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView()
    }
}
