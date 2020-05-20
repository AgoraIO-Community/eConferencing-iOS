//
//  MeetingVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/12.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingVC.h"
#import "PIPVideoCell.h"
#import "VideoCell.h"
#import "PaddingLabel.h"
#import "AgoraRoomManager.h"
#import "MeetingNavigation.h"
#import "BottomBar.h"

@interface MeetingVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *stateBg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *tipLabel;
@property (weak, nonatomic) IBOutlet MeetingNavigation *nav;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet BottomBar *bottomBar;

@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger userTotleCount;

//@property (assign, nonatomic) NSInteger unReadMsgCount;

@end

@implementation MeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initView];
    [self initData];
//    self get
}

- (void)initView {
    //    UICollectionView
    [self.collectionView registerNib:[UINib nibWithNibName:@"PIPVideoCell" bundle:nil] forCellWithReuseIdentifier:@"PIPVideoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCell"];
    
    self.stateBg.hidden = NO;
    self.stateBg.layer.cornerRadius = 11;
    self.stateBg.clipsToBounds = YES;
    
    self.tipLabel.hidden = NO;
    self.tipLabel.layer.cornerRadius = 11;
    self.tipLabel.clipsToBounds = YES;
    self.tipLabel.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tipLabel.text = @"撒第六 离开了房间";
}

- (void)initData {
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    self.nav.title.text = manager.roomModel.roomName;
    [self.nav startTimerWithCount: manager.roomModel.startTime];
    
    //    self.nameLabel.text = manager.roomModel.roomName;
//    ConfUserModel *firstHost = NoNullArray(manager.roomModel.hosts).firstObject;
//    if(firstHost != nil && !firstHost.enableAudio){
//        firstHost
//    }

    // bottom bar
    [self.bottomBar updateViewWithAudio:manager.ownModel.enableAudio video:manager.ownModel.enableVideo];
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if(section == 0){
        return 0;
    } else {
        return 3;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        PIPVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIPVideoCell" forIndexPath:indexPath];
        
        return cell;
    } else {
        VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
        
        return cell;
    }
}


- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    }
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = collectionView.bounds.size;
    if(indexPath.section == 0){
        return collectionView.bounds.size;
    }
    
    NSInteger width = (size.width - 3) * 0.5;
    NSInteger height = (size.height - 3) * 0.5;
    return CGSizeMake(width, height);
}

@end
