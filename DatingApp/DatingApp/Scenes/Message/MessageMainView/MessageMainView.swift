//
//  MessageMainView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI

struct MessageMainView: View {    
    var body: some View {
        VStack(spacing: 80) {
            Spacer()
            ZStack {
                Rectangle()
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                    ).foregroundColor(Color.gray.opacity(0.05))
                    .frame(width: 130, height: 200)
                    .offset(y: 20)
                Rectangle()
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green, lineWidth: 3)
                    ).foregroundColor(Color.green.opacity(0.05))
                    .frame(width: 130, height: 200)
                    .rotationEffect(.degrees(15))
                    .offset(x: 30)
                Text("THÍCH")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.green, lineWidth: 3)
                        )
                    .offset(x: 30)
            }
            VStack(spacing: 20) {
                Text("Hãy tiếp tục tìm bạn")
                    .style(font: .lexendBold, size: 18, color: Asset.Colors.Global.black100.color)
                Text("Bạn có thể gửi tin nhắn khi bạn kết nối thành công đến người khác")
                    .frame(width: 200)
                    .multilineTextAlignment(.center)
                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.gray9A9A9A.color)
            }
            Spacer()
        }
    }
}

struct MessageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMainView()
    }
}
