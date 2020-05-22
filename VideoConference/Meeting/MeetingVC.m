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
#import "AgoraFlowLayout.h"

@interface MeetingVC ()<UICollectionViewDelegate, UICollectionViewDataSource, WhiteManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *stateBg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet PaddingLabel *tipLabel;
@property (weak, nonatomic) IBOutlet MeetingNavigation *nav;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet BottomBar *bottomBar;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) AgoraFlowLayout *layout;

//@property (assign, nonatomic) NSInteger unReadMsgCount;
@property (strong, nonatomic) NSMutableArray<ConfUserModel *> *allUserListModel;

@property (strong, nonatomic) WhiteInfoModel *whiteInfoModel;
@property (weak, nonatomic) PIPVideoCell *pipVideoCell;

@end

@implementation MeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allUserListModel = [NSMutableArray array];
   
    [self initView];
    [self initData];
    [self addNotification];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupWhiteBoard];
    });
    
    [self startDispatchGroup];
}

- (void)setupWhiteBoard {

    WhiteManager *whiteManager = AgoraRoomManager.shareManager.whiteManager;
    [whiteManager initWhiteSDK:self.pipVideoCell.boardView dataSourceDelegate:self];
    
    WEAK(self);
    ConferenceManager *conferenceManager = AgoraRoomManager.shareManager.conferenceManager;
    ConfShareBoardUserModel *shareBoardModel = NoNullArray(conferenceManager.roomModel.shareBoardUsers).firstObject;

    [conferenceManager getWhiteInfoWithSuccessBlock:^(WhiteInfoModel * _Nonnull model) {
        [whiteManager joinWhiteRoomWithBoardId:model.boardId boardToken:model.boardToken whiteWriteModel:conferenceManager.ownModel.grantBoard completeSuccessBlock:^{
            
            if(shareBoardModel != nil && shareBoardModel.uid == conferenceManager.ownModel.uid){
                [whiteManager disableCameraTransform:NO];
            } else {
                [whiteManager disableCameraTransform:YES];
            }
            
            [whiteManager disableWhiteDeviceInputs:!conferenceManager.ownModel.grantBoard];
            [whiteManager currentWhiteScene:^(NSInteger sceneCount, NSInteger sceneIndex) {
                [whiteManager moveWhiteToContainer:sceneIndex];
            }];
            
        } completeFailBlock:^(NSError * _Nullable error) {
            [weakself showToast:error.localizedDescription];
        }];
    } failBlock:^(NSError * _Nonnull error) {
        [weakself showToast:error.localizedDescription];
    }];
}

- (void)startDispatchGroup {
    
    WEAK(self);
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    
    dispatch_group_t group = dispatch_group_create();
    __block NSString *errMsg = @"";
    
    // init media
    dispatch_group_enter(group);
    ClientRole clientRole = manager.ownModel.enableVideo ? ClientRoleBroadcaster : ClientRoleAudience;
    [manager initMediaWithClientRole:clientRole successBolck:^{
        dispatch_group_leave(group);
    } failBlock:^(NSInteger errorCode) {
        errMsg = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"JoinMediaFailedText", nil), (long)errorCode];
        dispatch_group_leave(group);
    }];
    
    // get totle users
    dispatch_group_enter(group);
    [manager getUserListWithSuccessBlock:^{
        weakself.allUserListModel = [NSMutableArray arrayWithArray:manager.userListModels];
        dispatch_group_leave(group);
    } failBlock:^(NSError * _Nonnull error) {
        errMsg = error.localizedDescription;
        dispatch_group_leave(group);
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if(errMsg != nil && errMsg.length > 0) {
            [self showToast:errMsg];
        } else {
            ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
            NSInteger shareScreenCount = manager.roomModel.shareScreenUsers.count;
            NSInteger shareBoardCount = manager.roomModel.shareBoardUsers.count;
            NSInteger allUserCount = self.allUserListModel.count;
            NSInteger count = shareScreenCount + shareBoardCount + allUserCount - 2;
            if(count <= 0) {
                self.pageControl.hidden = YES;
            } else {
                self.pageControl.hidden = NO;
                self.pageControl.currentPage = 0;
                self.pageControl.numberOfPages = 1 + count / 4 + (count % 4 == 0 ? 0 : 1);
            }

            [self.collectionView reloadData];
        }
    });
}

