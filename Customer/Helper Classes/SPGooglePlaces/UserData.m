//
//  UserData.m
//  Hotsnap
//
//  Created by azad usmani on 18/07/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UserData.h"


@implementation UserData

static UserData *sharedUserDataObj1=nil;

@synthesize userDataDic;
@synthesize latitude,longitude;

+(UserData *)getUserData

{
    if(sharedUserDataObj1 == nil)
    {
        sharedUserDataObj1  = [[UserData alloc] init];
        sharedUserDataObj1.userDataDic=[[NSMutableDictionary alloc]init];
        sharedUserDataObj1.latitude=@"";
        sharedUserDataObj1.longitude=@"";
    }
    return sharedUserDataObj1;
}


@end
