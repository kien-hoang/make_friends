//
//  MessageCellView.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI

struct MessageCellView: View {
    @ObservedObject var cellViewModel: MessageCellViewModel
    
    var body: some View {
        HStack {
            if cellViewModel.fromCurrentUser {
                Spacer()
            }
            Text(cellViewModel.message.messageContent)
                .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                .padding(10)
                .background(cellViewModel.fromCurrentUser ? Color(Asset.Colors.Global.redD41717.color).opacity(0.3) : Color(Asset.Colors.Global.gray777777.color).opacity(0.3))
                .cornerRadius(10)
            if !cellViewModel.fromCurrentUser {
                Spacer()
            }
        }
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(cellViewModel: MessageCellViewModel(Message()))
    }
}
