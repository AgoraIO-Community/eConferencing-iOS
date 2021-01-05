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
#import "MeetingFlowLayoutVideo.h"
#import "MeetingFlowLayoutAudio.h"
#import "PageCtrlView.h"
#import "MeetingViewDelegate.h"

@interface MeetingView ()

@property (nonatomic, assign)MeetingViewMode mode;
@property (nonatomic, strong)PageCtrlView *pageCtrlView;

@end

@implementation MeetingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self layout];
        [self setMode:MeetingViewModeSpeaker];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = UIColor.redColor;
    _topView = [MeetingTopView instanceFromNib];
    _bottomView = [MeetingBottomView instanceFromNib];

    _layoutVideo = [MeetingFlowLayoutVideo new];
    _layoutVideo.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layoutAudio = [MeetingFlowLayoutAudio new];
    _layoutAudio.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layoutVideo];
    _collectionView.backgroundColor = [UIColor redColor];
    [_collectionView setPagingEnabled:true];
    _collectionView.showsHorizontalScrollIndicator = false;
    
    _videoScrollView = [VideoScrollView new];
    
    _speakerView = [SpeakerView new];
    _pageCtrlView = [PageCtrlView instanceFromNib];
    
    [self addSubview:_collectionView];
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    [self addSubview:_videoScrollView];
    [self addSubview:_speakerView];
    [self addSubview:_pageCtrlView];
    
    [_speakerView.rightButton addTarget:self
                                 action:@selector(didTapRightButton)
                       forControlEvents:UIControlEventTouchUpInside];
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
    
    _pageCtrlView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_pageCtrlView.widthAnchor constraintEqualToConstant:60],
        [_pageCtrlView.heightAnchor constraintEqualToConstant:20],
        [_pageCtrlView.bottomAnchor constraintEqualToAnchor:_collectionView.bottomAnchor constant:-26],
        [_pageCtrlView.centerXAnchor constraintEqualToAnchor:_collectionView.centerXAnchor]
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
            UIEdgeInsets contentInset  = [_layoutVideo collectionViewContentInsets];
            [_collectionView setContentInset:contentInset];
            [_collectionView setHidden:false];
            [_collectionView setCollectionViewLayout:_layoutVideo animated:true];
            break;
        case MeetingViewModeAudioFlow:
            [_videoScrollView setHidden:true];
            [_speakerView setHidden:true];
            contentInset  = [_layoutAudio collectionViewContentInsets];
            [_collectionView setContentInset:contentInset];
            [_collectionView setHidden:false];
            [_collectionView setCollectionViewLayout:_layoutAudio animated:true];
            [_collectionView reloadData];
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

- (MeetingViewMode)getMode
{
    return _mode;
}

#pragma Atcion
- (void)didTapRightButton
{
    if ([self.delegate respondsToSelector:@selector(meetingViewDidTapExitSpeakeButton:)])
    {
        [_delegate meetingViewDidTapExitSpeakeButton:self];
    }
}

@end
