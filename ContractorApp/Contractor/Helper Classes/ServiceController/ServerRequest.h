//
//  ServerRequest.h
//
//  Created by Flexsinmac2 on 07/12/15.
//  Copyright (c) 2015 Jamshed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "Define.h"
#import <UIKit/UIKit.h>
#import "ProgressHUD.h"
#import "CommonUtils.h"
#import "SingletonClass.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface ServerRequest : NSObject

+(void)networkConnectionLost;

+ (void)requestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback;

+(void)AFNetworkRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallType:(NSString *)callType CallBack:(void(^) (id resposeObject, NSError *error))callback;

+(void)AFNetworkMultiplePartRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params file:(UIImage *)image fileKey:(NSString *)fileKey videoStr:(NSURL *)videoUrlStr CallBack:(void(^) (id resposeObject, NSError *error))callback;


+(void)AFNetworkMultiplePartWithPutRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params file:(UIImage *)image fileKey:(NSString *)fileKey videoStr:(NSURL *)videoUrlStr CallBack:(void(^) (id resposeObject, NSError *error))callback;


+(void)AFNetworkPostRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback;

+(void)AFNetworkDeleteRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback;

+ (void)requestWIthNewURL:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback;
//QA URL
+(void)AFNetworkPostRequestUrlForQA:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback;
+ (void)requestWIthNewURLForQA:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback;

+ (void)requestWithUrlQA:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback;
+(void)AFNetworkPostRequestUrlForAddNewApiForQA:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback;
+(void)AFNetworkGetRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback;

+(void)AFNetworkGetStateAbbribiation:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback ;
+ (void)requestWithUrlNewApi:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
;
+(void)AFNetworkPostRequestUrlForGooglePlace:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback ;
@end
