//
//  MeetingFlowLayout.h
//  VideoConference
//
//  Created by ZYP on 2020/12/31.
//  Copyright © 2020 agora. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeetingFlowLayoutVideo : UICollectionViewFlowLayout

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets)collectionViewContentInsets;
- (NSInteger)numberOfItemsInSection:(NSInteger)section itemsCount:(NSInteger)itemsCount;
- (NSInteger)numberOfSectionsInItemsCount:(NSInteger)itemsCount;
- (UIEdgeInsets)insetForSectionAtIndex:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
