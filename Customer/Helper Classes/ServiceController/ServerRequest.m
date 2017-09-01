//
//  ServerRequest.m
//  Created by Flexsinmac2 on 07/12/15.
//  Copyright (c) 2015 Jamshed Ali. All rights reserved.
//

#import "ServerRequest.h"
#import "CommonUtils.h"
#import "Define.h"
#import "ProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "Reachability.h"

@implementation ServerRequest{
    Reachability *internetReachableFoo;

}

+(void)AFNetworkRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallType:(NSString *)callType CallBack:(void(^) (id resposeObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    if([AFNetworkReachabilityManager sharedManager].reachable){
        if(sharedInstance.checkBaseUrl) {
           webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else
        {
             webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
      //  requestSerializer.timeoutInterval = 10;
        manager.requestSerializer = requestSerializer;
        [manager setRequestSerializer:requestSerializer];
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        [manager POST:webServiceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            callback(jsonData,nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"network error:%@",error);
            callback(nil,error);
        }];
        
    }
    else
    {
        [ServerRequest networkConnectionLost];
    }
}

+(void)AFNetworkMultiplePartRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params file:(UIImage *)image fileKey:(NSString *)fileKey videoStr:(NSURL *)videoUrlStr CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        
            if(videoUrlStr){
            fileName =[NSString stringWithFormat:@"%@.mov",fileKey];
            fileData = [NSData dataWithContentsOfURL:videoUrlStr];
            mimeType =@"video/quicktime";
                NSString *webServiceUrl;
                SingletonClass *sharedInstance;
                sharedInstance = [SingletonClass sharedInstance];
            
                if(sharedInstance.checkBaseUrl) {
                    
                    webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
                }
                else{
                    
                    webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
                }
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            [manager POST:webServiceUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if(fileData){
                    [formData appendPartWithFileData:fileData
                                                name:fileKey
                                            fileName:fileName
                                            mimeType:mimeType];
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                callback(responseObject,nil);
            }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                callback(nil,error);
            }];
            
        }
        else
        {
            time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
            NSString *timestamp=[NSString stringWithFormat:@"%ld",unixTime];
            fileName =[NSString stringWithFormat:@"%@%@.jpeg",timestamp,fileKey];
            fileData =UIImageJPEGRepresentation(image, 1.0);
            mimeType =@"image/jpeg";
            NSString *webServiceUrl;
            SingletonClass *sharedInstance;
            sharedInstance = [SingletonClass sharedInstance];
            
            if(sharedInstance.checkBaseUrl) {
                webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
            }
            else{
                webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
            }
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            [manager POST:webServiceUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                if(fileData){
                    [formData appendPartWithFileData:fileData
                                                name:fileKey
                                            fileName:fileName
                                            mimeType:mimeType];
                }
            }
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                callback(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                callback(nil,error);
            }];
        }
    }
    else
    {
        [ServerRequest networkConnectionLost];
    }
}

+(void)AFNetworkMultiplePartWithPutRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params file:(UIImage *)image fileKey:(NSString *)fileKey videoStr:(NSURL *)videoUrlStr CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *mimeType;
        NSString *fileName;
        NSData *fileData;
        
        if(videoUrlStr){
            fileName =[NSString stringWithFormat:@"%@.mov",fileKey];
            fileData = [NSData dataWithContentsOfURL:videoUrlStr];
            mimeType =@"video/quicktime";
        }
        else{
            
            fileName =[NSString stringWithFormat:@"%@.jpeg",fileKey];
            fileData =UIImageJPEGRepresentation(image, 1.0);
            mimeType =@"image/jpeg";
        }
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else
        {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        [manager POST:webServiceUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if(fileData){
                [formData appendPartWithFileData:fileData
                                            name:fileKey
                                        fileName:fileName
                                        mimeType:mimeType];
            }
            
        }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
            callback(responseObject,nil);
        }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            callback(nil,error);
        }];
    }
    else
    {
        [ServerRequest networkConnectionLost];
    }
}

+ (void)requestWithUrl:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
    
        if(sharedInstance.checkBaseUrl) {
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
     NSLog(@"Web Service Url : %@",webServiceUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    requestSerializer.timeoutInterval = 300;
    manager.requestSerializer = requestSerializer;
        
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
    manager.responseSerializer = responseSerializer;
//        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
    [manager GET:webServiceUrl parameters:params
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        callback(jsonData,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"network error:%@",error);
        callback(nil,error);
    }];
    } else {
         [ServerRequest networkConnectionLost];
    }
}


+ (void)requestWithUrlForNewApi:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        if(sharedInstance.checkBaseUrl) {
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",@"http://ondemandapinew.flexsin.in/API/",urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",@"http://ondemandapinew.flexsin.in/API/",urlStr];
        }
        
        NSLog(@"Web Service Url : %@",webServiceUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 300;
        manager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        //        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        [manager GET:webServiceUrl parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 callback(jsonData,nil);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 callback(nil,error);
             }];
    } else {
        [ServerRequest networkConnectionLost];
    }
}



//For QA Purpose
+ (void)requestWithUrlForQA:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    if([AFNetworkReachabilityManager sharedManager].reachable){
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        
        NSLog(@"Web Service Url : %@",webServiceUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 3000;
        manager.requestSerializer = requestSerializer;
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        //        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        [manager GET:webServiceUrl parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 callback(jsonData,nil);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 callback(nil,error);
             }];
    } else {
        [ServerRequest networkConnectionLost];
    }
}

