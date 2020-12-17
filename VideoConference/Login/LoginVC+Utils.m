//
//  LoginVC+Utils.m
//  VideoConference
//
//  Created by ADMIN on 2020/12/10.
//  Copyright © 2020 agora. All rights reserved.
//

#import "LoginVC+Utils.h"
#import <AgoraRoom/AgoraRoom.h>
#import <Foundation/Foundation.h>
#import "UserDefaults.h"

@implementation LoginVC (Utils)

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

+ (void)saveEntryParamas:(ConferenceEntryParams *)params {
    [UserDefaults setUserName: params.userName];
    [UserDefaults setOpenCamera: params.enableVideo];
    [UserDefaults setOpenMic: params.enableAudio];
}

@end
