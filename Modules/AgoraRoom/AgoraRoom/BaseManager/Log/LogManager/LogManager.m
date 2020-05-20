//
//  LogManager.m
//  AgoraEducation
//
//  Created by SRS on 2020/3/24.
//  Copyright © 2020 yangmoumou. All rights reserved.
//

#import "LogManager.h"
#import <UIKit/UIKit.h>
#import "HttpManager.h"
#import "URL.h"
#import "OSSManager.h"
#import <YYModel.h>
#import "LogParamsModel.h"
#import "SSZipArchive.h"

typedef NS_ENUM(NSInteger, ZipStateType) {
    ZipStateTypeOK              = 0,
    ZipStateTypeOnNotFound      = 1,
    ZipStateTypeOnRemoveError   = 2,
    ZipStateTypeOnZipError      = 3,
};


@implementation LogManager
+ (void)load {
    [LogManager setupLog];
}

+ (void)setupLog {
    
    [DDLog addLogger:[DDOSLogger sharedInstance] withLevel:DDLogLevelVerbose];
    
    NSString *logFilePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"/Agora"];
    NSLog(@"logFilePath==>%@", logFilePath);
    DDLogFileManagerDefault *logFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logFilePath];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:logFileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.maximumFileSize = 1024 * 1024;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
    [DDLog addLogger:fileLogger withLevel:ddLogLevel];
}

+ (void)uploadLogWithAppId:(NSString *)appId roomId:(NSString *)roomId apiVersion:(NSString*)apiVersion completeSuccessBlock:(void (^ _Nullable) (NSString *uploadSerialNumber))successBlock completeFailBlock:(void (^ _Nullable) (NSError *error))failBlock {
    
    NSString *logDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"/Agora"];
    NSString *zipName = [LogManager generateZipName];
    NSString *zipPath = [NSString stringWithFormat:@"%@/%@", logDirectoryPath, zipName];
    NSInteger zipCode = [LogManager zipFilesWithSourceDirectory:logDirectoryPath toPath:zipPath];
    switch (zipCode) {
        case ZipStateTypeOnNotFound:
            if(failBlock != nil) {
                NSError *error = LocalError(LocalAgoraErrorCodeCommon, Localized(@"LogNotFoundText"));
                failBlock(error);
            }
            return;
            break;
        case ZipStateTypeOnRemoveError:
            if(failBlock != nil) {
                NSError *error = LocalError(LocalAgoraErrorCodeCommon, Localized(@"LogClearErrorText"));
                failBlock(error);
            }
            return;
            break;
        case ZipStateTypeOnZipError:
            if(failBlock != nil) {
                NSError *error = LocalError(LocalAgoraErrorCodeCommon, Localized(@"LogZipErrorText"));
                failBlock(error);
            }
            return;
            break;
        default:
            break;
    }
    if (zipCode != ZipStateTypeOK){
        if(failBlock != nil) {
            NSError *error = LocalError(LocalAgoraErrorCodeCommon, Localized(@"LogZipErrorText"));
            failBlock(error);
        }
        return;
    }

    [HttpManager getLogInfoWithAppId:appId roomId:roomId apiVersion:apiVersion  completeSuccessBlock:^(LogParamsInfoModel * _Nonnull model) {
        
        [OSSManager uploadOSSWithBucketName:model.bucketName objectKey:model.ossKey callbackBody:model.callbackBody callbackBodyType:model.callbackContentType endpoint:model.ossEndpoint fileURL:[NSURL URLWithString:zipPath] completeSuccessBlock:^(NSString * _Nonnull uploadSerialNumber) {
            
            if(successBlock != nil) {
                successBlock(uploadSerialNumber);
            }
            
        } completeFailBlock:^(NSError * _Nonnull error) {
            if(failBlock != nil) {
                failBlock(error);
            }
        }];
        
    } completeFailBlock:^(NSError * _Nonnull error) {
        if(failBlock != nil) {
            failBlock(error);
        }
    }];
}

+ (NSInteger)zipFilesWithSourceDirectory:(NSString *)directoryPath toPath:(NSString *)zipPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectoryExist = [fileManager fileExistsAtPath:directoryPath];
    if(!isDirectoryExist) {
        
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSDirectoryEnumerator *direnum = [fileManager enumeratorAtPath:directoryPath];
    NSString *filename;
    while (filename = [direnum nextObject]) {
        if ([[filename pathExtension] isEqualToString:@"zip"]) {
            
            NSString *logZipPath = [NSString stringWithFormat:@"%@/%@", directoryPath, filename];
            
            NSError *error;
            BOOL rmvSuccess = [fileManager removeItemAtPath:logZipPath error:&error];
            if (error || !rmvSuccess) {
                return ZipStateTypeOnRemoveError;
            }
            break;
        }
    }
    
    BOOL zipSuccess = [SSZipArchive createZipFileAtPath:zipPath withContentsOfDirectory:directoryPath];
    if(zipSuccess){
        return ZipStateTypeOK;
    }
    return ZipStateTypeOnZipError;
}

+ (NSString *)generateZipName {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *zipName = [NSString stringWithFormat:@"%@.zip", currentTimeString];
    return zipName;
}

@end
