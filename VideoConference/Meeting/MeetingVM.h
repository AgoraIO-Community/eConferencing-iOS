//
//  MeetingVM.h
//  VideoConference
//
//  Created by ZYP on 2021/1/12.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingVM : NSObject

- (void)start;
- (void)openVideoTrack;
- (void)closeVideoTrack;
- (void)openAudioTrack;
- (void)closeAudioTrack;

@end

NS_ASSUME_NONNULL_END
