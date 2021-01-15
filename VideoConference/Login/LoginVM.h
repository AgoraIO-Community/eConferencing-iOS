//
//  LoginVM.h
//  VideoConference
//
//  Created by ADMIN on 2020/12/17.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRoom/AgoraRoom.h>
#import "LoginVMDelegate.h"
@class LoginInfo;

NS_ASSUME_NONNULL_BEGIN

@interface LoginVM : NSObject

@property (weak, nonatomic) id<NetworkDelegate> networkDelegate;
@property (weak, nonatomic) id<LoginVMDelegate> delegate;

+ (NSString *)signalImageName:(NetworkGrade)grade;
+ (NSString *)checkInputWithUserName:(NSString *)userName
                             roomPsd:(NSString *)roomPsd
                            roomName:(NSString *)roomName;
- (void)entryRoom:(LoginInfo *)info;
+ (void)saveEntryParamas:(ARConferenceEntryParams *)params;

/// start for network test
- (void)startNetworkTest;

@end

NS_ASSUME_NONNULL_END
