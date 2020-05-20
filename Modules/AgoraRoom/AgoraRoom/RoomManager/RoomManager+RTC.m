//
//  RoomManager+RTC.m
//  AgoraEdu
//
//  Created by SRS on 2020/5/5.
//  Copyright © 2020 agora. All rights reserved.
//

#import "RoomManager+RTC.h"
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
#import "RoomManagerDelegate.h"
#import <YYModel.h>

@implementation RoomManager (RTC)
- (void)rtcDidJoinedOfUid:(NSUInteger)uid {
    if(self.hostModel && uid == self.hostModel.screenId) {
        if([self.delegate respondsToSelector:@selector(didReceivedSignal:)]) {
            
            SignalShareScreenInfoModel *model = [SignalShareScreenInfoModel new];
            model.type = 1;
            model.screenId = uid;
            model.userId = self.hostModel.userId;
            self.shareScreenInfoModel = model;
    
            SignalInfoModel *signalInfoModel = [SignalInfoModel new];
            signalInfoModel.signalType = SignalValueShareScreen;
            [self.delegate didReceivedSignal:signalInfoModel];
        }
    }
}

- (void)rtcDidOfflineOfUid:(NSUInteger)uid {
    if(self.hostModel && uid == self.hostModel.screenId) {
        if([self.delegate respondsToSelector:@selector(didReceivedSignal:)]) {
            
            SignalShareScreenInfoModel *model = [SignalShareScreenInfoModel new];
            model.type = 0;
            model.screenId = uid;
            model.userId = self.hostModel.userId;
            self.shareScreenInfoModel = model;
    
            SignalInfoModel *signalInfoModel = [SignalInfoModel new];
            signalInfoModel.signalType = SignalValueShareScreen;
            [self.delegate didReceivedSignal:signalInfoModel];
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine networkQuality:(NSUInteger)uid txQuality:(AgoraNetworkQuality)txQuality rxQuality:(AgoraNetworkQuality)rxQuality {
    
    RTCNetworkGrade grade = RTCNetworkGradeUnknown;
    
    AgoraNetworkQuality quality = MAX(txQuality, rxQuality);
    switch (quality) {
        case AgoraNetworkQualityExcellent:
        case AgoraNetworkQualityGood:
            grade = RTCNetworkGradeHigh;
            break;
        case AgoraNetworkQualityPoor:
        case AgoraNetworkQualityBad:
            grade = RTCNetworkGradeMiddle;
            break;
        case AgoraNetworkQualityVBad:
        case AgoraNetworkQualityDown:
            grade = RTCNetworkGradeLow;
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(networkTypeGrade:uid:)]) {
        [self.delegate networkTypeGrade:grade uid: uid];
    }
}
@end
