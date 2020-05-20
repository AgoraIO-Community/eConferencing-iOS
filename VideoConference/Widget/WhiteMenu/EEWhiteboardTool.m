//
//  EEWhiteboardTool.m
//  AgoraEducation
//
//  Created by yangmoumou on 2019/10/23.
//  Copyright © 2019 Agora. All rights reserved.
//

#import "EEWhiteboardTool.h"

@interface EEWhiteboardTool()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *whiteboardTool;

@property (weak, nonatomic) UIButton *selectButton;
@end

@implementation EEWhiteboardTool

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.whiteboardTool];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.whiteboardTool.frame = self.bounds;

    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"E9EFF4"].CGColor;
    self.bgView.layer.borderWidth = 1;
}

- (IBAction)clickEvent:(UIButton *)sender {
    if (self.selectButton != nil) {
         [self.selectButton setSelected:NO];
    }
    
    BOOL isSelected = self.selectButton.isSelected;
    self.selectButton = sender;
    [self.selectButton setSelected:!isSelected];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWhiteTool:)]) {
        [self.delegate selectWhiteTool:sender.tag - 200];
    }
}

@end
