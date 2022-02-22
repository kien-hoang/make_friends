//
//  MessageCellView.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI
import Kingfisher
import AVFoundation

struct MessageCellView: View {
    @StateObject var cellViewModel: MessageCellViewModel
    
    var body: some View {
        HStack {
            if cellViewModel.fromCurrentUser {
                Spacer()
            }
            
            VStack(alignment: cellViewModel.fromCurrentUser ? .trailing : .leading) {
                switch cellViewModel.message.type {
                case .text(let text):
                    Text(text)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(10)
                        .background(cellViewModel.fromCurrentUser ? Color(Asset.Colors.Global.redD41717.color).opacity(0.3) : Color(Asset.Colors.Global.gray777777.color).opacity(0.3))
                        .cornerRadius(10)
                        .shadow(color: Color(Asset.Colors.Global.gray777777.color).opacity(0.2), radius: 10, x: 0, y: 0)
                        .onTapGesture {
                            cellViewModel.toggleShowCreatedTime()
                        }
                    
                case .stillImage(let imageUrl):
                    KFImage(imageUrl)
                        .resizable()
                        .placeholder {
                            Rectangle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay(
                                    Image(Asset.Global.icPlaceholderLogo.name)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                )
                        }
                        .scaledToFill()
                        .frame(width: __SCREEN_WIDTH__ / 1.5, height: __SCREEN_WIDTH__ / 2)
                        .shadow(color: Color(Asset.Colors.Global.gray777777.color).opacity(0.2), radius: 10, x: 0, y: 0)
                        .cornerRadius(20)
                        .clipped()
                        .fullScreenCover(isPresented: $cellViewModel.isShowPhotoFullView) {
                            PhotoFullView(isShowPhotoFullView: $cellViewModel.isShowPhotoFullView, imageUrl: imageUrl)
                        }
                        .onTapGesture {
                            cellViewModel.isShowPhotoFullView = true
                        }
                    
                case .video(let videoUrl):
                    Group {
                        if let thumbnailImage = getThumbnailImage(forUrl: videoUrl) {
                            ZStack {
                                Image(uiImage: thumbnailImage)
                                    .resizable()
                                    .scaledToFill()
                                
                                Image(Asset.Global.icPlayVideo.name)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .scaledToFill()
                            }
                            
                        } else {
                            Rectangle()
                                .fill(Color(Asset.Colors.Global.grayF1F1F1.name))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .overlay(
                                    Image(Asset.Global.icPlaceholderLogo.name)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                )
                        }
                    }
                    .frame(width: __SCREEN_WIDTH__ / 1.5, height: __SCREEN_WIDTH__ / 2)
                    .shadow(color: Color(Asset.Colors.Global.gray777777.color).opacity(0.2), radius: 10, x: 0, y: 0)
                    .cornerRadius(20)
                    .clipped()
                    .fullScreenCover(isPresented: $cellViewModel.isShowVideoFullView) {
                        VideoFullView(isShowVideoFullView: $cellViewModel.isShowVideoFullView, videoUrl: videoUrl)
                    }
                    .onTapGesture {
                        cellViewModel.isShowVideoFullView = true
                    }
                }
                
                if let timeString = cellViewModel.message.createdAt?.HHmmddMMyyyy,
                   cellViewModel.isShowCreatedTime {
                    Text(timeString)
                        .style(font: .lexendRegular, size: 10, color: Asset.Colors.Global.gray777777.color)
                }
            }
            
            if !cellViewModel.fromCurrentUser {
                Spacer()
            }
        }
    }
    
    // MARK: - ThumbnailImage
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }

        return nil
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCellView(cellViewModel: MessageCellViewModel(Message()))
    }
}
