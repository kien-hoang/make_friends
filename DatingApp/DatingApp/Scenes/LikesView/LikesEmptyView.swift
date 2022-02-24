//
//  LikesEmptyView.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/02/2022.
//

import SwiftUI

struct LikesEmptyView: View {
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
                Text("Danh sách những người\n đã thích bạn")
                    .multilineTextAlignment(.center)
                    .style(font: .lexendBold, size: 18, color: Asset.Colors.Global.black100.color)
                Text("Bạn có thể xem được những ai đã thích bạn ở đây")
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
            }
            Spacer()
        }
    }
}

struct LikesEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        LikesEmptyView()
    }
}
