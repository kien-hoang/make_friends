//
//  EditProfilePhotoCellViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 15/01/2022.
//

import SwiftUI

enum EditProfilePhotoCellType {
    case EmptyCell
    case AlreadyImage(_ imageUrl: URL)
}

class EditProfilePhotoCellViewModel: ObservableObject {
    @Published var type: EditProfilePhotoCellType = .EmptyCell
    
    init(_ imageUrl: URL?) {
        if let imageUrl = imageUrl {
            type = .AlreadyImage(imageUrl)
        } else {
            type = .EmptyCell
        }
    }
    
    // MARK: - Helper
    func didTapCell() {
        switch type {
        case .EmptyCell:
            print("DEBUG: Add more item")
            
        case .AlreadyImage(let url):
            print("DEBUG: Tap \(url)")
        }
    }
}
