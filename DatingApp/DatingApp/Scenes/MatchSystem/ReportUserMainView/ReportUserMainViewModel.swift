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
    
    private var reportedUserId: String
    
    init(reportedUserId: String) {
        self.reportedUserId = reportedUserId
    }
}

// MARK: - Helper
extension ReportUserMainViewModel {
    func reportUser(withReason reason: String) {
        Helper.showProgress()
        UserAPIManager.shared.reportUser(withUserId: reportedUserId) { [weak self] isSuccess, error in
            Helper.dismissProgress()
            guard let _ = self else { return }
            if let error = error {
                Helper.showProgressError(error.localizedDescription)
            } else if isSuccess {
                NotificationCenter.default.post(name: .DidReportUserSuccess, object: nil)
            }
        }
    }
}
