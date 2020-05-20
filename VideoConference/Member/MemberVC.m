//
//  MemberVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/8.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MemberVC.h"
#import "CommonNavigation.h"
#import "UserCell.h"
#import "MessageVC.h"
#import "SetVC.h"
#import "ShareLinkView.h"

@interface MemberVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CommonNavigation *nav;
@property (weak, nonatomic) ShareLinkView *shareLinkView;
@end


@implementation MemberVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nav.title.text = @"成员（3）";
    self.nav.rightBtn.hidden = NO;
    [self.nav.rightBtn setImage:[UIImage imageNamed:@"set-icon"] forState:UIControlStateNormal];
    self.nav.rightBlock = ^(){
        SetVC *vc = [[SetVC alloc] initWithNibName:@"SetVC" bundle:nil];
        vc.isMemberSet = YES;
        [VCManager pushToVC:vc];
    };

    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserCell" bundle:nil] forCellReuseIdentifier:@"UserCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (IBAction)onClickInvitation:(id)sender {
    
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ShareLinkView" owner:nil options:nil];
    ShareLinkView *vv = [ShareLinkView createViewWithXib];
    [vv showShareLinkViewInView:self.view];
//    self.shareLinkView = vv;
}

- (IBAction)onClickIm:(id)sender {
    MessageVC *vc = [[MessageVC alloc] initWithNibName:@"MessageVC" bundle:nil];
    [VCManager pushToVC:vc];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK(self);
    // 解除静音 可能需要申请
    UIAlertAction *muteAudio = [UIAlertAction actionWithTitle:Localized(@"MuteAudio") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:muteAudio];
    
    // 打开视频 可能需要申请
    UIAlertAction *muteVideo = [UIAlertAction actionWithTitle:Localized(@"MuteVideo") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:muteVideo];
    
    // if host
    UIAlertAction *setHost = [UIAlertAction actionWithTitle:Localized(@"SetHost") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:setHost];
    
    // 取消共享白板控制  如果当前人是主持人或者是已经有控制的自己
    UIAlertAction *whiteBoardControl = [UIAlertAction actionWithTitle:Localized(@"WhiteBoardControl") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:whiteBoardControl];
    
    // host
    UIAlertAction *removeRoom = [UIAlertAction actionWithTitle:Localized(@"RemoveRoom") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
  
    }];
    [alertController addAction:removeRoom];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancel];
    
    [VCManager presentToVC:alertController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.f;
}

@end