+ (void)requestWithNewUrl:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    if([AFNetworkReachabilityManager sharedManager].reachable){
        if(sharedInstance.checkBaseUrl) {
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        NSLog(@"Web Service Url : %@",webServiceUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 300;
        manager.requestSerializer = requestSerializer;
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        //        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        [manager GET:webServiceUrl parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 callback(jsonData,nil);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 callback(nil,error);
             }];
    } else {
        [ServerRequest networkConnectionLost];
    }
}



+(void)AFNetworkPostRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        
        if(sharedInstance.checkBaseUrl)
        {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else
        {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"Web Service Url %@%@",NewBaseServerUrl,urlStr);
    [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        callback(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"the falire is %@", error);
        callback(nil,error);
    }];
        
    }
    else {
        [ServerRequest networkConnectionLost];
    }
    
}

+(void)AFNetworkGetRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSLog(@"Web Service Url %@%@",NewBaseServerUrl,urlStr);
        [manager GET:[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"the falire is %@", error);
            callback(nil,error);
        }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
    
}

+(void)AFNetworkPostRequestUrlForQAPurpose:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        else{
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
      //  NSLog(@"Web Service Url %@%@",NewBaseServerUrl,urlStr);
        [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"the falire is %@", error);
            callback(nil,error);
        }];
    }
    else {
        [ServerRequest networkConnectionLost];
    }
    
}

+(void)AFNetworkPostRequestUrlForQA:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSLog(@"Web Service Url : %@%@",NewBaseQAServerUrl,urlStr);
        [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"the falire is %@", error);
            callback(nil,error);
        }];
    }
    else {
        [ServerRequest networkConnectionLost];
    }
}


+(void)AFNetworkDeleteRequestUrl:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.requestSerializer = serializer;
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        NSLog(@"SERVER_URL = %@, url string = %@",BaseServerUrl,urlStr);
        [manager DELETE:webServiceUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"the falire is %@", error);
            callback(nil,error);
        }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
}


+(void)networkConnectionLost{

    [ProgressHUD dismiss];
    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Internet connection error" inController:nil];
}


#pragma mark: Add Additional methode for calling google place Api
+(void)AFNetworkPostRequestUrlForGooglePlace:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    if([AFNetworkReachabilityManager sharedManager].reachable){
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 300;
        manager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        [manager GET:urlStr parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 callback(jsonData,nil);
                 NSLog(@"Response Value %@",jsonData);
                 NSLog(@"Response Value in Response %@",responseObject);
                 
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 callback(nil,error);
             }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
}

+(void)AFNetworkPostRequestUrlForAddNewApi:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        if(sharedInstance.checkBaseUrl) {
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSLog(@"Web Service Url %@%@",NewBaseServerUrl,urlStr);
        [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"the falire is %@", error);
            callback(nil,error);
        }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
    
}
//QA URL
+(void)AFNetworkPostRequestUrlForAddNewApiForQA:(NSString *)urlStr  withParams:(NSDictionary *)params CallBack:(void(^) (id resposeObject, NSError *error))callback {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *webServiceUrl;
        SingletonClass *sharedInstance;
        sharedInstance = [SingletonClass sharedInstance];
        
        if(sharedInstance.checkBaseUrl) {
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        NSLog(@"Web Service Url %@%@",NewBaseQAServerUrl,urlStr);
        [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseQAServerUrl,urlStr] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            callback(responseObject,nil);
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"the falire is %@", error);
                  callback(nil,error);
              }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
    
}
//-(BOOL) isConnected
//{
//    
//    NSString* url = [NSURL URLWithString:@"http://www.google.com/m"];
//    AFHTTPRequestOperation* request = [AFHTTPRequestOperation requestWithURL:[NSURL URLWithString:url]];
//    [request    setTimeOutSeconds:10];
//    //customize as per your needs - note this check is synchronous so you dont want to block the main thread for too long
//    [request setNumberOfTimesToRetryOnTimeout:0];
//    [request startSynchronous];
//    
//    NSError *error = [request error];
//    if (error)
//    {
//        DLog(@"connectivity error");
//        return NO;
//    }
//    else
//    {
//        DLog(@"connectivity OK");
//        return YES;
//    }
//    
//}


+ (void)requestWithUrlForGetCustomLocation:(NSString *)urlStr withParams:(NSDictionary *)params CallBack:(void(^)(id responseObject, NSError *error))callback
{
    NSString *webServiceUrl;
    SingletonClass *sharedInstance;
    sharedInstance = [SingletonClass sharedInstance];
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        if(sharedInstance.checkBaseUrl) {
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        else{
            
            webServiceUrl =[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,urlStr];
        }
        
        NSLog(@"Web Service Url : %@",webServiceUrl);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        requestSerializer.timeoutInterval = 300;
        manager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
        manager.responseSerializer = responseSerializer;
        //        manager.responseSerializer.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:400];
        
        [manager GET:webServiceUrl parameters:params
         
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 callback(jsonData,nil);
                 NSLog(@"Response Value %@",jsonData);
                 NSLog(@"Response Value in Response %@",responseObject);

                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"network error:%@",error);
                 callback(nil,error);
             }];
        
    } else {
        
        [ServerRequest networkConnectionLost];
    }
    
}

@end
