//
//  SetVC.m
//  VideoConference
//
//  Created by ZYP on 2021/1/18.
//  Copyright © 2021 agora. All rights reserved.
//

#import "SetVC.h"
#import "SetImageCell.h"
#import "SetTextFieldCell.h"
#import "SetSwitchCell.h"
#import "SetCenterTextCell.h"
#import "SetLabelCell.h"

@interface SetVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableview;
@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:false animated:animated];
}

- (void)setup {
    self.title = @"设置";
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableview registerNib:[UINib nibWithNibName:SetImageCell.idf bundle:nil] forCellReuseIdentifier:SetImageCell.idf];
    [_tableview registerNib:[UINib nibWithNibName:SetTextFieldCell.idf bundle:nil] forCellReuseIdentifier:SetTextFieldCell.idf];
    [_tableview registerNib:[UINib nibWithNibName:SetSwitchCell.idf bundle:nil] forCellReuseIdentifier:SetSwitchCell.idf];
    [_tableview registerNib:[UINib nibWithNibName:SetCenterTextCell.idf bundle:nil] forCellReuseIdentifier:SetCenterTextCell.idf];
    [_tableview registerNib:[UINib nibWithNibName:SetLabelCell.idf bundle:nil] forCellReuseIdentifier:SetLabelCell.idf];
    [_tableview registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:_tableview];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0 || section == 1) { return 2; }
    else if(section == 2) { return 3; }
    else { return 1; }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        cell.textLabel.text = row == 0 ? @"房间名" : @"密码";
        cell.detailTextLabel.text = row == 0 ? @"待实现" : @"待实现";
        return cell;
    }
    else if(section == 1) {
        if(row == 0){
            SetImageCell *cell = [tableView dequeueReusableCellWithIdentifier:SetImageCell.idf];
            return cell;
        } else  {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = @"待实现";
            return cell;
        }
    }
    else if(section == 2) {
        SetSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SetSwitchCell.idf];
        if(row == 0){
            cell.tipText.text = @"摄像头";
            cell.switchBtn.on = true;
        } else if(row == 1) {
            cell.tipText.text = @"麦克风";
        } else if(row == 2) {
            cell.tipText.text = @"美颜（敬请期待）";
            cell.switchBtn.on = NO;
            cell.switchBtn.enabled = NO;
        }
        return cell;
    }
    else if(section == 3) {
        SetCenterTextCell *cell = [tableView dequeueReusableCellWithIdentifier:SetCenterTextCell.idf];
        cell.tipText.text = @"邀请他人入会";
        cell.tipText.textColor = [UIColor colorWithHexString:@"268CFF"];
        cell.loading.hidden = true;
        return cell;
    }
    else {
        SetCenterTextCell *cell = [tableView dequeueReusableCellWithIdentifier:SetCenterTextCell.idf];
        cell.tipText.text = @"上传日志";
        cell.tipText.textColor = [UIColor colorWithHexString:@"323C47"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
