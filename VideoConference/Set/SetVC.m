//
//  SetVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/8.
//  Copyright © 2020 agora. All rights reserved.
//

#import "SetVC.h"
#import "SetSwitchCell.h"
#import "SetLabelCell.h"
#import "SetCenterTextCell.h"
#import "SetImageCell.h"
#import "SetTextFieldCell.h"
#import "CommonNavigation.h"
#import "UserDefaults.h"
#import "AgoraRoomManager.h"

@interface SetVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CommonNavigation *nav;

@property (weak, nonatomic) SetTextFieldCell *nameCell;

@property (nonatomic, assign) BOOL isUploading;

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isMemberSet) {
        self.nav.title.text = @"成员设置";
    } else {
        self.nav.title.text = @"设置";
        WEAK(self);
        self.nav.backBlock = ^(){
            [UserDefaults setUserName:weakself.nameCell.textField.text];
            [VCManager popTopView];
        };
    }

    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetSwitchCell" bundle:nil] forCellReuseIdentifier:@"SetSwitchCell"];
    if(!self.isMemberSet) {
        [self.tableView registerNib:[UINib nibWithNibName:@"SetLabelCell" bundle:nil] forCellReuseIdentifier:@"SetLabelCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"SetCenterTextCell" bundle:nil] forCellReuseIdentifier:@"SetCenterTextCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"SetImageCell" bundle:nil] forCellReuseIdentifier:@"SetImageCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"SetTextFieldCell" bundle:nil] forCellReuseIdentifier:@"SetTextFieldCell"];
    }
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if(self.isMemberSet) {
        return [self roomMediaCell:indexPath.row];
    }
    
    if(self.inMeeting) {
        if(indexPath.section == 0){
            
            SetLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetLabelCell"];
            cell.tipText.text = indexPath.row == 0 ? @"房间名" : @"密码";
            cell.valueText.text = @"";
            return cell;
        } else if(indexPath.section == 1){
            return [self userInfoCell:indexPath.row];
        } else if(indexPath.section == 2){
            return [self userMediaCell:indexPath.row];
        } else if(indexPath.section == 3){
            return [self invitationCell:indexPath.row];
        } else {
           return [self updloadCell:indexPath.row];
        }
    } else {
        if(indexPath.section == 0){
            UITableViewCell *cell = [self userInfoCell:indexPath.row];
            cell.selectionStyle = NO;
            return cell;
        } else if(indexPath.section == 1){
            return [self userMediaCell:indexPath.row];
        } else {
           return [self updloadCell:indexPath.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.inMeeting) {
        if(indexPath.section == 3){
            // invitation
        } else if(indexPath.section == 4){
            // upload log
            [self uploadLog:indexPath];
        }
    } else {
        if(indexPath.section == 2) {
            [self uploadLog:indexPath];
        }
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.isMemberSet) {
        return 2;
    }
    
    if(self.inMeeting) {
        if(section == 0){
            return 2;
        } else if(section == 1){
            return 2;
        } else if(section == 2){
            return 3;
        }
        return 1;
    } else {
        if(section == 0){
            return 2;
        } else if(section == 1){
            return 3;
        }
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.isMemberSet) {
        return 1;
    }
    
    if(self.inMeeting) {
        return 5;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark generate cell
- (UITableViewCell *)userInfoCell:(NSInteger)row {
    if(row == 0){
        SetImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetImageCell"];
        return cell;
    } else {
        SetTextFieldCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetTextFieldCell"];
        cell.tipText.text = @"姓名";
        cell.textField.text = [UserDefaults getUserName];
        self.nameCell = cell;
        return cell;
    }
}

- (UITableViewCell *)userMediaCell:(NSInteger)row {
    SetSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetSwitchCell"];
    if(row == 0){
        cell.tipText.text = @"摄像头";
        cell.switchBtn.on = [UserDefaults getOpenCamera];
        cell.block = ^(BOOL on) {
            [UserDefaults setOpenCamera:on];
        };
    } else if(row == 1) {
        cell.tipText.text = @"麦克风";
        cell.switchBtn.on = [UserDefaults getOpenMic];
        cell.block = ^(BOOL on) {
            [UserDefaults setOpenMic:on];
        };
    } else if(row == 2) {
        cell.tipText.text = @"美颜（敬请期待）";
        cell.switchBtn.on = NO;
        cell.switchBtn.enabled = NO;
    }
    return cell;
}

- (UITableViewCell *)roomMediaCell:(NSInteger)row {
    SetSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetSwitchCell"];
    if(row == 0){
        cell.tipText.text = @"全体静音";
//        cell.switchBtn.on = [UserDefaults getOpenCamera];
        cell.block = ^(BOOL on) {

        };
    } else if(row == 1) {
        cell.tipText.text = @"允许成员自我解除静音";
//        cell.switchBtn.on = [UserDefaults getOpenMic];
        cell.block = ^(BOOL on) {

        };
    }
    return cell;
}

- (UITableViewCell *)invitationCell:(NSInteger)row {
    SetCenterTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetCenterTextCell"];
    cell.tipText.text = @"邀请他人入会";
    cell.tipText.textColor = [UIColor colorWithHexString:@"268CFF"];
    return cell;
}

- (UITableViewCell *)updloadCell:(NSInteger)row {
    SetCenterTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetCenterTextCell"];
    cell.tipText.text = @"上传日志";
    cell.tipText.textColor = [UIColor colorWithHexString:@"323C47"];
    return cell;
}

#pragma mark upload log
- (void)uploadLog:(NSIndexPath *)indexPath {
    if(self.isUploading) {
        return;
    }
    
    SetCenterTextCell *cell = (SetCenterTextCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.loading.hidden = NO;
    [cell.loading startAnimating];
    cell.tipText.hidden = YES;
    self.isUploading = YES;
    
    // upload log
    WEAK(self);
    [AgoraRoomManager.shareManager.conferenceManager uploadLogWithSuccessBlock:^(NSString * _Nonnull uploadSerialNumber) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.loading.hidden = YES;
            [cell.loading stopAnimating];
            cell.tipText.hidden = NO;
            weakself.isUploading = NO;
            
            [AlertViewUtil showAlertWithController:[VCManager getTopVC] title:NSLocalizedString(@"UploadLogSuccessText", nil) message:uploadSerialNumber cancelText:nil sureText:NSLocalizedString(@"OKText", nil) cancelHandler:nil sureHandler:nil];
        });
        
    } failBlock:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.loading.hidden = YES;
            [cell.loading stopAnimating];
            cell.tipText.hidden = NO;
            weakself.isUploading = NO;
            [weakself showToast:error.localizedDescription];
        });
    }];
}

@end
