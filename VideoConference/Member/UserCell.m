//
//  UserCell.m
//  VideoConference
//
//  Created by SRS on 2020/5/13.
//  Copyright © 2020 agora. All rights reserved.
//

#import "UserCell.h"
#import "UIImage+Circle.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initView];
}

- (void)initView {
    UIImage *image = [UIImage generateImageWithSize:CGSizeMake(24, 24)];
    image = [UIImage circleImageWithOriginalImage:image];
    self.imgView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