- (void)initView {
    //    UICollectionView
    [self.collectionView registerNib:[UINib nibWithNibName:@"PIPVideoCell" bundle:nil] forCellWithReuseIdentifier:@"PIPVideoCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCell"];
    
    AgoraFlowLayout *layout = [AgoraFlowLayout new];
    layout = [AgoraFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemCountPerRow = 2;
    layout.rowCount = 2;
    [self.collectionView setCollectionViewLayout:layout];
    self.layout = layout;
    
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
    [self.bottomBar updateView];
    
    [self.allUserListModel addObject:manager.ownModel];
    [self.allUserListModel addObjectsFromArray:manager.roomModel.hosts];
    [self.collectionView  reloadData];
}

- (void)addNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onLocalVideoStateChange) name:NOTICENAME_LOCAL_VIDEO_CHANGED object:nil];
}

- (void)onLocalVideoStateChange {
    [self.pipVideoCell updateLocalView];
    [self.bottomBar updateView];
}

#pragma mark UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    NSInteger count = self.allUserListModel.count + manager.roomModel.shareScreenUsers.count + manager.roomModel.shareBoardUsers.count - 2;
    if(self.allUserListModel.count == 0) {
        return 0;
    } else if(count <= 0) {
        return 1;
    }
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self.layout minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self.layout minimumInteritemSpacingForSectionAtIndex:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    NSInteger shareScreenCount = manager.roomModel.shareScreenUsers.count;
    NSInteger shareBoardCount = manager.roomModel.shareBoardUsers.count;
    NSInteger allUserCount = self.allUserListModel.count;
    
    if(indexPath.section == 0) {
        PIPVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PIPVideoCell" forIndexPath:indexPath];
        NSInteger count = shareScreenCount + shareBoardCount + allUserCount;
        
        // only self
        ConfUserModel *selfModel = self.allUserListModel.firstObject;
        if(count == 1) {
            [cell setOneUserModel:selfModel];
        } else {
            if(shareScreenCount > 0) {
                ConfShareScreenUserModel *remoteModel = manager.roomModel.shareScreenUsers.firstObject;
                [cell setUser:selfModel shareScreenModel:remoteModel];
                
            } else if(shareBoardCount > 0) {
                ConfShareBoardUserModel *remoteModel = manager.roomModel.shareBoardUsers.firstObject;
                [cell setUser:selfModel shareBoardModel:remoteModel];
            } else {
                ConfUserModel *remoteModel = self.allUserListModel[1];
                [cell setUser:selfModel remoteUser:remoteModel];
            }
        }
        self.pipVideoCell = cell;
        return cell;
    } else {
        VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
        if(shareScreenCount > indexPath.row + 1) {
            ConfShareScreenUserModel *model = manager.roomModel.shareScreenUsers[indexPath.row + 1];
            [cell setShareScreenModel:model];
            
        } else if(shareBoardCount > indexPath.row + 1 - shareScreenCount) {
            ConfShareBoardUserModel *model = manager.roomModel.shareBoardUsers[indexPath.row + 1 - shareScreenCount];
            [cell setShareBoardModel:model];
        } else if(allUserCount > indexPath.row + 2 - shareScreenCount - shareBoardCount) {
            ConfUserModel *model = self.allUserListModel[indexPath.row + 2 - shareScreenCount - shareBoardCount];
            [cell setUserModel:model];
        } else {
            [cell setUserModel:nil];
        }
        return cell;
    }
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    }
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    NSInteger count = self.allUserListModel.count + manager.roomModel.shareScreenUsers.count + manager.roomModel.shareBoardUsers.count - 2;
    if(count % 4 == 0){
        return count;
    } else {
        return count + 4 - count % 4;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.layout collectionView:collectionView sizeForItemAtIndexPath:indexPath];
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
   NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPaths.firstObject;
    if(self.pageControl.numberOfPages > 0) {
        if(indexPath.section == 0) {
            self.pageControl.currentPage = 0;
        } else {
            NSInteger index = indexPath.row + 1;
            self.pageControl.currentPage = index / 4 + (index % 4 == 0 ? 0 : 1);
        }
    }
}

#pragma mark WhitePlayDelegate
- (void)whiteRoomStateChanged {
    [AgoraRoomManager.shareManager.whiteManager currentWhiteScene:^(NSInteger sceneCount, NSInteger sceneIndex) {
        [AgoraRoomManager.shareManager.whiteManager moveWhiteToContainer:sceneIndex];
    }];
}
@end
