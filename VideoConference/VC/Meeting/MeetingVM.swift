//
//  MeetingVM2.swift
//  VideoConference
//
//  Created by ZYP on 2021/2/8.
//  Copyright © 2021 agora. All rights reserved.
//

import Foundation
import AgoraRoom
import AgoraRte

class MeetingVM: NSObject {
    weak var delegate: MeetingVMProtocol?
    let localUser = ARConferenceManager.getLocalUser()
    var videoTrack: AgoraRteCameraVideoTrack?
    var audioTrack: AgoraRteMicrophoneAudioTrack!
    let engine = ARConferenceManager.getRteEngine()
    let addRoomResp = ARConferenceManager.getAddRoomResp()
    
    override init() {
        super.init()
        setup()
    }
    
    func start() {
        let params = ARConferenceManager.getEntryParams()
        if params.enableVideo { openVideoTrack() }
        if params.enableAudio { openAudioTrack() }
    }
    
    func leave() {
        let params = ARConferenceManager.getEntryParams()
        let roomId = params.roomUuid
        let userId = params.userUuid
        HttpManager.requestLeaveRoom(withRoomId: roomId, userId: userId) {
            self.delegate?.meetingVMDidLeaveRoom()
        } faulure: { (error) in
            self.delegate?.meetingVMLeaveRoomErrorWithTips(tips: error.localizedDescription)
        }
    }
    
    deinit {
        engine.destroy()
    }
    
    func setup() {
        localUser.localUserDelegate = self
        localUser.mediaStreamDelegate = self
    }
    
    func openVideoTrack() {
        if videoTrack == nil {
            videoTrack = engine.getAgoraMediaControl().createCameraVideoTrack()
        }
    }
    
    func openAudioTrack() {
        if audioTrack == nil {
            audioTrack = engine.getAgoraMediaControl().createMicphoneAudioTrack()
        }
    }
    
    func closeVideoTrack() {
        videoTrack?.stop()
        videoTrack = nil
    }
    
    func closeAudioTrack() {
        audioTrack.stop()
        audioTrack = nil
    }
    
    func publishLocalMediaTrack() {
        localUser.publishLocalMediaTrack(videoTrack!, withStreamId: addRoomResp.streamId) {
            print("")
        } fail: { (error) in
            print("\(error)")
        }
    }
    
}

extension MeetingVM: AgoraRteLocalUserDelegate {
    
    func localUser(_ user: AgoraRteLocalUser, didUpdateLocalUserInfo userEvent: AgoraRteUserEvent) {
        
    }
    
    func localUser(_ user: AgoraRteLocalUser, didUpdateLocalUserProperties changedProperties: [String], remove: Bool, cause: String?) {
        
    }
    
    func localUser(_ user: AgoraRteLocalUser, didChangeOfLocalStream event: AgoraRteMediaStreamEvent, with action: AgoraRteMediaStreamAction) {
        print("")
    }
    
}

extension MeetingVM: AgoraRteMediaStreamDelegate {
    
    func localUser(_ user: AgoraRteLocalUser, didChangeOfLocalAudioStream streamId: String, with state: AgoraRteStreamState) {
        print("")
    }
    
    func localUser(_ user: AgoraRteLocalUser, didChangeOfLocalVideoStream streamId: String, with state: AgoraRteStreamState) {
        print("")
    }
    
    func localUser(_ user: AgoraRteLocalUser, didChangeOfRemoteAudioStream streamId: String, with state: AgoraRteStreamState) {
        
    }
    
    func localUser(_ user: AgoraRteLocalUser, didChangeOfRemoteVideoStream streamId: String, with state: AgoraRteStreamState) {
        
    }
    
    func localUser(_ user: AgoraRteLocalUser, audioVolumeIndicationOfStream streamId: String, withVolume volume: UInt) {
        
    }
    
}
