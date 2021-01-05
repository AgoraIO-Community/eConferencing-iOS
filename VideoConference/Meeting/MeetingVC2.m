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

@interface MeetingVC2 ()<UICollectionViewDelegate, UICollectionViewDataSource, MeetingViewDelegate>

@property (nonatomic, strong)MeetingView *mainView;

@end

@implementation MeetingVC2

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mainView = [MeetingView new];
    self.view = _mainView;
    [self setup];
}

- (void)setup
{
    _mainView.collectionView.delegate = self;
    _mainView.collectionView.dataSource = self;
    _mainView.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [_mainView.collectionView registerNib:nib forCellWithReuseIdentifier:@"VideoCell"];
}

#pragma UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.collectionViewLayout == _mainView.layoutAudio) {
        return [_mainView.layoutAudio numberOfItemsInSection:section itemsCount:16];
    }
    else {
        return [_mainView.layoutVideo numberOfItemsInSection:section itemsCount:20];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.collectionViewLayout == _mainView.layoutAudio) {
        return [_mainView.layoutAudio numberOfSectionsInItemsCount:16];
    }
    else {
        return [_mainView.layoutVideo numberOfSectionsInItemsCount:20];
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell"
                                                                forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [VideoCell instanceFromNib];
    }
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainView setMode:MeetingViewModeAudioFlow];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return _mainView.layoutVideo == collectionViewLayout ? [_mainView.layoutVideo minimumLineSpacingForSectionAtIndex:section] : [_mainView.layoutAudio minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _mainView.layoutVideo == collectionViewLayout ? [_mainView.layoutVideo minimumInteritemSpacingForSectionAtIndex:section] : [_mainView.layoutAudio minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _mainView.layoutVideo == collectionViewLayout ? [_mainView.layoutVideo collectionView:collectionView sizeForItemAtIndexPath:indexPath] : [_mainView.layoutAudio collectionView:collectionView sizeForItemAtIndexPath:indexPath];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionViewLayout == _mainView.layoutVideo) { return [_mainView.layoutVideo insetForSectionAtIndex:section]; }
    return [_mainView.layoutAudio insetForSectionAtIndex:section];
}

#pragma MeetingViewDelegate

- (void)meetingViewDidTapExitSpeakeButton:(MeetingView *)view
{
    MeetingViewMode mode = [view getMode] == MeetingViewModeVideoFlow ? MeetingViewModeSpeaker : MeetingViewModeVideoFlow;
    [view setMode:mode];
}

@end
