//
//  MeetingVMDelegate.h
//  VideoConference
//
//  Created by ZYP on 2021/2/8.
//  Copyright © 2021 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MeetingVMDelegate_h
#define MeetingVMDelegate_h

@protocol MeetingVMDelegate <NSObject>

- (void)meetingVMDidLeaveRoom;
- (void)meetingVMLeaveRoomErrorWithTips:(NSString *)tips;

@end


#endif /* MeetingVMDelegate_h */
