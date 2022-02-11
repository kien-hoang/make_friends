//
//  MessageMainPullToRefresh.swift
//  DatingApp
//
//  Created by Radley Hoang on 11/02/2022.
//

import SwiftUI

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("Pull to refresh")
                        .style(font: .lexendBold, size: 14, color: Asset.Colors.Global.gray777777.color)
                        .offset(y: 20)
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}
