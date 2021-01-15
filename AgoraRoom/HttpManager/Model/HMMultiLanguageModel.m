//
//  ARMultiLanguageModel.m
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import "HMMultiLanguageModel.h"

@implementation HMMultiLanguageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"cn": @"zh-cn",
             @"en": @"en-us",};
}

@end
