//
//  LoginVM.m
//  VideoConference
//
//  Created by ADMIN on 2020/12/17.
//  Copyright © 2020 agora. All rights reserved.
//

#import "LoginVM.h"
#import <AgoraRoom/AgoraRoom.h>
#import <Foundation/Foundation.h>
#import "UserDefaults.h"
#import "AgoraRoomManager.h"
#import "LoginVMDelegate.h"
#import "LoginInfo.h"
#import "KeyCenter.h"

@interface LoginVM ()



@end

@implementation LoginVM

- (instancetype)init {
    self = [super init];
    if (self) {
//        _cm = ARConferenceManager.
    }
    return self;
}

+ (NSString *)signalImageName:(NetworkGrade)grade {
    NSString *imgName = @"signal_unknown";
    switch (grade) {
        case NetworkGradeLow:
            imgName = @"signal_bad";
            break;
        case NetworkGradeMiddle:
            imgName = @"signal_poor";
            break;
        case NetworkGradeHigh:
            imgName = @"signal_good";
            break;
        default:
            break;
    }
    return  imgName;
}

+ (NSString *)checkInputWithUserName:(NSString *)userName
                             roomPsd:(NSString *)roomPsd
                            roomName:(NSString *)roomName {
    if (userName.length <= 0 || roomName.length <= 0) {
        return NSLocalizedString(@"UserNameVerifyEmptyText", nil);
    }
    NSInteger strlength = [self checkFieldText:roomName];
    if(strlength < 3){
        return NSLocalizedString(@"RoomNameMinVerifyText", nil);
    }
    if(strlength > 50){
        return NSLocalizedString(@"RoomNameMaxVerifyText", nil);
    }
    strlength = [self checkFieldText:userName];
    if(strlength < 3){
        return NSLocalizedString(@"UserNameMinVerifyText", nil);
    }
    if(strlength > 20){
        return NSLocalizedString(@"UserNameMaxVerifyText", nil);
        
    }
    strlength = [self checkFieldText:roomPsd];
    if(strlength > 20){
        return NSLocalizedString(@"PsdMaxVerifyText", nil);
    }
    return nil;
}

+ (NSInteger)checkFieldText:(NSString *)text {
    int strlength = 0;
    char *p = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (void)saveEntryParamas:(ARConferenceEntryParams *)params {
    [UserDefaults setUserName: params.userName];
    [UserDefaults setOpenCamera: params.enableVideo];
    [UserDefaults setOpenMic: params.enableAudio];
}

/// start for network test
- (void)startNetworkTest {
//    WEAK(self);
//    [_cm netWorkProbeTestCompleteBlock:^(NetworkGrade grade) {
//        if (weakself.networkDelegate != nil &&
//            [weakself.networkDelegate respondsToSelector:@selector(networkImageNameDidChange:)]) {
//            NSString *imgName = [LoginVM signalImageName:grade];
//            [weakself.networkDelegate networkImageNameDidChange:imgName];
//        }
//    }];
}

- (void)entryRoom:(LoginInfo *)info {
    ARConferenceEntryParams *params = [ARConferenceEntryParams new];
    params.userName = info.userName;
    params.roomName = info.roomName;
    params.enableAudio = info.enableAudio;
    params.enableVideo = info.enableVideo;
    params.userUuid = info.userName;
    params.roomUuid = info.roomName;
    params.appId = [KeyCenter agoraAppid];
    params.customerId = [KeyCenter customerId];
    params.customerCertificate = [KeyCenter customerCertificate];
    params.avatar = @"";
    params.logFilePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask,
                                                             true).firstObject;
    params.logPrintType = ARConsolePrintTypeError;
    
    [ARConferenceManager entryRoomWithParams:params successBlock:^{
        [LoginVM saveEntryParamas:params];
        if (self.delegate && [self.delegate respondsToSelector:@selector(LoginVMDidEndEntryRoomWithError:)]) {
            [self.delegate LoginVMDidEndEntryRoomWithError:nil];
        }
    } failBlock:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LoginVMDidEndEntryRoomWithError:)]) {
            [self.delegate LoginVMDidEndEntryRoomWithError:error];
        }
    }];
}

@end
