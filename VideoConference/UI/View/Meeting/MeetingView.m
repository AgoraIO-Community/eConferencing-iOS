//
//  MeetingView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingView.h"
#import "MeetingTopView.h"
#import "AgoraFlowLayout.h"
#import "MeetingBottomView.h"
#import "UIScreen+Extension.h"
#import "VideoScrollView.h"
#import "SpeakerView.h"
#import "MeetingFlowLayout.h"

@interface MeetingView ()

@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, assign)MeetingViewMode mode;

@end

@implementation MeetingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self layout];
        [self setMode:MeetingViewModeVideoFlow];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    _topView = [MeetingTopView instanceFromNib];
    _bottomView = [MeetingBottomView instanceFromNib];

    _layout1 = [MeetingFlowLayout new];
    _layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout1];
    _collectionView.backgroundColor = [UIColor redColor];
    [_collectionView setPagingEnabled:true];
    _collectionView.showsHorizontalScrollIndicator = false;
    
    _videoScrollView = [VideoScrollView new];
    
    _speakerView = [SpeakerView new];
    
    [self addSubview:_collectionView];
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    [self addSubview:_videoScrollView];
    [self addSubview:_speakerView];
}

- (void)layout
{
    _topView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_topView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [_topView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_topView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_topView.heightAnchor constraintEqualToConstant:44+UIScreen.statusBarHeight]
    ]];
    
    _bottomView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_bottomView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [_bottomView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor ],
        [_bottomView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_bottomView.heightAnchor constraintEqualToConstant:55+UIScreen.bottomSafeAreaHeight]
    ]];
    
    _collectionView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_collectionView.topAnchor constraintEqualToAnchor:_topView.bottomAnchor],
        [_collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_collectionView.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor]
    ]];
    
    _speakerView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_speakerView.topAnchor constraintEqualToAnchor:_topView.bottomAnchor],
        [_speakerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_speakerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_speakerView.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor]
    ]];
    
    [_videoScrollView setBackgroundColor:UIColor.greenColor];
    _videoScrollView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_videoScrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_videoScrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_videoScrollView.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor],
        [_videoScrollView.heightAnchor constraintEqualToConstant:108]
    ]];
    
}

- (void)setMode:(MeetingViewMode)mode
{
    _mode = mode;
    
    switch (_mode) {
        case MeetingViewModeVideoFlow:
            [_videoScrollView setHidden:true];
            [_speakerView setHidden:true];
            [_collectionView setHidden:false];
            break;
        case MeetingViewModeAudioFlow:
            [_videoScrollView setHidden:true];
            [_speakerView setHidden:true];
            [_collectionView setHidden:false];
            break;
        case MeetingViewModeSpeaker:
            [_videoScrollView setHidden:false];
            [_speakerView setHidden:false];
            [_collectionView setHidden:true];
            break;
        default:
            break;
    }
}

@end
