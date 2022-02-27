//
//  EditInterestedTagsView.swift
//  DatingApp
//
//  Created by Radley Hoang on 15/01/2022.
//

import SwiftUI

struct EditInterestedTagsView: View {
    @StateObject var viewModel: EditInterestedTagsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(viewModel: viewModel)
            
            InterestedTagsList(viewModel: viewModel)
        }
        .hiddenNavigationBar()
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - InterestedTagsList
    struct InterestedTagsList: View {
        @ObservedObject var viewModel: EditInterestedTagsViewModel
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
                .padding(.all, K.Constants.ScreenPadding)
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
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @ObservedObject var viewModel: EditInterestedTagsViewModel
        
        var body: some View {
            ZStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(Asset.Global.icDefaultBack.name)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 9)
                            .padding(.trailing, 12)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                }
                Text("Sở thích của bạn")
                    .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.black100.color)
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.updateInterestedTags()
                    } label: {
                        Text("Cập nhật")
                            .style(font: .lexendRegular, size: 16, color: Asset.Colors.Global.redD41717.color)
                            .padding(.horizontal, 12)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .frame(height: 44)
            .background(
                Color(Asset.Colors.Global.white100.color)// any non-transparent background
                    .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                    .mask(Rectangle().padding(.bottom, -20)) // shadow only bottom side
            )
            .onReceive(.DidUpdateInterestedTagsSuccess) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct EditInterestedTagsView_Previews: PreviewProvider {
    static var previews: some View {
        EditInterestedTagsView(viewModel: EditInterestedTagsViewModel(selectedInterestedTags: []))
    }
}
