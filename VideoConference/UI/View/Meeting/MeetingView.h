//
//  MeetingView.h
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MeetingTopView, MeetingBottomView, VideoScrollView, SpeakerView, MeetingFlowLayout;

typedef NS_ENUM(NSUInteger, MeetingViewMode) {
    // 视频平铺模式
    MeetingViewModeVideoFlow,
    // 语音平铺模式
    MeetingViewModeAudioFlow,
    // 演讲者模式
    MeetingViewModeSpeaker,
};
NS_ASSUME_NONNULL_BEGIN

@interface MeetingView : UIView

@property (nonatomic, strong)MeetingTopView *topView;
@property (nonatomic, strong)MeetingBottomView *bottomView;
@property (nonatomic, strong)UIView *messageView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)VideoScrollView *videoScrollView;
@property (nonatomic, strong)SpeakerView *speakerView;
@property (nonatomic, strong)MeetingFlowLayout *layout1;

- (void)setMode:(MeetingViewMode)mode;

@end

NS_ASSUME_NONNULL_END
