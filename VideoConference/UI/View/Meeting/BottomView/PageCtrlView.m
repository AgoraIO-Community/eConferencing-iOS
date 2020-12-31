//
//  SpeakerPageCtrlView.m
//  VideoConference
//
//  Created by ZYP on 2020/12/30.
//  Copyright © 2020 agora. All rights reserved.
//

#import "PageCtrlView.h"
#import "NibInitProtocol.h"

@interface PageCtrlView ()<NibInitProtocol>
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageCtrl;

@end

@implementation PageCtrlView

- (void)setcCurrentPage:(NSInteger)currentPage
        andNumberOfPage:(NSInteger)numberOfPage
{
    if (currentPage > numberOfPage - 1) { return; }
    
    if (numberOfPage <= 4) {//只显示pageCtrl
        [_numberLabel setHidden:true];
        [_pageCtrl setHidden:false];
        _pageCtrl.numberOfPages = numberOfPage;
        _pageCtrl.currentPage = currentPage;
    }
    else {//只显示number
        [_numberLabel setHidden:false];
        [_pageCtrl setHidden:true];
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", currentPage, numberOfPage];
    }
}

+ (instancetype)instanceFromNib
{
    NSString *className = NSStringFromClass(PageCtrlView.class);
    return [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil].firstObject;
}

@end
