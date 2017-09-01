//
//  ServiceController.m
//  Radient
//
//  Created by ankur on 5/11/16.
//  Copyright © 2016 ankur. All rights reserved.
//

#import "ServiceController.h"
#import "AppHepler.h"
#import "AFNetworking.h"

@implementation ServiceController

//for getting manager
+ (AFHTTPRequestOperationManager *)getOperationManager {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    return manager;
}

//generalized Get request
+ (void)get:(NSString *)getMethod parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    //check reachability for network connection
    if([AppHepler isNetworkDisconnected])
    {
        return;
    }
    AFHTTPRequestOperationManager *manager = [self getOperationManager];
    [manager GET:getMethod parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
#ifdef SHOW_JSON_DATA
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Json Response[%@]:%@", getMethod, jsonString);
#endif
        
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        if (error) {
            NSLog(@"Error while parsing data - %@", error.description);
            success(nil);
        }
        else {
            success(dict);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"Failed : %@", error);
        failure(error);
    }];
}




@end
