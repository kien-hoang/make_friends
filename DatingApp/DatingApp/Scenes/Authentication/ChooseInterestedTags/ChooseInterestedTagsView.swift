//
//  ChooseInterestedTagsView.swift
//  DatingApp
//
//  Created by Radley Hoang on 04/11/2021.
//

import SwiftUI

struct ChooseInterestedTagsView: View {
    @ObservedObject var viewModel = ChooseInterestedTagsViewModel()
    
    // MARK: - Main body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationBar()
                .padding(.bottom, 28)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Sở thích của bạn là:")
                    .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                    .padding(.bottom, 12)
                
                Text("Hãy chọn 5 sở thích của bạn và cho mọi người biết đam mê của bạn là gì:")
                    .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.gray9A9A9A.color)
                    .padding(.bottom, 20)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing], K.Constants.ScreenPadding)
            
            InterestedTagsList(viewModel: viewModel)
                        
            ContinueButton(viewModel: viewModel)
        }
    }
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: ChooseInterestedTagsViewModel
        
        var body: some View {
            VStack() {
                Button {
                    viewModel.nextAction()
                } label: {
                    Text("Tiếp tục")
                        .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                        .padding(8)
                        .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(Asset.Colors.Global.redD41717.color))
                                .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                        )
                }
            }
            .padding([.top, .bottom], 10)
            .frame(maxWidth: .infinity)
            .background(
                Color(Asset.Colors.Global.white100.color)// any non-transparent background
                    .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                    .mask(Rectangle().padding(.top, -20)) // shadow only top side
            )
        }
    }
    
    // MARK: - InterestedTagsList
    struct InterestedTagsList: View {
        @ObservedObject var viewModel: ChooseInterestedTagsViewModel
        let columns = [GridItem(.flexible()),
                       GridItem(.flexible())]
        
        var body: some View {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.interestedTags, id: \.self) { item in
                        Group {
                            if viewModel.isSelectedTag(item) {
                                Text(item.name)
                                    .modifier(CommonStyle())
                                    .modifier(SelectedTag())
                            } else {
                                Text(item.name)
                                    .modifier(CommonStyle())
                                    .modifier(NonSelectedTag())
                            }
                        }
                        .onTapGesture {
                            viewModel.onSelectTag(item)
                        }
                    }
                }
                .padding(.top, 2) // Avoid top shadow is clipped
                .padding([.leading, .trailing, .bottom], K.Constants.ScreenPadding)
            }
        }
        
        struct CommonStyle: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .lineLimit(2)
                    .padding(8)
                    .frame(maxWidth: .infinity, minHeight: 58, maxHeight: 58)
                    .multilineTextAlignment(.center)
            }
        }
        
        struct SelectedTag: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(Asset.Colors.Global.redD41717.color))
                            .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
        }
        
        struct NonSelectedTag: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(Asset.Colors.Global.white100.color))
                            .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
        }
    }
    
    // MARK: - NavigationBar
    struct NavigationBar: View {
        var body: some View {
            ZStack(alignment: .trailing) {
                DefaultNavigationView()
                
                Text("Bỏ qua")
                    .style(font: .lexendBold, size: 12, color: Asset.Colors.Global.redD41717.color)
                    .padding(.trailing, K.Constants.ScreenPadding)
                    .onTapGesture {
                        print("SKIP")
                    }
            }
        }
    }
}

struct ChooseInterestedTagsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseInterestedTagsView()
    }
}
