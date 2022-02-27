//
//  ChooseGenderView.swift
//  DatingApp
//
//  Created by Radley Hoang on 21/11/2021.
//

import SwiftUI

struct ChooseGenderView: View {
    @StateObject var viewModel = ChooseGenderViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Giới tính của bạn là:")
                .style(font: .lexendBold, size: 22, color: Asset.Colors.Global.black100.color)
                .padding(.bottom, 40)
            
            GenderView(viewModel: viewModel)
            
            Spacer()
            ContinueButton(viewModel: viewModel)
        }
        .padding(EdgeInsets(top: 28, leading: K.Constants.ScreenPadding, bottom: 10, trailing: K.Constants.ScreenPadding))
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - GenderView
    struct GenderView: View {
        @ObservedObject var viewModel: ChooseGenderViewModel
        
        var body: some View {
            ForEach(viewModel.genders, id: \.self) { gender in
                Group {
                    switch gender {
                    case .male:
                        Text("Nam")
                    case .female:
                        Text("Nữ")
                    case .others:
                        Text("Khác")
                    }
                }
                .modifier(CommonStyle())
                .if(viewModel.isSelectedGender(gender)) { view in
                    view
                        .modifier(SelectedTag())
                }
                .if(!viewModel.isSelectedGender(gender)) { view in
                    view
                        .modifier(NonSelectedTag())
                }
                .padding(.bottom, 20)
                .onTapGesture {
                    viewModel.selectedGender = gender
                }
            }
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
    
    // MARK: - ContinueButton
    struct ContinueButton: View {
        @ObservedObject var viewModel: ChooseGenderViewModel
        
        var body: some View {
            PushingButtonWhenTrue($viewModel.isUpdateGenderSuccess, destinationView: UpdateFirstImageView()) {
                viewModel.updateGender()
            } label: {
                Text("Tiếp tục")
                    .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.white100.color)
                    .padding(8)
                    .frame(width: UIScreen.screenWidth - K.Constants.ScreenPadding * 2, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color(Asset.Colors.Global.redD41717.color))
                            .shadow(color: Color(Asset.Colors.Global.redD41717.color).opacity(0.25), radius: 2, x: 0, y: 0)
                    )
            }
        }
    }
}

struct ChooseGenderView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGenderView()
    }
}
