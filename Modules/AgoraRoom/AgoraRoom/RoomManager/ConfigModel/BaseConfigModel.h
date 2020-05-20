//
//  BaseConfigModel.h
//  AgoraRoom
//
//  Created by SRS on 2020/5/19.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiLanguageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseConfigModel : NSObject

@property (nonatomic, copy) MultiLanguageModel *multiLanguage;

@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* userToken;

@property (nonatomic, copy) NSString* roomId;
@property (nonatomic, copy) NSString* appId;
@property (nonatomic, assign) NSInteger uid;//rtm&rtc
@property (nonatomic, copy) NSString* channelName;

@property (nonatomic, copy) NSString* rtcToken;
@property (nonatomic, copy) NSString* rtmToken;
@property (nonatomic, copy) NSString* boardId;
@property (nonatomic, copy) NSString* boardToken;

@end

NS_ASSUME_NONNULL_END
