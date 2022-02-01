//
//  ReportUserMainViewModel.swift
//  DatingApp
//
//  Created by Radley Hoang on 31/01/2022.
//

import SwiftUI

class ReportUserMainViewModel: ObservableObject {
    var reportReasons: [String] = ["Hồ sơ giả mạo / Spam",
                                   "Tin nhắn không phù hợp",
                                   "Ảnh hồ sơ không phù hợp",
                                   "Tiểu sử không phù hợp",
                                   "Người dùng chưa đủ tuổi",
                                   "Hành vi ngoại tuyến",
                                   "Người dùng đang gặp nguy hiểm"]
    
    @Published var isShowReportAlert = false
    @Published var selectedReasonIndex: Int = 0
}

// MARK: - Helper
extension ReportUserMainViewModel {
    func reportUser(withReason reason: String) {
        NotificationCenter.default.post(name: .DidReportUserSuccess, object: nil)
    }
}
