//
//  MeetingView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingView.h"
#import "MeetingTopView.h"
#import "MeetingBottomView.h"
#import "UIScreen+Extension.h"
#import "VideoScrollView.h"
#import "SpeakerView.h"
#import "MeetingFlowLayoutVideo.h"
#import "MeetingFlowLayoutAudio.h"
#import "PageCtrlView.h"
#import "MeetingViewDelegate.h"
#import "MeetingFlowLayoutVideoScroll.h"
#import "MessageView.h"
#import "UIColor+AppColor.h"

@interface MeetingView (){
    NSLayoutConstraint *_messageViewBottomConstraint;
}

@property (nonatomic, assign)MeetingViewMode mode;
@property (nonatomic, strong)PageCtrlView *pageCtrlView;
@property (nonatomic, assign)NSUInteger itemCount;

@end

static const CGFloat MessageViewBottomConstantHeigh = -165;
static const CGFloat MessageViewBottomConstantLow = -35;

@implementation MeetingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
        [self layout];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = UIColor.redColor;
    _topView = [MeetingTopView instanceFromNib];
    _bottomView = [MeetingBottomView instanceFromNib];

    _layoutVideo = [MeetingFlowLayoutVideo new];
    _layoutAudio = [MeetingFlowLayoutAudio new];
    _layoutVideoScroll = [MeetingFlowLayoutVideoScroll new];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layoutVideo];
    _collectionView.backgroundColor = UIColor.redColor;
    [_collectionView setPagingEnabled:true];
    _collectionView.showsHorizontalScrollIndicator = false;

    _videoScrollView = [VideoScrollView new];
    [_videoScrollView.collectionView setCollectionViewLayout:_layoutVideoScroll];
    [_videoScrollView.collectionView setPagingEnabled:true];
    _videoScrollView.collectionView.showsHorizontalScrollIndicator = false;
    
    _speakerView = [SpeakerView new];
    _pageCtrlView = [PageCtrlView instanceFromNib];
    
    _messageView = [MessageView new];
    
    [self addSubview:_collectionView];
    [self addSubview:_topView];
    [self addSubview:_bottomView];
    [self addSubview:_speakerView];
    [self addSubview:_pageCtrlView];
    [self addSubview:_videoScrollView];
    [self addSubview:_messageView];
    
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
        [_pageCtrlView.widthAnchor constraintEqualToConstant:80],
        [_pageCtrlView.heightAnchor constraintEqualToConstant:20],
        [_pageCtrlView.bottomAnchor constraintEqualToAnchor:_collectionView.bottomAnchor constant:-15],
        [_pageCtrlView.centerXAnchor constraintEqualToAnchor:_collectionView.centerXAnchor]
    ]];
    
    _speakerView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_speakerView.topAnchor constraintEqualToAnchor:_topView.bottomAnchor],
        [_speakerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_speakerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_speakerView.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor]
    ]];
    
    _videoScrollView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [_videoScrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [_videoScrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [_videoScrollView.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor],
        [_videoScrollView.heightAnchor constraintEqualToConstant:160]
    ]];
    
    _messageView.translatesAutoresizingMaskIntoConstraints = false;
    _messageViewBottomConstraint = [_messageView.bottomAnchor constraintEqualToAnchor:_videoScrollView.bottomAnchor constant:MessageViewBottomConstantLow];
    [NSLayoutConstraint activateConstraints:@[
        [_messageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
        [_messageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
        _messageViewBottomConstraint,
        [_messageView.heightAnchor constraintEqualToConstant:147]
    ]];
    
}

- (void)setMode:(MeetingViewMode)mode
{
    _mode = mode;
    
    switch (_mode) {
        case MeetingViewModeVideoFlow:
            {
                [self->_videoScrollView setHidden:true];
                [self->_speakerView setHidden:true];
                [self->_collectionView setHidden:false];
                [self->_collectionView setCollectionViewLayout:self->_layoutVideo animated:false];
                [self->_collectionView reloadData];
                [self->_collectionView setContentOffset:CGPointZero animated:false];
                [self layoutIfNeeded];
                _messageViewBottomConstraint.constant = MessageViewBottomConstantLow;
                [UIView animateWithDuration:0.25 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            break;
        case MeetingViewModeAudioFlow:
            {
                [self->_videoScrollView setHidden:true];
                [self->_speakerView setHidden:true];
                [self->_collectionView setHidden:false];
                [self->_collectionView setCollectionViewLayout:self->_layoutAudio animated:false];
                [self->_collectionView reloadData];
                [self->_collectionView setContentOffset:CGPointZero animated:false];
                [self layoutIfNeeded];
                _messageViewBottomConstraint.constant = MessageViewBottomConstantLow;
                [UIView animateWithDuration:0.25 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            break;
        case MeetingViewModeSpeaker:
            {
                [self->_videoScrollView setHidden:false];
                [self->_speakerView setHidden:false];
                [self->_collectionView setHidden:true];
                [self layoutIfNeeded];
                _messageViewBottomConstraint.constant = MessageViewBottomConstantHeigh;
                [UIView animateWithDuration:0.25 animations:^{
                    [self layoutIfNeeded];
                }];
            }
            break;
        default:
            break;
    }
}

- (MeetingViewMode)getMode
{
    return _mode;
}

- (void)setItemCount:(NSUInteger)itemCount
{
    _itemCount = itemCount;
    MeetingViewMode mode = [self getMode];
    double count = (double) itemCount;
    if (mode == MeetingViewModeVideoFlow)
    {
        NSInteger pages = ceil(count/4);
        [_pageCtrlView setcCurrentPage:0 andNumberOfPage:pages];
        return;
    }
    if (mode == MeetingViewModeAudioFlow)
    {
        NSInteger pages = ceil(count/15);
        [_pageCtrlView setcCurrentPage:0 andNumberOfPage:pages];
        return;
    }
    if (mode == MeetingViewModeSpeaker)
    {
        NSInteger pages = ceil(count/4);
        [_pageCtrlView setcCurrentPage:0 andNumberOfPage:pages];
        return;
    }
}

- (void)setCurrentPageWithItemIndex:(NSInteger)itemIndex
{
    MeetingViewMode mode = [self getMode];
    NSInteger numberOfPage = mode == MeetingViewModeAudioFlow ? 15 : 4;
    double count = (double) _itemCount;
    NSInteger pages = ceil(count/numberOfPage);
    double index = (double) itemIndex;
    NSInteger currentPage  = index/numberOfPage;
    [_pageCtrlView setcCurrentPage:currentPage andNumberOfPage:pages];
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
