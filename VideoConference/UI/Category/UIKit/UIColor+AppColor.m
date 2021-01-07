//
//  UIColor+AppColor.m
//  VideoConference
//
//  Created by ZYP on 2020/12/31.
//  Copyright © 2020 agora. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "UIColor+Addition.h"

@implementation UIColor (AppColor)

+ (UIColor *)floatViewBackground
{
    
    return [UIColor colorWithHexString:@"2F3030" alpha:0.3];
}

+ (UIColor *)themColor
{
    return [UIColor colorWithHexString:@"4DA1FF"];
}

@end
