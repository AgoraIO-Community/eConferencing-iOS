//
//  LoginInfo.h
//  VideoConference
//
//  Created by ZYP on 2021/1/8.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginInfo : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) BOOL enableVideo;
@property (nonatomic, assign) BOOL enableAudio;

@end

NS_ASSUME_NONNULL_END
