//
//  AudioCell.m
//  VideoConference
//
//  Created by ZYP on 2021/1/5.
//  Copyright © 2021 agora. All rights reserved.
//

#import "AudioCell.h"

@interface AudioCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headImageView.layer masksToBounds];
    [self.headImageView.layer setCornerRadius:72/2];
}

+ (instancetype)instanceFromNib
{
    NSString *className = NSStringFromClass(AudioCell.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

@end
