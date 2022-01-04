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
            HeaderView()
                .padding(.bottom, 12)
            
            ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.messages.indices, id: \.self) { index in
                            let msg = viewModel.messages[index]
                            MessageCellView(cellViewModel: MessageCellViewModel(msg))
                                .id(index)
                                .padding(.horizontal, K.Constants.ScreenPadding)
                                .padding(.bottom, 12)
                        }
                    }
                    .onAppear {
                        scrollProxy = proxy
                    }
                }
            }
            
            InputView(viewModel: viewModel)
                .padding(.top, 4)
        }
        .hiddenNavigationBar()
        .onAppear {
            IQKeyboardManager.shared.enable = false
        }
        .onDisappear {
            IQKeyboardManager.shared.enable = true
        }
        .onChange(of: viewModel.keyboardIsShowing) { newValue in
            if newValue {
                scrollToBottom()
            }
        }
        .onChange(of: viewModel.messages) { _ in
            scrollToBottom()
        }
    }
    
    func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(viewModel.messages.count - 1, anchor: .bottom)
        }
    }
    
    // MARK: - InputView
    struct InputView: View {
        @ObservedObject var viewModel: MessageViewModel
        @State private var typingMessage: String = ""
        
        var body: some View {
            ZStack(alignment: .trailing) {
                Color(Asset.Colors.Global.gray777777.color).opacity(0.1)
                
                HStack(spacing: 0) {
                    TextField("Aa", text: $typingMessage)
                        .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: __SCREEN_WIDTH__ - 100, height: 45)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                Button(action: { sendMessage() }) {
                    Text("Gửi")
                        .style(font: .lexendRegular, size: 14, color: typingMessage.isEmpty ? Asset.Colors.Global.gray777777.color : Asset.Colors.Global.redD41717.color)
                }
                .padding(.horizontal)
            }
            .frame(height: 40)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(Asset.Colors.Global.gray777777.color).opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
        
        func sendMessage() {
            viewModel.sendMessage(viewModel.mockMessage(typingMessage))
            typingMessage = ""
        }
    }
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        
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
                
                KFImage(URL(string: ""))
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
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Maria")
                        .style(font: .lexendMedium, size: 24, color: Asset.Colors.Global.black100.color)
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(Asset.Colors.Global.redD41717.color))
                            .frame(width: 6, height: 6)
                        Text("Đang hoạt động")
                            .style(font: .lexendRegular, size: 10, color: Asset.Colors.Global.gray777777.color)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView()
    }
}
