//
//  MeetingTopViewDelegate.h
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeetingTopViewDelegate <NSObject>

@optional

- (void)MeetingTopViewDidTapCameraButton;
- (void)MeetingTopViewDidTapLeaveButton;

@end
