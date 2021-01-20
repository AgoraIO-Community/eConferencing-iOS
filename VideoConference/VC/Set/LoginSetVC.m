//
//  LoginSetVC.m
//  VideoConference
//
//  Created by ZYP on 2021/1/15.
//  Copyright © 2021 agora. All rights reserved.
//

#import "LoginSetVC.h"
#import "SetImageCell.h"
#import "SetTextFieldCell.h"
#import "SetSwitchCell.h"
#import "SetCenterTextCell.h"

@interface LoginSetVC ()<UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation LoginSetVC

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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [_tableView registerNib:[UINib nibWithNibName:SetImageCell.idf bundle:nil] forCellReuseIdentifier:SetImageCell.idf];
    [_tableView registerNib:[UINib nibWithNibName:SetTextFieldCell.idf bundle:nil] forCellReuseIdentifier:SetTextFieldCell.idf];
    [_tableView registerNib:[UINib nibWithNibName:SetSwitchCell.idf bundle:nil] forCellReuseIdentifier:SetSwitchCell.idf];
    [_tableView registerNib:[UINib nibWithNibName:SetCenterTextCell.idf bundle:nil] forCellReuseIdentifier:SetCenterTextCell.idf];
    
    _tableView.dataSource = self;
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:_tableView];
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) { return 2; }
    else if(section == 1) { return 3; }
    else { return 1; }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if(section == 0) {
        if(row == 0) {
            return [tableView dequeueReusableCellWithIdentifier:SetImageCell.idf];
        }
        else {
            SetTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:SetTextFieldCell.idf];
            cell.tipText.text = @"姓名";
            cell.textField.text = @"待实现";
            cell.textField.enabled = true;
            return cell;
        }
    }
    else if(section == 1) {
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
    else {
        SetCenterTextCell *cell = [tableView dequeueReusableCellWithIdentifier:SetCenterTextCell.idf];
        cell.tipText.text = @"上传日志";
        cell.tipText.textColor = [UIColor colorWithHexString:@"323C47"];
        return cell;
    }
    
    return [UITableViewCell new];
}

@end
