//
//  SignupCalendar.swift
//  DatingApp
//
//  Created by Radley Hoang on 14/11/2021.
//

import SwiftUI

struct SignupCalendar: View {
    private var date = Date()
    @State private var selectedDate = Date()
    var onChange: ((Date) -> Void)?
    
    init(_ date: Date) {
        self.date = date
    }
    
    var body: some View {
        let width = UIScreen.screenWidth - K.Constants.ScreenPadding * 2
        let navHeight: CGFloat = 50
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Image(Asset.Global.icDefaultClose.name)
                    .renderingMode(.template)
                    .foregroundColor(Color(Asset.Colors.Global.white100.color))
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        onChange?(date)
                    }
                Text("Chọn ngày")
                    .style(font: .lexendMedium, size: 20, color: Asset.Colors.Global.white100.color)
                Spacer()
                Text("Xong")
                    .style(font: .lexendRegular, size: 18, color: Asset.Colors.Global.white100.color)
                    .frame(height: navHeight)
                    .onTapGesture {
                        onChange?(selectedDate)
                    }
            }
            .padding([.trailing, .leading], 8)
            .frame(height: navHeight)
            .background(Color(Asset.Colors.Global.redD41717.name))
            
            HStack {
                Spacer()
                DatePicker("",
                           selection: $selectedDate,
                           displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .accentColor(Color(Asset.Colors.Global.redD41717.name))
                    .environment(\.locale, Locale.init(identifier: "vi"))
                    .padding(.top, 20)
                    .frame(height: width - navHeight)
                    .onChange(of: selectedDate) { newValue in
                        selectedDate = newValue
                    }
                Spacer()
            }
            
        }
        .background(Color.white)
        .frame(width: width, height: width)
        .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
        .onAppear {
            selectedDate = date
        }
    }
    
    func callback(perform action: @escaping (Date) -> Void ) -> Self {
        var copy = self
        copy.onChange = action
        return copy
    }
}

struct SignupCalendar_Previews: PreviewProvider {
    static var previews: some View {
        SignupCalendar(Date())
    }
}
