//
//  RoomManagerDelegate.h
//  AgoraEdu
//
//  Created by SRS on 2020/5/5.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalP2PModel.h"
#import "SignalInfoModel.h"
#import "MessageModel.h"

typedef NS_ENUM(NSInteger, ConnectionState) {
    ConnectionStateReconnected,
    ConnectionStateReconnecting,
    ConnectionStateDisconnected,
    ConnectionStateAnotherLogged,
};

/** Network type. */
typedef NS_ENUM(NSInteger, RTCNetworkGrade) {
    RTCNetworkGradeUnknown = -1,
    RTCNetworkGradeHigh = 1,
    RTCNetworkGradeMiddle = 2,
    RTCNetworkGradeLow = 3,
};


NS_ASSUME_NONNULL_BEGIN

@protocol RoomManagerDelegate <NSObject>

@optional
- (void)didReceivedPeerSignal:(SignalP2PInfoModel * _Nonnull)model;
- (void)didReceivedSignal:(SignalInfoModel *)signalInfoModel;
- (void)didReceivedMessage:(MessageInfoModel * _Nonnull)model;
- (void)didReceivedConnectionStateChanged:(ConnectionState)state;

- (void)networkTypeGrade:(RTCNetworkGrade)grade uid:(NSInteger)uid;

@end

NS_ASSUME_NONNULL_END
