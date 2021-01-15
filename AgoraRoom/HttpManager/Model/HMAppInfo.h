//
//  ARAppVersionInfo.h
//  AgoraRoom
//
//  Created by ZYP on 2021/1/11.
//  Copyright © 2021 agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMMultiLanguageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMAppConfig : NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *oneToOneTeacherLimit;
@property (nonatomic, strong) NSString *smallClassTeacherLimit;
@property (nonatomic, strong) NSString *largeClassTeacherLimit;
@property (nonatomic, strong) NSString *oneToOneStudentLimit;
@property (nonatomic, strong) NSString *smallClassStudentLimit;
@property (nonatomic, strong) NSString *largeClassStudentLimit;
@property (nonatomic, strong) HMMultiLanguageModel *multiLanguage;

@end

@interface HMAppInfo : NSObject

@property (nonatomic, strong) NSString *appCode;
@property (nonatomic, assign) NSInteger osType;
@property (nonatomic, assign) NSInteger terminalType;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *latestVersion;
@property (nonatomic, strong) NSString *appPackage;
@property (nonatomic, strong) NSString *upgradeDescription;
//1 no update 2update 3force update
@property (nonatomic, assign) NSInteger forcedUpgrade;
@property (nonatomic, strong) NSString *upgradeUrl;
@property (nonatomic, assign) NSInteger reviewing;
@property (nonatomic, strong) NSString *apiHost;
@property (nonatomic, assign) NSInteger remindTimes;

@property (nonatomic, strong) HMAppConfig *configInfoModel;

@end

NS_ASSUME_NONNULL_END
