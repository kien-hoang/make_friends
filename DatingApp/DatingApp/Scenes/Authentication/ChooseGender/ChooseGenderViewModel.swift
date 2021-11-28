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
    func updateGender() {
        guard let selectedGender = selectedGender else {
            Helper.showProgressError("Vui lòng chọn giới tính")
            return
        }
        
        Helper.showProgress()
        UserAPIManager.shared.updateGender(selectedGender) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                Helper.showSuccess("Chọn giới tính thành công")
                self.isUpdateGenderSuccess = true
            }
        }
    }
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
