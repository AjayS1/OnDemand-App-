
//  AppDelegate.m
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SingletonClass.h"
#import "PlaceObj.h"


static SingletonClass *sharedInstance = nil;
@implementation SingletonClass


+(SingletonClass*)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[SingletonClass alloc]init];
    }
    
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self!=nil)
    {
        _onDemandPushNotificationArray = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark--Email Validation
+(BOOL)emailValidation:(NSString *)email{
    BOOL result;
    //checking email validation
    NSString *emailRegEx = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    if ([emailTest evaluateWithObject:email] == YES)
    {
        result=YES;
    }
    else
    {
        result=NO;
    }
    return result;
    
}
+(NSMutableArray *)parseDateForLocation: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.strEventType = [List objectForKey:@"EventType"];
        appUserInfo.IsEmailNotification = [List objectForKey:@"isEmailNotification"];
        appUserInfo.IsMobileNotification = [List objectForKey:@"isMobileNotification"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parseImageArrayForSelection: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.IsPrimaryImage = [[List objectForKey:@"isPrimary"] boolValue];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parseDateForPayment: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];

        appUserInfo.accountNumStr = [List objectForKey:@"AccountNumber"];
        appUserInfo.accountType = [List objectForKey:@"AccountType"];
        appUserInfo.accountPrimary = [List objectForKey:@"isPrimary"];
        appUserInfo.accountVerificationStatus = [List objectForKey:@"VerificationStatus"];
        appUserInfo.accountStatus = [List objectForKey:@"Status"];
        appUserInfo.addedTime = [List objectForKey:@"AddedOn"];
        appUserInfo.expiryDate = [List objectForKey:@"Expiry"];
        appUserInfo.paymentAmount = [List objectForKey:@"AuthenticationPaymentAmount"];
        appUserInfo.bankName = [List objectForKey:@"Name"];

        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parseCancelDateDetails: (NSArray *)response {
    
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.cancelDatevalue = [List objectForKey:@"Value"];
        appUserInfo.cancelDateID = [List objectForKey:@"ID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parseAutocompleteResponse:(NSDictionary*)responseDict andError:(NSError*)error{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSLog(@"response dict %@",responseDict);
    if ([[responseDict objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray *venues = [responseDict objectForKey:@"predictions"];
        
        for (NSDictionary *dict in venues) {
            
            PlaceObj *place = [[PlaceObj alloc] init];
            [place setPlaceName:[[dict objectForKey:@"structured_formatting"] objectForKey:@"main_text"]];
            [place setPlaceNameWithDetails:[[dict objectForKey:@"structured_formatting"] objectForKey:@"secondary_text"]];
            [place setPlaceDescription:[dict objectForKey:@"description"]];
            [place setPlaceID:[dict objectForKey:@"place_id"]];
            [place setPlaceAddressDictionary:[dict objectForKey:@""]];
            place.placeAddress = [dict objectForKey:@"vicinity"];
            place.placeAddress = [[NSMutableString alloc] init];
            NSMutableArray *arrValue = [[NSMutableArray alloc] init];
            arrValue = [dict objectForKey:@"terms"];
            for (int i = 0; i < [arrValue count]; i++) {
                
                if (i == 0) {
                    [place setPlaceName:[[arrValue objectAtIndex:i] objectForKey:@"value"]];
                }else{
                    if ([place.placeAddress length]) {
                        [place.placeAddress appendString:@","];
                    }
                    NSDictionary *dictTemp = [arrValue objectAtIndex:i];
                    [place.placeAddress appendString:[dictTemp objectForKey:@"value"]];
                }
            }
            [place setPlaceHasData:YES];
            [place setPlaceHasCoordinate:NO];
            
            [tempArray addObject:place];
        }
    }
    return tempArray;
}
@end
