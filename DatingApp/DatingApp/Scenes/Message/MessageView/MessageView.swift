//
//  MessageView.swift
//  DatingApp
//
//  Created by Radley Hoang on 03/01/2022.
//

import SwiftUI
import Kingfisher
import IQKeyboardManagerSwift

struct MessageView: View {
    @StateObject var viewModel: MessageViewModel = MessageViewModel(match: Match())
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
                .padding(.bottom, 12)
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.white.opacity(0.01))
                            .frame(height: 1)
                            .onAppear {
                                viewModel.loadMoreIfNeeded()
                            }
                        
                        ForEach(viewModel.groupedMessages.indices, id: \.self) { dateIndex in
                            let dateTime = viewModel.getDateTime(viewModel.groupedMessages[dateIndex].0)
                            Text(dateTime)
                                .style(font: .lexendBold, size: 12, color: Asset.Colors.Global.black100.color)
                                .padding()
                            
                            ForEach(viewModel.groupedMessages[dateIndex].1.indices, id: \.self) { messageIndex in
                                let msg = viewModel.groupedMessages[dateIndex].1[messageIndex]
                                MessageCellView(cellViewModel: MessageCellViewModel(msg))
                                    .id(msg.id)
                                    .padding(.horizontal, K.Constants.ScreenPadding)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                }
            }
            
            InputView(viewModel: viewModel)
                .padding(.vertical, 4)
        }
        .hiddenNavigationBar()
        .onAppear {
            IQKeyboardManager.shared.enable = false
        }
        .onDisappear {
            IQKeyboardManager.shared.enable = true
        }
        .onChange(of: viewModel.keyboardIsShowing) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.scrollToBottom()
            }
            
        }
        .onChange(of: viewModel.messages) { _ in
            if !viewModel.isLoadingMoreData {
                scrollToBottom()
            }
        }
        .onReceive(.DidReceivedMessage) { notification in
            guard let message = notification.object as? Message else { return }
            viewModel.receiveMessage(message)
        }
    }
    
    func scrollToBottom() {
        withAnimation {
            guard let lastMessage = viewModel.messages.last else { return }
            scrollProxy?.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    // MARK: - InputView
    struct InputView: View {
        @ObservedObject var viewModel: MessageViewModel
        @State private var typingMessage: String = ""
        @State private var isKeyboardShowing: Bool = false
        
        var body: some View {
            HStack(spacing: 0) {
                HStack {
                    Image(Asset.Global.icAddImage.name)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                .frame(width: isKeyboardShowing ? 0 : 50, height: 50)
                .clipped()
                .padding(.leading, K.Constants.ScreenPadding / 2)
                .onTapGesture {
                    if !viewModel.keyboardIsShowing {
                        viewModel.isShowUploadImageOptionActionSheet = true
                    }
                }
                .fullScreenCover(isPresented: $viewModel.isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                        .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $viewModel.isShowCamera) {
                    ImagePicker(sourceType: .stillImage, selectedImage: $viewModel.newImage, selectedVideoUrl: Binding.constant(nil))
                        .ignoresSafeArea()
                }
                .actionSheet(isPresented: $viewModel.isShowUploadImageOptionActionSheet) {
                    uploadImageOptionActionSheet
                }
                
                HStack {
                    Image(Asset.Global.icAddVideo.name)
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .frame(width: isKeyboardShowing ? 0 : 50, height: 50)
                .clipped()
                .onTapGesture {
                    if !viewModel.keyboardIsShowing {
                        viewModel.isShowUploadVideoOptionActionSheet = true
                    }
                }
                .fullScreenCover(isPresented: $viewModel.isShowVideoLibrary) {
                    ImagePicker(sourceType: .videoLibrary, selectedImage: Binding.constant(nil), selectedVideoUrl: $viewModel.newVideoUrl)
                        .ignoresSafeArea()
                }
                .fullScreenCover(isPresented: $viewModel.isShowVideo) {
                    ImagePicker(sourceType: .videoWithMic, selectedImage: Binding.constant(nil), selectedVideoUrl: $viewModel.newVideoUrl)
                        .ignoresSafeArea()
                }
                .actionSheet(isPresented: $viewModel.isShowUploadVideoOptionActionSheet) {
                    uploadVideoOptionActionSheet
                }
                
                ZStack(alignment: .trailing) {
                    Color(Asset.Colors.Global.gray777777.color).opacity(0.1)
                    
                    HStack(spacing: 0) {
                        TextField("Aa", text: $typingMessage)
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                            .textFieldStyle(PlainTextFieldStyle())
//                            .frame(width: __SCREEN_WIDTH__ - 100, height: 45)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                    Button(action: {
                        if !typingMessage.isEmpty {
                            sendMessage()
                        }
                        
                    }) {
                        Text("Gửi")
                            .style(font: .lexendRegular, size: 14, color: typingMessage.isEmpty ? Asset.Colors.Global.gray777777.color : Asset.Colors.Global.redD41717.color)
                    }
                    .frame(height: 40)
                    .padding(.horizontal)
                }
                .frame(height: 40)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(Asset.Colors.Global.gray777777.color).opacity(0.3), lineWidth: 1)
                )
                .padding(.trailing, K.Constants.ScreenPadding / 2)
                
                Spacer()
            }
            .onChange(of: viewModel.keyboardIsShowing) { isShow in
                isKeyboardShowing = isShow
                viewModel.notifyTypingMessageIfNeeded(isShow)
            }
        }
        
        func sendMessage() {
            viewModel.sendMessage(.text(typingMessage))
            typingMessage = ""
        }
        
        // MARK: - UploadOption
        var uploadImageOptionActionSheet: ActionSheet {
            ActionSheet(
                title: Text("Tải ảnh lên"),
                buttons: [
                    .default(Text("Máy ảnh")) {
                        viewModel.isShowCamera = true
                    },
                    .default(Text("Bộ sưu tập")) {
                        viewModel.isShowPhotoLibrary = true
                    },
                    .cancel(Text("Huỷ bỏ"))
                ]
            )
        }
        
        var uploadVideoOptionActionSheet: ActionSheet {
            ActionSheet(
                title: Text("Tải video lên"),
                buttons: [
                    .default(Text("Quay phim")) {
                        viewModel.isShowVideo = true
                    },
                    .default(Text("Thư viện")) {
                        viewModel.isShowVideoLibrary = true
                    },
                    .cancel(Text("Huỷ bỏ"))
                ]
            )
        }
    }
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @ObservedObject var viewModel: MessageViewModel
        
        var body: some View {
            HStack(spacing: 0) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(Asset.Global.icDefaultBack.name)
                        .frame(width: 30, height: 30)
                        .padding(.leading, 9)
                        .padding(.trailing, 12)
                }
                
                KFImage(viewModel.getImageUrl())
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
                    .padding(.trailing, 8)
                    // TODO: Show/dismiss Detail Profile View
                    .fullScreenCover(isPresented: $viewModel.isPresentDetailProfileView) {
                        let viewModel = DetailProfileViewModel(user: viewModel.getFriendUser())
                        DetailProfileView(viewModel: viewModel)
                            .hiddenNavigationBar()
                            .navigationView()
                    }
                    .onReceive(.DismissDetailProfileView) { _ in
                        viewModel.isPresentDetailProfileView = false
                    }
                    .onTapGesture {
                        viewModel.showDetailFriendProfile()
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.getLikedName())
                        .style(font: .lexendMedium, size: 24, color: Asset.Colors.Global.black100.color)
                    Group {
                        if viewModel.isFriendTyping {
                            TypingAnimationView()
                        } else {
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(Color(Asset.Colors.Global.redD41717.color))
                                    .frame(width: 6, height: 6)
                                Text("Đang hoạt động")
                                    .style(font: .lexendRegular, size: 10, color: Asset.Colors.Global.gray777777.color)
                            }
                        }
                    }
                    .frame(height: 15)
                    .padding(.leading, 2)
                    .onReceive(.NotifyTypingMessage) { notification in
                        guard let dataDict = notification.object as? [String: Any] else { return }
                        viewModel.receivedNotifyTypingMessage(dataDict)
                    }
                    .onReceive(.NotifyStopTypingMessage) { notification in
                        guard let dataDict = notification.object as? [String: Any] else { return }
                        viewModel.receivedNotifyStopTypingMessage(dataDict)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - TypingAnimationView
    struct TypingAnimationView: View {
        @State private var isBlinking1: Bool = false
        @State private var isBlinking2: Bool = false
        @State private var isBlinking3: Bool = false
        
        var body: some View {
            HStack(spacing: 4) {
                Circle()
                    .fill(Color(Asset.Colors.Global.redD41717.color))
                    .frame(width: 6, height: 6)
                    .opacity(isBlinking1 ? 0.2 : 1)
                    .onAppear {
                        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                            isBlinking1 = true
                        }
                    }
                
                Circle()
                    .fill(Color(Asset.Colors.Global.redD41717.color))
                    .frame(width: 6, height: 6)
                    .opacity(isBlinking2 ? 0.2 : 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                self.isBlinking2 = true
                            }
                        }
                    }
                
                Circle()
                    .fill(Color(Asset.Colors.Global.redD41717.color))
                    .frame(width: 6, height: 6)
                    .opacity(isBlinking3 ? 0.2 : 1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                                self.isBlinking3 = true
                            }
                        }
                    }
                
                Text("Đang nhập tin nhắn")
                    .style(font: .lexendRegular, size: 10, color: Asset.Colors.Global.gray777777.color)
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
