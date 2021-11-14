//
//  SignupCalendar.swift
//  DatingApp
//
//  Created by Radley Hoang on 14/11/2021.
//

import SwiftUI

struct SignupCalendar: View {
    @State private var date = Date()
    var onChange: ((Date) -> Void)?
    
    init(selectedDate: Date) {
        self.date = selectedDate
    }
    
    var body: some View {
            VStack {
                let width = UIScreen.screenWidth - K.Constants.ScreenPadding * 2
                DatePicker("",
                           selection: $date,
                           displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding([.top, .trailing, .leading], 8)
                    .frame(width: width, height: width)
                    .onChange(of: date) { newValue in
                        onChange?(newValue)
                    }
            }
            .background(Color.white)
            .cornerRadius(32)
            .shadow(color: Color(Asset.Colors.Global.black100.color).opacity(0.25), radius: 4, x: 0, y: 0)
    }
    
    func callback(perform action: @escaping (Date) -> Void ) -> Self {
        var copy = self
        copy.onChange = action
        return copy
    }
}

struct SignupCalendar_Previews: PreviewProvider {
    static var previews: some View {
        SignupCalendar(selectedDate: Date())
            
    }
}
