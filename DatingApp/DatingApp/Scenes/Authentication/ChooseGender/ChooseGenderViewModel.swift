//
//  ChooseGenderViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 26/11/2021.
//

import SwiftUI

class ChooseGenderViewModel: ObservableObject {
    @Published var isUpdateGenderSuccess = false
    @Published var selectedGender: UserGender? = nil
    
    var genders: [UserGender] = [.male, .female, .others]
}

// MARK: - API
extension ChooseGenderViewModel {
    
}

// MARK: - Helper
extension ChooseGenderViewModel {
    func isSelectedGender(_ gender: UserGender) -> Bool {
        guard let selectedGender = selectedGender else {
            return false
        }

        return gender == selectedGender
    }
}
