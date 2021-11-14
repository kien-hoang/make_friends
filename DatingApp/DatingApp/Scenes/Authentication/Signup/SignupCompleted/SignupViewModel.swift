//
//  SignupViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 14/11/2021.
//

import SwiftUI

class SignupViewModel: ObservableObject {
    @Published var phone: String = ""
    @Published var password: String = ""
    @Published var isShowPassword: Bool = false
    @Published var confirmPassword: String = ""
    @Published var isShowConfirmPassword: Bool = false
    @Published var name: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var dateOfBirthString: String = ""
    @Published var isShowCalendar: Bool = false
    @Published var email: String = ""
    
    init() {
        
    }
    
    func completedSignup() {
        print("DEBUG:")
        print(phone)
        print(password)
        print(confirmPassword)
        print(name)
        print(dateOfBirth)
        print(email)
    }
}
