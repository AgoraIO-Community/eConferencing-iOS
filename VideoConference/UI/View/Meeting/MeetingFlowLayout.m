//
//  MeetingFlowLayout.m
//  VideoConference
//
//  Created by ZYP on 2020/12/31.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingFlowLayout.h"

@implementation MeetingFlowLayout

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
     
    CGSize size = collectionView.bounds.size;
    
    NSInteger width = (size.width - 2) * 0.5;
    NSInteger height = (size.height - 2) * 0.5;
    
    return CGSizeMake(width, height);
}

@end
