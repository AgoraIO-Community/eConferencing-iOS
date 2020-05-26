//
//  PIPVideoCell.m
//  VideoConference
//
//  Created by SRS on 2020/5/15.
//  Copyright © 2020 agora. All rights reserved.
//

#import "PIPVideoCell.h"
#import "UIImage+Circle.h"
#import "EEWhiteboardTool.h"
#import "EEColorShowView.h"
#import "ScaleView.h"

@interface PIPVideoCell ()<WhiteToolDelegate>

@property (weak, nonatomic) IBOutlet ScaleView *remoteView;
@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (weak, nonatomic) IBOutlet EEWhiteboardTool *whiteboardTool;
@property (weak, nonatomic) IBOutlet EEColorShowView *whiteboardColor;

@end

@implementation PIPVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = [UIImage generateImageWithSize:CGSizeMake(32, 32)];
    image = [UIImage circleImageWithOriginalImage:image];
    self.imgView.image = image;
    
    UIView *boardView = [WhiteManager createWhiteBoardView];
    boardView.hidden = YES;
    [self.shareView addSubview:boardView];
    [boardView equalTo:self.shareView];
    self.boardView = boardView;
    
    self.whiteboardTool.backgroundColor = UIColor.clearColor;
    [self.whiteboardTool setDirectionPortrait: NO];
    self.whiteboardTool.delegate = self;
    
    [self.whiteboardColor setSelectColor:^(NSString * _Nullable colorString) {
        NSArray *colorArray = [UIColor convertColorToRGB:[UIColor colorWithHexString:colorString]];
        [AgoraRoomManager.shareManager.whiteManager setWhiteStrokeColor:colorArray];
    }];
    
    self.showWhite = NO;
    self.showScreen = NO;
}

- (void)removeVideoCanvas {
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    [manager removeVideoCanvasWithView:self.localView];
    [manager removeVideoCanvasWithView:self.remoteView];
    [manager removeVideoCanvasWithView:self.shareView];
}

- (void)setUser:(ConfUserModel *)userModel shareBoardModel:(ConfShareBoardUserModel *)boardModel {
    
    [self removeVideoCanvas];
    
    self.showWhite = NO;
    self.showScreen = YES;
    
    self.shareView.hidden = NO;
    self.boardView.hidden = NO;
    self.remoteView.hidden = YES;
    self.imgView.hidden = YES;
    self.whiteboardTool.hidden = YES;
    self.whiteboardColor.hidden = YES;
    
    if(boardModel.uid == userModel.uid) {
        self.applyBtn.hidden = YES;
        self.endBtn.hidden = NO;
        self.whiteboardTool.hidden = NO;
    } else {
        // has apply
        if(userModel.grantBoard) {
            self.whiteboardTool.hidden = NO;
            self.applyBtn.hidden = YES;
            self.endBtn.hidden = YES;
        } else {
            self.applyBtn.hidden = NO;
            self.endBtn.hidden = YES;
        }
    }
    
    [self updateWhiteView];
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    if(userModel.enableVideo) {
        self.localView.hidden = NO;
        [manager addVideoCanvasWithUId:userModel.uid inView:self.localView];
    } else {
        self.localView.hidden = YES;
    }
}

- (void)setUser:(ConfUserModel *)userModel shareScreenModel:(ConfShareScreenUserModel *)screenModel {
    [self removeVideoCanvas];
    
    self.showWhite = YES;
    self.showScreen = NO;
    
    self.shareView.hidden = NO;
    self.boardView.hidden = YES;
    self.remoteView.hidden = YES;
    self.imgView.hidden = YES;
    
    self.whiteboardTool.hidden = YES;
    self.whiteboardColor.hidden = YES;
    self.applyBtn.hidden = YES;
    self.endBtn.hidden = YES;
    
    [self updateWhiteView];
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    if(userModel.enableVideo) {
        self.localView.hidden = NO;
        [manager addVideoCanvasWithUId:userModel.uid inView:self.localView];
    } else {
        self.localView.hidden = YES;
    }
    
    [manager addVideoCanvasWithUId:screenModel.screenId inView:self.shareView];
}

