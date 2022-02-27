//
//  ReportUserPopupView.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/01/2022.
//

import SwiftUI

struct ReportUserMainView: View {
    @StateObject var viewModel: ReportUserMainViewModel
    @Binding var isShowPopup: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel, isShowPopup: $isShowPopup)
            
            HStack {
                Text("Hãy chọn vấn đề")
                    .style(font: .lexendMedium, size: 16, color: Asset.Colors.Global.gray777777.color)
                    .padding(.vertical, 8)
                    .padding(.horizontal, K.Constants.ScreenPadding)
                
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ReasonListView(viewModel: viewModel)
                        .padding(.top, 16)
                }
            }
            Spacer()
        }
        .hiddenNavigationBar()
        .setBackgroundColor(K.Constants.DefaultColor)
    }
    
    // MARK: - ReasonListView
    struct ReasonListView: View {
        @ObservedObject var viewModel: ReportUserMainViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(viewModel.reportReasons.indices, id: \.self) { reasonIndex in
                    Rectangle()
                        .fill(Color(Asset.Colors.Global.grayF2F2F7.color))
                        .frame(height: 1)
                    
                    HStack {
                        Text(viewModel.reportReasons[reasonIndex])
                            .style(font: .lexendRegular, size: 14, color: Asset.Colors.Global.black100.color)
                        Spacer()
                            
                        Image(Asset.Global.icDefaultNext.name)
                            .resizable()
                            .frame(width: 8, height: 12)
                    }
                    .frame(height: 45)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectedReasonIndex = reasonIndex
                        viewModel.isShowReportAlert = true
                    }
                    .alert(isPresented: $viewModel.isShowReportAlert) {
                        Alert(
                            title: Text(viewModel.reportReasons[viewModel.selectedReasonIndex]),
                            message: Text("Bạn có chắc muốn báo cáo vấn đề này hay không?"),
                            primaryButton: .default (Text("Có")) {
                                viewModel.reportUser(withReason: viewModel.reportReasons[viewModel.selectedReasonIndex])
                            },
                            secondaryButton: .cancel(Text("Không"))
                        )
                    }
                }
            }
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
    }
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @ObservedObject var viewModel: ReportUserMainViewModel
        @Binding var isShowPopup: Bool
        
        var body: some View {
            ZStack {
                HStack {
                    Button {
                        isShowPopup = false
                    } label: {
                        Image(Asset.Global.icDefaultBack.name)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 9)
                            .padding(.trailing, 12)
                    }
                    .frame(maxHeight: .infinity)
                    
                    Spacer()
                }
                Text("Báo cáo")
                    .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.black100.color)
            }
            .frame(height: 44)
            .background(
                Color(Asset.Colors.Global.white100.color)// any non-transparent background
                    .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
                    .mask(Rectangle().padding(.bottom, -20)) // shadow only bottom side
            )
        }
    }
}

struct ReportUserPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ReportUserMainView(viewModel: ReportUserMainViewModel(reportedUserId: ""), isShowPopup: Binding.constant(true))
    }
}
