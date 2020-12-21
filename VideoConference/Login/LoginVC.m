//
//  LoginVC.m
//  VideoConference
//
//  Created by SRS on 2020/5/9.
//  Copyright © 2020 agora. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVM.h"
#import "VCManager.h"
#import "SetVC.h"
#import "UserDefaults.h"
#import "MeetingVC.h"
#import "AgoraRoomManager.h"


@interface LoginVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *textFieldBgView;
@property (weak, nonatomic) IBOutlet UISwitch *cameraSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *micSwitch;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UITextField *roomPsd;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIImageView *signalImgView;
@property (strong, nonatomic) LoginVM *vm;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cameraSwitch.on = [UserDefaults getOpenCamera];
    self.micSwitch.on = [UserDefaults getOpenMic];
    self.userName.text = [UserDefaults getUserName];

    WEAK(self);
    ConferenceManager *conferenceManager = AgoraRoomManager.shareManager.conferenceManager;
    [conferenceManager netWorkProbeTestCompleteBlock:^(NetworkGrade grade) {
        NSString *imgName = [LoginVM signalImageName:grade];
        weakself.signalImgView.image = [UIImage imageNamed:imgName];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UserDefaults setUserName:self.userName.text];
}

- (void)initView {
    self.textFieldBgView.layer.borderWidth = 1;
    self.textFieldBgView.layer.borderColor = [UIColor colorWithHexString:@"E9EFF4"].CGColor;
    self.textFieldBgView.layer.cornerRadius = 5;
}

- (IBAction)onClickSet:(id)sender {
    
    [self.view endEditing:YES];
    self.tipView.hidden = YES;
    
    SetVC *vc = [[SetVC alloc] initWithNibName:@"SetVC" bundle:nil];
    [VCManager pushToVC:vc];
}

- (IBAction)onSwitchCamera:(id)sender {
    [UserDefaults setOpenCamera:self.cameraSwitch.on];
    self.tipView.hidden = YES;
}

- (IBAction)onSwitchMic:(id)sender {
    [UserDefaults setOpenMic:self.micSwitch.on];
    self.tipView.hidden = YES;
}

- (IBAction)onClickJoin:(UIButton *)sender {
    [self.view endEditing:YES];
    self.tipView.hidden = YES;
    
    NSString *userName = self.userName.text;
    NSString *roomPsd = self.roomPsd.text;
    NSString *roomName = self.roomName.text;
   
    NSString *tipString = [LoginVM checkInputWithUserName:userName
                                                  roomPsd:roomPsd
                                                 roomName:roomName];
    
    if (tipString != nil ) {
        [self showToast:tipString];
        return;
    }
    
    ConferenceEntryParams *params = [ConferenceEntryParams new];
    params.userName = userName;
    params.userUuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    params.roomName = roomName;
    params.roomUuid = roomName;
    params.password = roomPsd;
    params.enableVideo = self.cameraSwitch.on;
    params.enableAudio = self.micSwitch.on;
    params.avatar = @"";
    [self entryRoom:params];
}

- (void)entryRoom:(ConferenceEntryParams *)params{
    [self setLoadingVisible:YES];
    WEAK(self);
    ConferenceManager *conferenceManager = AgoraRoomManager.shareManager.conferenceManager;
    [conferenceManager entryConfRoomWithParams:params successBolck:^{
        [LoginVM saveEntryParamas:params];
        [weakself setLoadingVisible:NO];
        MeetingVC *vc = [[MeetingVC alloc] initWithNibName:@"MeetingVC" bundle:nil];
        [VCManager pushToVC:vc];
        [self showTipsTimeLimit];
    } failBlock:^(NSError * _Nonnull error) {
        [weakself setLoadingVisible:NO];
        [weakself showToast:error.localizedDescription];
    }];
}


- (void)setLoadingVisible:(BOOL)show {
    if(show) {
        [self.activityIndicator startAnimating];
        [self.joinButton setEnabled:NO];
    } else {
        [self.activityIndicator stopAnimating];
        [self.joinButton setEnabled:YES];
    }
}

- (IBAction)onClickTip:(id)sender {
    BOOL hidden = self.tipView.hidden;
    self.tipView.hidden = !hidden;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.tipView.hidden = YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.tipView.hidden = YES;
    return YES;
}

/// 显示限制时长的提示
- (void)showTipsTimeLimit {
    [self showToast:@"本应用为测试产品，请勿商用。单次直播最长10分钟。"];
}

@end
