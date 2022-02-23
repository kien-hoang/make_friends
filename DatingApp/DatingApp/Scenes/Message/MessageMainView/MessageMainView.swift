//
//  MessageMainView.swift
//  DatingApp
//
//  Created by Radley Hoang on 22/11/2021.
//

import SwiftUI

struct MessageMainView: View {
    @StateObject var viewModel = MessageMainViewModel()
    
    var body: some View {
        Group {
            if viewModel.matches.isEmpty {
                EmptyMessageView()
            } else {
                ListChatView(viewModel: viewModel)
                    .navigationView()
                    .onAppear {
                        viewModel.renderMatches = viewModel.matches
                    }
            }
        }
        .onReceive(.DidGotMatch) { _ in
            viewModel.getListChat()
        }
    }
    
    // MARK: - ListChatView
    struct ListChatView: View {
        @ObservedObject var viewModel: MessageMainViewModel
        
        var body: some View {
            VStack(spacing: 0) {
//                SearchView(viewModel: viewModel)
//                    .padding([.leading, .trailing, .bottom], K.Constants.ScreenPadding)
                
                ScrollView {
                    PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        viewModel.renderMatches.removeAll()
                        viewModel.matches.removeAll()
                        viewModel.getListChat()
                    }
                    
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.renderMatches.indices, id: \.self) { index in
                            let messageView = MessageView(viewModel: MessageViewModel(match: viewModel.matches[index]))
                            NavigationLink(destination: messageView) {
                                MessageMainCellView(cellViewModel: MessageMainCellViewModel(match: viewModel.matches[index]))
                                    .padding(.horizontal, K.Constants.ScreenPadding)
                                    .swipeActions(trailing: [
                                        SwipeActionButton(text: Text("BÁO CÁO"), icon: Image(systemName: "flag"), action: {
                                            viewModel.isShowReportPopup = true
                                            viewModel.selectedMatch = viewModel.matches[index]
                                        }, tint: Color(Asset.Colors.Global.gray777777.color).opacity(0.5)),
                                        SwipeActionButton(text: Text("HUỶ\nKẾT NỐI"), icon: nil, action: {
                                            viewModel.isShowReportAlert = true
                                            viewModel.selectedMatch = viewModel.matches[index]
                                        }, tint: Color(Asset.Colors.Global.redD41717.color))
                                    ])
                                    .frame(height: 50)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "pullToRefresh")
                
                Spacer()
            }
            .hiddenNavigationBar()
            .padding(.bottom, K.Constants.ScreenPadding)
            .onReceive(.UpdateLastMessage) { notification in
                guard let match = notification.object as? Match else { return }
                viewModel.updateLastMessage(match)
            }
            // TODO: Show report popup
            .fullScreenCover(isPresented: $viewModel.isShowReportPopup) {
                ReportUserMainView(viewModel: ReportUserMainViewModel(reportedUserId: viewModel.getReportedUserId()), isShowPopup: $viewModel.isShowReportPopup)
            }
            // TODO: Dismiss report popup
            .onReceive(.DidReportUserSuccess) { _ in
                viewModel.isShowReportPopup = false
                Helper.showSuccess("Báo cáo người dùng thành công")
            }
            .alert(isPresented: $viewModel.isShowReportAlert) {
                Alert(
                    title: Text("Huỷ kết nối"),
                    message: Text("Bạn có chắc chắn muốn huỷ kết nối hay không?"),
                    primaryButton: .default (Text("Có")) {
                        viewModel.unmatchUser()
                    },
                    secondaryButton: .cancel(Text("Không"))
                )
            }
        }
    }
    
    // MARK: - SearchView
//    struct SearchView: View {
//        @ObservedObject var viewModel: MessageMainViewModel
//        
//        var body: some View {
//            HStack {
//                HStack {
//                    Image(uiImage: Asset.Global.icSearch.image)
//                    
//                    TextField("Search", text: $viewModel.searchText, onEditingChanged: { isEditing in
//                        viewModel.showCancelButton = true
//                    }, onCommit: {
//                        viewModel.searchText = ""
//                        viewModel.searchChat()
//                    })
//                        .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
//                }
//                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//                .foregroundColor(.secondary)
//                .background(Color(.secondarySystemBackground))
//                .cornerRadius(10.0)
//                
//                if viewModel.showCancelButton {
//                    Button("Cancel") {
//                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
//                        viewModel.searchText = ""
//                        viewModel.showCancelButton = false
//                    }
//                    .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.black100.color)
//                }
//            }
//        }
//    }
    
    // MARK: - EmptyMessageView
    struct EmptyMessageView: View {
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
}

struct MessageMainView_Previews: PreviewProvider {
    static var previews: some View {
        MessageMainView()
    }
}
