//
//  AppHeplerVC.h
//  Survey App
//
//  Created by Gaurav Varshney on 02/09/15.
//  Copyright (c) 2015 Mobile App. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHepler : NSObject
{
    
}
+ (id)sharedHelper;

+(UIImage*)appLogoImage;
+(void)saveToUserDefaults:(id)value withKey:(NSString*)key;
+(NSString*)userDefaultsForKey:(NSString*)key;
+(void)removeFromUserDefaultsWithKey:(NSString*)key;

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

+ (NSString *)getCurrentLanguage;
+ (BOOL) isInternetAvailable;
+(BOOL)emailValidate:(NSString *)checkString;

+(UIImage *)snapShotForView:(UIView *)view;
+(NSInteger)ageOnCurrentDateWithDOB:(NSString *)dob;

+(NSArray *)countryNameList;
+(NSArray *)relationshipStatus;
+ (BOOL)isNetworkDisconnected;
+(UIImage *)resizeImage:(UIImage *)image;
@end
