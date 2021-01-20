//
//  UserCell.m
//  VideoConference
//
//  Created by SRS on 2020/5/13.
//  Copyright © 2020 agora. All rights reserved.
//

#import "UserCell.h"
#import "UIImage+Circle.h"

@interface UserCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hostImgView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *audioImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareWConstraint;
@end

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

+ (NSString *)idf {
    return @"UserCell";
}

+ (NSString *)nibName {
    return [UserCell idf];
}


@end
