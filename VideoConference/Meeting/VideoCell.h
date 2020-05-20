//
//  VideoCell.h
//  VideoConference
//
//  Created by SRS on 2020/5/15.
//  Copyright © 2020 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *renderView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIImageView *hostView;
@property (weak, nonatomic) IBOutlet UIImageView *shareView;
@property (weak, nonatomic) IBOutlet UIView *audioView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hostWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioWConstraint;

@end

NS_ASSUME_NONNULL_END
