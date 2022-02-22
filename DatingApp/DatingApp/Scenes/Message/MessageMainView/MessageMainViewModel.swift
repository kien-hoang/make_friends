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
    @Published var renderMatches: [Match] = [] // FIXME: MessageMainViewModel.1
    var matches: [Match] = []
    @Published var isShowReportPopup: Bool = false
    @Published var isShowReportAlert = false
    @Published var selectedMatch: Match?
    
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
    func getReportedUserId() -> String {
        guard let selectedMatch = selectedMatch,
              let receiver = selectedMatch.members.first(where: { $0.id != AppData.shared.user.id }) else { return "" }
        
        return receiver.id
    }
    
    func unmatchUser() {
        guard let selectedMatch = selectedMatch else { return }
        Helper.showProgress()
        ChatAPIManager.shared.unmatchUser(withMatchId: selectedMatch.id) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                if let firstIndex = self.matches.firstIndex(where: { $0.id == selectedMatch.id }) {
                    self.renderMatches.remove(at: firstIndex)
                    self.matches.remove(at: firstIndex)
                    Helper.showSuccess("Huỷ kết nối thành công")
                }
            }
        }
    }
    
    func updateLastMessage(_ match: Match) {
        guard let firstIndex = matches.firstIndex(where: { $0.id == match.id }) else { return }
        matches[firstIndex].isRead = match.isRead
        matches[firstIndex].lastMessage = match.lastMessage
    }
    
    func getListChat() {
        Helper.showProgress()
//        joinRoomDG.enter()
        ChatAPIManager.shared.getListChat { [weak self] listChat, error in
            Helper.dismissProgress()
            guard let self = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if let matches = listChat {
                self.renderMatches = matches
                self.matches = matches
//                self.joinRoomDG.leave()
                SocketClientManager.shared.joinRoom(withMatchIds: self.matches.map({ $0.id }))
            }
        }
    }
    
    func searchChat() {
        
    }
}

// FIXME: MessageMainViewModel.1
/*
 @Published var matches: [Match] = []
 When only use 1 line code above. When send a message. State of ObserverObject will be updated and NavigationStack will pop current view. That's mean when user in chat => Enter new message => App will pop to chat list immediately.
 
 => Temp resolve:
 Use 2 line code:
 @Published var renderMatches: [Match] = []
 var matches: [Match] = []
 */
