//
//  MessageMainCellView.swift
//  DatingApp
//
//  Created by Radley Hoang on 01/01/2022.
//

import SwiftUI
import Kingfisher

struct MessageMainCellView: View {
    @StateObject var cellViewModel: MessageMainCellViewModel
    var readColor = Asset.Colors.Global.gray777777.color
    var noReadColor = Asset.Colors.Global.black100.color
    
    var body: some View {
        HStack {
            KFImage(cellViewModel.getImageUrl())
                .placeholder {
                    Image(Asset.Global.icPlaceholderLogo.name)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.color))
                                .frame(width: 48, height: 48)
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .cornerRadius(48 / 2)
                .clipped()
                .padding(.vertical, 8)
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 4)
                
                HStack {
                    Text(cellViewModel.getLikedName())
                        .style(font: .lexendMedium, size: 14, color: cellViewModel.isRead ? readColor : noReadColor)
                    Spacer()
                    Text(cellViewModel.getTimeString())
                        .style(font: .lexendRegular, size: 12, color: cellViewModel.isRead ? readColor : noReadColor)
                }
                
                HStack {
                    Text(cellViewModel.lastMessageString)
                        .style(font: .lexendRegular, size: 10, color: cellViewModel.isRead ? readColor : noReadColor)
                    Spacer()
                    
                    if !cellViewModel.isRead {
                        Circle()
                            .fill(Color(Asset.Colors.Global.redD41717.color))
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text("1+")
                                    .style(font: .lexendMedium, size: 10, color: Asset.Colors.Global.white100.color)
                            )
                    }
                }
                .padding(.bottom, 6)
                                
                Rectangle()
                    .fill(Color(Asset.Colors.Global.grayF1F1F1.color))
                    .frame(height: 1)
            }
        }
        .onReceive(.DidReadMessageSuccess) { notification in
            guard let match = notification.object as? Match else { return }
            cellViewModel.didReadMessageSuccess(match)
        }
        .onReceive(.DidReceivedMessage) { notification in
            guard let message = notification.object as? Message else { return }
            cellViewModel.receiveMessage(message)
        }
    }
}

struct MessageMainCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMainCellView(cellViewModel: MessageMainCellViewModel(match: Match()))
    }
}
