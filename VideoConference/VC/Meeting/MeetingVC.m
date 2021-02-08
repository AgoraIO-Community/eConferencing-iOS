//
//  MeetingVC2r.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingVC.h"
#import "MeetingView.h"
#import "VideoCell.h"
#import "MeetingFlowLayoutVideo.h"
#import "MeetingFlowLayoutAudio.h"
#import "MeetingViewDelegate.h"
#import "AudioCell.h"
#import "VideoScrollView.h"
#import "MessageView.h"
#import "MeetingMessageModel.h"
#import "MeetingTopView.h"
#import "MeetingTopViewDelegate.h"
#import "MeetingVM.h"
#import "MeetingBottomView.h"
#import "MemberVC.h"
#import "SetVC.h"
#import <AgoraRoom/AgoraRoom.h>

@interface MeetingVC ()<UICollectionViewDelegate, UICollectionViewDataSource, MeetingViewDelegate, MeetingTopViewDelegate, VideoCellDelegate, MeetingBottomViewDelegate, MeetingVMDelegate>

@property (nonatomic, strong)MeetingView *mainView;
@property (nonatomic, strong)MeetingVM *vm;

@end

@implementation MeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:animated];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)setup {
    _mainView = [MeetingView new];
    [_mainView setMode:MeetingViewModeVideoFlow];
    self.view = _mainView;
    
    _mainView.collectionView.delegate = self;
    _mainView.collectionView.dataSource = self;
    _mainView.delegate = self;
    _mainView.videoScrollView.collectionView.delegate = self;
    _mainView.videoScrollView.collectionView.dataSource = self;
    _mainView.topView.delegate = self;
    _mainView.bottomView.delegate = self;
    
    NSString *videoIdf = @"VideoCell";
    UINib *nib = [UINib nibWithNibName:videoIdf bundle:nil];
    [_mainView.collectionView registerNib:nib forCellWithReuseIdentifier:videoIdf];
    [_mainView.videoScrollView.collectionView registerNib:nib forCellWithReuseIdentifier:videoIdf];
    
    NSString *audioIdf = @"AudioCell";
    UINib *audioNib = [UINib nibWithNibName:audioIdf bundle:nil];
    [_mainView.collectionView registerNib:audioNib forCellWithReuseIdentifier:audioIdf];
    
    _vm = [MeetingVM new];
    _vm.delegate = self;
    [_vm start];
}

#pragma UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [_mainView setItemCount:13];
    return 13;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.collectionViewLayout == _mainView.layoutAudio) {
        AudioCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AudioCell"
                                                                    forIndexPath:indexPath];
        
        if (!cell)
        {
            cell = [AudioCell instanceFromNib];
        }
        return cell;
    }
    else {
        VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell"
                                                                    forIndexPath:indexPath];
        cell.delegate = self;
        if (!cell)
        {
            cell = [VideoCell instanceFromNib];
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)showMoreAlert {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"邀请" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"全员静音" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"全员摄像头关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"开始屏幕共享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"结束共享屏幕" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"发起白板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SetVC *vc = [SetVC new];
        [self.navigationController pushViewController:vc animated:true];
    }];
    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [vc addAction:action4];
    [vc addAction:action5];
    [vc addAction:action6];
    [vc addAction:action7];
    [vc addAction:action8];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma MeetingViewDelegate

- (void)meetingViewDidTapExitSpeakeButton:(MeetingView *)view {
    [view setMode:MeetingViewModeVideoFlow];
}

#pragma MeetingTopViewDelegate

- (void)MeetingTopViewDidTapLeaveButton {
    [self.vm leave];
}

#pragma VideoCellDelegate

- (void)videoCell:(VideoCell * _Nonnull)cell didTapType:(VideoCellTapType)type {
    NSLog(@"");
}

#pragma MeetingBottomViewDelegate

- (void)MeetingBottomViewDidTapButtonWithType:(MeetingBottomViewButtonType)type {
    if(type == MeetingBottomViewButtonTypeMember) {
        MemberVC *vc = [MemberVC new];
        [self.navigationController pushViewController:vc animated:true];
        return;
    }
    
    if(type == MeetingBottomViewButtonTypeMore) {
        [self showMoreAlert];
    }
}

#pragma MeetingVMDelegate

- (void)meetingVMDidLeaveRoom {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)meetingVMLeaveRoomErrorWithTips:(NSString *)tips {
    [self showToast:tips];
}

@end
