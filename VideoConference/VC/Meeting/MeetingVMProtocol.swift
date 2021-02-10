//
//  MeetingVMProtocol.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/9.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation

protocol MeetingVMProtocol: NSObject {
    func meetingVMDidLeaveRoom()
    func meetingVMLeaveRoomErrorWithTips(tips: String)
}
