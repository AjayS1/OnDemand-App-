//
//  UserData.h
//  Hotsnap
//
//  Created by azad usmani on 18/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserData : NSObject {
    NSMutableDictionary *userDataDic;
    NSString *latitude;
    NSString *longitude;
}

@property(nonatomic,retain)NSMutableDictionary *userDataDic;
@property(nonatomic,retain)  NSString *latitude;
@property(nonatomic,retain)  NSString *longitude;
+(UserData *)getUserData;


@end
