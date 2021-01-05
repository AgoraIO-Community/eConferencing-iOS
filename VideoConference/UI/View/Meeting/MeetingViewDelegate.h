//
//  MeetingViewDelegate.h
//  VideoConference
//
//  Created by ZYP on 2021/1/4.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MeetingView;

@protocol MeetingViewDelegate <NSObject>

// 点击退出演讲者模式按钮
- (void)meetingViewDidTapExitSpeakeButton:(MeetingView *)view;

@end

NS_ASSUME_NONNULL_END
