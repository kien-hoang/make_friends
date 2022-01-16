//
//  MessageMainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 01/01/2022.
//

import SwiftUI
import Combine

class MessageMainViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var showCancelButton: Bool = false
    @Published var matches: [Match] = []
    
    var cancellables = Set<AnyCancellable>()
    
//    private let joinRoomDG = DispatchGroup()
    
    init() {
        getListChat()
        
        // BUG: Neu socket bi disconnect se lam crash ham duoi. vi enter chi 1 lan nhung leave nhieu lan
//        joinRoomDG.enter()
//        NotificationCenter.default.publisher(for: .DidSocketConnectSuccess)
//            .sink(receiveValue: { [weak self] _ in
//                guard let self = self else { return }
//                self.joinRoomDG.leave()
//            })
//            .store(in: &cancellables)
//
//        joinRoomDG.notify(queue: .global(qos: .userInitiated)) {
//            SocketClientManager.shared.joinRoom(withMatchIds: self.matches.map({ $0.id }))
//        }
    }
}

// MARK: - Helper
extension MessageMainViewModel {
    func getListChat() {
        Helper.showProgress()
//        joinRoomDG.enter()
        ChatAPIManager.shared.getListChat { [weak self] listChat, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let matches = listChat {
                self.matches = matches
//                self.joinRoomDG.leave()
                SocketClientManager.shared.joinRoom(withMatchIds: self.matches.map({ $0.id }))
            }
        }
    }
    
    func searchChat() {
        
    }
}
