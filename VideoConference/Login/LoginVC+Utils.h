//
//  LoginVC+Utils.h
//  VideoConference
//
//  Created by ADMIN on 2020/12/10.
//  Copyright © 2020 agora. All rights reserved.
//

#import "LoginVC.h"
#import <AgoraRoom/AgoraRoom.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginVC (Utils)

+ (NSString *)signalImageName:(NetworkGrade)grade;
+ (NSString *)checkInputWithUserName:(NSString *)userName
                             roomPsd:(NSString *)roomPsd
                            roomName:(NSString *)roomName;
+ (void)saveEntryParamas:(ConferenceEntryParams *)params;


@end

NS_ASSUME_NONNULL_END