- (void)setUser:(ConfUserModel *)userModel remoteUser:(ConfUserModel *)remoteUserModel {
    
    [self removeVideoCanvas];
    
    self.showWhite = YES;
    self.showScreen = YES;
    
    self.shareView.hidden = YES;
    self.boardView.hidden = YES;
    self.imgView.hidden = YES;
    
    self.whiteboardTool.hidden = YES;
    self.whiteboardColor.hidden = YES;
    self.applyBtn.hidden = YES;
    self.endBtn.hidden = YES;
    
    [self updateWhiteView];
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    if(userModel.enableVideo) {
        self.localView.hidden = NO;
        [manager addVideoCanvasWithUId:userModel.uid inView:self.localView];
    } else {
        self.localView.hidden = YES;
    }
    
    if(remoteUserModel.enableVideo) {
        self.imgView.hidden = YES;
        self.remoteView.hidden = NO;
        [manager addVideoCanvasWithUId:remoteUserModel.uid inView:self.remoteView];
    } else {
        self.imgView.hidden = NO;
        self.remoteView.hidden = YES;
    }
}

- (void)setOneUserModel:(ConfUserModel *)userModel {
    
    [self removeVideoCanvas];
    
    self.showWhite = YES;
    self.showScreen = YES;
    
    self.shareView.hidden = YES;
    self.localView.hidden = YES;
    
    self.whiteboardTool.hidden = YES;
    self.whiteboardColor.hidden = YES;
    self.applyBtn.hidden = YES;
    self.endBtn.hidden = YES;
    
    [self updateWhiteView];
    
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    if(userModel.enableVideo) {
        self.imgView.hidden = YES;
        self.remoteView.hidden = NO;
        [manager addVideoCanvasWithUId:userModel.uid inView:self.remoteView];
//        [manager addVideoCanvasWithUId:userModel.uid inView:self.remoteView.contentView];
    } else {
        self.imgView.hidden = NO;
        self.remoteView.hidden = YES;
    }
}

- (void)updateWhiteView {
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    if(NoNullString(manager.roomModel.createBoardUserId).integerValue == 0){
        self.whiteboardTool.hidden = YES;
        return;
    }
    
    self.whiteboardTool.hidden = manager.ownModel.grantBoard ? NO : YES;
    
    WhiteManager *whiteManager = AgoraRoomManager.shareManager.whiteManager;
    [whiteManager setWritable:manager.ownModel.grantBoard ? YES : NO  completionHandler:nil];
}

- (void)updateLocalView {
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    BOOL enableVideo = manager.ownModel.enableVideo;
    if(enableVideo) {
        self.localView.hidden = NO;
        [manager addVideoCanvasWithUId:manager.ownModel.uid inView:self.localView];
    } else {
        self.localView.hidden = YES;
        [manager removeVideoCanvasWithView:self.localView];
    }
}

- (IBAction)appleBoard:(id)sender {
    
    WEAK(self);
    ConferenceManager *manager = AgoraRoomManager.shareManager.conferenceManager;
    [manager p2pActionWithType:EnableSignalTypeGrantBoard actionType:P2PMessageTypeActionApply userId:manager.ownModel.userId completeSuccessBlock:^{
        
    } completeFailBlock:^(NSError * _Nonnull error) {
        [weakself showMsgToast:error.localizedDescription];
    }];
}

- (IBAction)endBoard:(id)sender {
}

- (void)showMsgToast:(NSString *)title {
    UIViewController *vc = [VCManager getTopVC];
    if (vc != nil && title != nil && title.length > 0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc.view makeToast:title];
        });
    }
}

#pragma mark WhiteToolDelegate
- (void)selectWhiteTool:(ToolType)index {
    
    NSArray<NSString *> *applianceNameArray = @[WhiteApplianceSelector, WhiteAppliancePencil, WhiteApplianceText, WhiteApplianceEraser];
    if(index < applianceNameArray.count) {
        NSString *applianceName = [applianceNameArray objectAtIndex:index];
        if(applianceName != nil) {
            WhiteManager *manager = AgoraRoomManager.shareManager.whiteManager;
            [manager setWhiteApplianceName:applianceName];
        }
    }
    
    BOOL bHidden = self.whiteboardColor.hidden;
    // select color
    if (index == 4) {
        self.whiteboardColor.hidden = !bHidden;
    } else if (!bHidden) {
        self.whiteboardColor.hidden = YES;
    }
}

@end
