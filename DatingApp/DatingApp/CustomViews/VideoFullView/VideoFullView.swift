//
//  VideoFullView.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI
import Kingfisher
import AVKit

struct VideoFullView: View {
    @Binding var isShowVideoFullView: Bool
    var videoUrl: URL
    
    @State private var player = AVPlayer()
    @State private var isPlay = true
    
    var body: some View {
        ZStack {
            Color(Asset.Colors.Global.black100.color)
                .ignoresSafeArea()
            VideoPlayer(player: player)
                .onAppear() {
                    player = AVPlayer(url: videoUrl)
                    player.play()
                }
                .onDisappear {
                    player.pause()
                }
                .onTapGesture {
                    switch isPlay {
                    case true:
                        player.pause()
                        
                    case false:
                        player.play()
                    }
                    isPlay.toggle()
                }
                .onReceive(.AVPlayerItemDidPlayToEndTime) { _ in
                    // TODO: Play again
                    player.seek(to: CMTime(value: CMTimeValue(0), timescale: CMTimeScale(1.0)))
                    player.play()
                }
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
                isShowVideoFullView = false
            }
        }))
    }
}

struct VideoFullView_Previews: PreviewProvider {
    static var previews: some View {
        VideoFullView(isShowVideoFullView: Binding.constant(true), videoUrl: URL(string: "http://res.cloudinary.com/radley/video/upload/v1642941971/619a1775ea9e24f4df825b7b/619a1775ea9e24f4df825b7b-1642941963397.mov")!)
    }
}
