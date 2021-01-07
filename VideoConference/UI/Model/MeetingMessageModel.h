//
//  MessageInfo.h
//  VideoConference
//
//  Created by ZYP on 2021/1/6.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingMessageModel : NSObject

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *info;
/** 是否显示按钮 **/
@property (nonatomic, assign)BOOL showButton;
/** 剩余时间 **/
@property (nonatomic, assign)NSUInteger remianCount;

@end

NS_ASSUME_NONNULL_END
