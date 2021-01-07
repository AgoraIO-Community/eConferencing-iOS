//
//  MeetingVC2r.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingVC2.h"
#import "MeetingView.h"
#import "VideoCell.h"
#import "MeetingFlowLayoutVideo.h"
#import "MeetingFlowLayoutAudio.h"
#import "MeetingViewDelegate.h"
#import "AudioCell.h"
#import "VideoScrollView.h"
#import "MessageView.h"
#import "MeetingMessageModel.h"

@interface MeetingVC2 ()<UICollectionViewDelegate, UICollectionViewDataSource, MeetingViewDelegate>

@property (nonatomic, strong)MeetingView *mainView;

@end

@implementation MeetingVC2

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mainView = [MeetingView new];
    [_mainView setMode:MeetingViewModeVideoFlow];
    self.view = _mainView;
    [self setup];
}

- (void)setup
{
    
    _mainView.collectionView.delegate = self;
    _mainView.collectionView.dataSource = self;
    _mainView.delegate = self;
    _mainView.videoScrollView.collectionView.delegate = self;
    _mainView.videoScrollView.collectionView.dataSource = self;
    
    NSString *videoIdf = @"VideoCell";
    UINib *nib = [UINib nibWithNibName:videoIdf bundle:nil];
    [_mainView.collectionView registerNib:nib forCellWithReuseIdentifier:videoIdf];
    [_mainView.videoScrollView.collectionView registerNib:nib forCellWithReuseIdentifier:videoIdf];
    
    NSString *audioIdf = @"AudioCell";
    UINib *audioNib = [UINib nibWithNibName:audioIdf bundle:nil];
    [_mainView.collectionView registerNib:audioNib forCellWithReuseIdentifier:audioIdf];
}

#pragma UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [_mainView setItemCount:13];
    return 13;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.collectionViewLayout == _mainView.layoutAudio)
    {
        AudioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AudioCell"
                                                                    forIndexPath:indexPath];
        
        if (!cell)
        {
            cell = [AudioCell instanceFromNib];
        }
        return cell;
    }
    else
    {
        VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell"
                                                                    forIndexPath:indexPath];
        
        if (!cell)
        {
            cell = [VideoCell instanceFromNib];
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainView setMode:MeetingViewModeSpeaker];
    [_mainView setItemCount:13];
    
    MeetingMessageModel *model = [MeetingMessageModel new];
    model.name = [NSString stringWithFormat:@"XXX%ld", indexPath.row];
    model.info = [NSString stringWithFormat:@"YYYYYYY%ld", indexPath.row];
    model.remianCount = 0;
    model.showButton = true;
    [_mainView.messageView addModel:model];
}

#pragma mark scrollViewDidScroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndScroll];
    });
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndScroll];
    });
}
- (void)scrollViewDidEndScroll {
    
    UICollectionView *collectionView = [_mainView getMode] == MeetingViewModeSpeaker ? _mainView.videoScrollView.collectionView : _mainView.collectionView;
    NSArray *indexPaths = [collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPaths.firstObject;
    NSInteger index = indexPath.row + 1;
    [_mainView setCurrentPageWithItemIndex:index];
}


#pragma MeetingViewDelegate

- (void)meetingViewDidTapExitSpeakeButton:(MeetingView *)view
{
    [view setMode:MeetingViewModeVideoFlow];
}

@end
