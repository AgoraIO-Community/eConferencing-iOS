//
//  MeetingVC2r.m
//  VideoConference
//
//  Created by ZYP on 2020/12/28.
//  Copyright © 2020 agora. All rights reserved.
//

#import "MeetingVC2.h"
#import "MeetingView.h"
#import "VideoCell.h"
#import "MeetingFlowLayout.h"

@interface MeetingVC2 ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)MeetingView *mainView;

@end

@implementation MeetingVC2

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mainView = [MeetingView new];
    self.view = _mainView;
    [self setup];
}

- (void)setup
{
    _mainView.collectionView.delegate = self;
    _mainView.collectionView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    [_mainView.collectionView registerNib:nib forCellWithReuseIdentifier:@"VideoCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell"
                                                                forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [VideoCell instanceFromNib];
    }
    

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [_mainView.layout1 minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [_mainView.layout1 minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [_mainView.layout1 collectionView:collectionView sizeForItemAtIndexPath:indexPath];
}




@end
