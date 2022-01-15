//
//  EditProfileView.swift
//  DatingApp
//
//  Created by Radley Hoang on 09/01/2022.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    @StateObject var viewModel = EditProfileViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(viewModel: viewModel)
            
            ScrollView {
                VStack(spacing: 0) {
                    PhotosView(viewModel: viewModel)
                        .padding(.top, 20)
                    
                    Text("Thêm ảnh để hoàn thành hồ sơ của bạn và bạn có thể được Yêu thích nhiều hơn")
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.gray9A9A9A.color)
                        .padding([.horizontal, .top], K.Constants.ScreenPadding)
                    
                    AboutMeView(viewModel: viewModel)
                        .padding(.top, 12)
                    
                    InterestedInView(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    GenderView(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    InterestedInGenderView(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    JobTitleView(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    SchoolView(viewModel: viewModel)
                        .padding(.top, 24)
                    
                    CompanyView(viewModel: viewModel)
                        .padding(.top, 24)
                }
            }
            Spacer()
        }
        .hiddenNavigationBar()
        .background(Color(Asset.Colors.Global.grayF2F2F7.color))
    }
    
    // MARK: - InterestedInView
    struct InterestedInView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            NavigationLink(destination: viewModel.getEditInterestedTagsView()) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("SỞ THÍCH")
                            .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                        Spacer()
                    }
                    .padding(.leading, K.Constants.ScreenPadding)
                    .padding(.bottom, 4)
                    
                    HStack {
                        Text(viewModel.interestedTagsString)
                            .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                            .padding(.horizontal, K.Constants.ScreenPadding)
                            .padding(.vertical, 4)
                            .frame(height: 40)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Image(Asset.Global.icDefaultNext.name)
                            .resizable()
                            .frame(width: 8, height: 12)
                            .padding(.trailing, K.Constants.ScreenPadding)
                    }
                    .frame(width: __SCREEN_WIDTH__, height: 40)
                    .background(Color(Asset.Colors.Global.white100.color))
                }
                .onReceive(.DidUpdateInterestedTagsSuccess) { notification in
                    guard let selectedInterestedTags = notification.object as? [InterestedTag] else { return }
                    viewModel.user.interestedTags = selectedInterestedTags
                    viewModel.getInterestedTagsString()
                }
            }
        }
    }
    
    // MARK: - InterestedInGenderView
    struct InterestedInGenderView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("XU HƯỚNG GIỚI TÍNH")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    Text(viewModel.getInterestedInGenderString())
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 40)
                    
                    Spacer()
                    
                    Image(Asset.Global.icDefaultNext.name)
                        .resizable()
                        .frame(width: 8, height: 12)
                        .padding(.trailing, K.Constants.ScreenPadding)
                }
                .frame(width: __SCREEN_WIDTH__, height: 40)
                .background(Color(Asset.Colors.Global.white100.color))
                .actionSheet(isPresented: $viewModel.isShowInterestedInGenderActionSheet) {
                    ActionSheet(title: Text("Chọn xu hướng giới tính"), buttons: [
                        .default(Text("Nam")) {
                            viewModel.user.dateMode = .male
                        },
                        .default(Text("Nữ")) {
                            viewModel.user.dateMode = .female
                        },
                        .default(Text("Khác")) {
                            viewModel.user.dateMode = .both
                        },
                        .cancel(Text("Huỷ bỏ"))
                    ])
                }
            }
            .onTapGesture {
                viewModel.isShowInterestedInGenderActionSheet = true
            }
        }
    }
    
    // MARK: - GenderView
    struct GenderView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("GIỚI TÍNH")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    Text(viewModel.getGenderString())
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 40)
                    
                    Spacer()
                    
                    Image(Asset.Global.icDefaultNext.name)
                        .resizable()
                        .frame(width: 8, height: 12)
                        .padding(.trailing, K.Constants.ScreenPadding)
                }
                .frame(width: __SCREEN_WIDTH__, height: 40)
                .background(Color(Asset.Colors.Global.white100.color))
                .actionSheet(isPresented: $viewModel.isShowGenderActionSheet) {
                    ActionSheet(title: Text("Chọn giới tính"), buttons: [
                        .default(Text("Nam")) {
                            viewModel.user.gender = .male
                        },
                        .default(Text("Nữ")) {
                            viewModel.user.gender = .female
                        },
                        .default(Text("Khác")) {
                            viewModel.user.gender = .others
                        },
                        .cancel(Text("Huỷ bỏ"))
                    ])
                }
            }
            .onTapGesture {
                viewModel.isShowGenderActionSheet = true
            }
        }
    }
    
    // MARK: - CompanyView
    struct CompanyView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("CÔNG TY")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    TextField("Thêm công ty", text: $viewModel.user.company)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 40)
                }
                .background(Color(Asset.Colors.Global.white100.color))
            }
        }
    }
    
    // MARK: - SchoolView
    struct SchoolView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("TRƯỜNG HỌC")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    TextField("Thêm trường học", text: $viewModel.user.school)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 40)
                }
                .background(Color(Asset.Colors.Global.white100.color))
            }
        }
    }
    
    // MARK: - JobTitleView
    struct JobTitleView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("NGHỀ NGHIỆP")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    TextField("Thêm nghề nghiệp", text: $viewModel.user.jobTitle)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 40)
                }
                .background(Color(Asset.Colors.Global.white100.color))
            }
        }
    }
    
    // MARK: - AboutMeView
    struct AboutMeView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("GIỚI THIỆU")
                        .style(font: .lexendMedium, size: 14, color: Asset.Colors.Global.black100.color)
                    Spacer()
                }
                .padding(.leading, K.Constants.ScreenPadding)
                .padding(.bottom, 4)
                
                HStack {
                    TextEditor(text: $viewModel.user.aboutMe)
                        .style(font: .lexendRegular, size: 12, color: Asset.Colors.Global.black100.color)
                        .padding(.horizontal, K.Constants.ScreenPadding)
                        .padding(.vertical, 4)
                        .frame(height: 72)
                }
                .background(Color(Asset.Colors.Global.white100.color))
            }
        }
    }
    
    // MARK: - PhotosView
    struct PhotosView: View {
        @ObservedObject var viewModel: EditProfileViewModel
        @State var itemWidth = (__SCREEN_WIDTH__ - K.Constants.ScreenPadding * 2) / 3
        
        let columns = [
            GridItem(.flexible(minimum: 100), spacing: 12),
            GridItem(.flexible(minimum: 100), spacing: 12),
            GridItem(.flexible(minimum: 100), spacing: 12),
        ]
        
        var body: some View {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.user.images, id: \.self) { imageUrl in
                    let cellViewModel = EditProfilePhotoCellViewModel(URL(string: imageUrl))
                    EditProfilePhotoCellView(cellViewModel: cellViewModel)
                        .aspectRatio(2 / 3, contentMode: .fill)
                }
                
                // More image item
                EditProfilePhotoCellView(cellViewModel: EditProfilePhotoCellViewModel(nil))
                    .aspectRatio(2 / 3, contentMode: .fill)
            }
            .padding(.horizontal, K.Constants.ScreenPadding)
        }
    }
    
    // MARK: - HeaderView
    struct HeaderView: View {
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @ObservedObject var viewModel: EditProfileViewModel
        
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
                Text("Thay đổi hồ sơ")
                    .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.black100.color)
                
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.updateProfile()
                    } label: {
                        Text("Xong")
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
            .onReceive(.DidUpdateProfileSuccess) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
