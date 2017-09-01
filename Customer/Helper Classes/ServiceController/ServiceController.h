//
//  ServiceController.h
//  Radient
//
//  Created by ankur on 5/11/16.
//  Copyright © 2016 ankur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Define.h"

typedef void (^SuccessBlock)(NSDictionary *responseDict);
typedef void (^FailureBlock)(NSError *error);

@interface ServiceController : NSObject

@end
