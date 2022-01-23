//
//  NewPasswordViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 23/01/2022.
//

import SwiftUI

class NewPasswordViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var isShowPassword: Bool = false
    @Published var confirmPassword: String = ""
    @Published var isShowConfirmPassword: Bool = false
}
