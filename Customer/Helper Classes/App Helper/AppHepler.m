
//  AppHeplerVC.m
//  Copyright (c) 2015 Mobile App. All rights reserved.

#import "AppHepler.h"
#import "Define.h"
#import "Reachability.h"
#import "AFNetworking.h"


@implementation AppHepler
+ (id)sharedHelper{
    static AppHepler *sharedAppHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAppHelper = [[AppHepler alloc] init];
    });
    return sharedAppHelper;
}

+ (UIImage*)appLogoImage
{
    return [UIImage imageNamed:@"Applogo.png"];
}

#pragma mark Network Rechability
+ (BOOL) isInternetAvailable
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
        return NO;
    else
        return YES;
}

+(void)saveToUserDefaults:(id)value withKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}


+(NSString*)userDefaultsForKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = nil;
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey:key];
    
    return val;
}

+(void)removeFromUserDefaultsWithKey:(NSString*)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults removeObjectForKey:key];
    [standardUserDefaults synchronize];
}


////----- Show an Alert Message

+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate
            cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
    
    if(title!=nil)
    {
        title=NSLocalizedStringFromTable(title, [AppHepler getCurrentLanguage], nil);
    }
    if(msg!=nil)
    {
        msg=NSLocalizedStringFromTable(msg, [AppHepler getCurrentLanguage], nil);
    }
    if(CbtnTitle !=nil)
    {
        CbtnTitle=NSLocalizedStringFromTable(CbtnTitle, [AppHepler getCurrentLanguage], nil);
    }
    if(otherBtnTitles !=nil)
    {
        otherBtnTitles=NSLocalizedStringFromTable(otherBtnTitles, [AppHepler getCurrentLanguage], nil);
    }
    
    
    if ([[UIApplication sharedApplication].keyWindow isMemberOfClass:[UIWindow class]])
    {
        ////There is no alertview present
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate
                                              cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
        alert.tag = tag;
        [alert show];
    }
    else
    {
        NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
        NSLog(@"present");
    }
    
}


#pragma mark - Email Validation
+(BOOL)emailValidate:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


/**
 To check wheather net is disconnected
 */
+ (BOOL)isNetworkDisconnected {
    BOOL reachable = [AFNetworkReachabilityManager sharedManager].reachable;
    if (!reachable) {
        //show popup here
        [self showAlertViewWithTag:400 title:AppName message:@"" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    return !reachable;
}

#pragma mark- Getting Language
+(NSString *)getCurrentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lag = [defaults objectForKey:@"Language"];
    
    if ([lag isEqualToString:@"English"]){
        return @"English";
        
    }
    else if ([lag isEqualToString:@"español"]){
        return @"Spanish";
        
    }
    else if([lag isEqualToString:@"ar"]){
        return @"Arabic";
    }
    else{
        return @"English";
    }
}

+(NSInteger)ageOnCurrentDateWithDOB:(NSString *)dob{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    NSDate *birthday = [df dateFromString:dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    return age;
}


+(UIImage *)snapShotForView:(UIView *)view{
    
    CGRect bounds = view.bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, [UIScreen mainScreen].scale);
    
    [view drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(NSArray *)countryNameList{
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity: [[NSLocale ISOCountryCodes] count]];
    
    for (NSString *countryCode in [NSLocale ISOCountryCodes])
    {
        NSString *identifier = [NSLocale localeIdentifierFromComponents: [NSDictionary dictionaryWithObject: countryCode forKey: NSLocaleCountryCode]];
        NSString *country = [[NSLocale currentLocale] displayNameForKey: NSLocaleIdentifier value: identifier];
        [countries addObject: country];
    }
    
    NSArray *sortedCountries = [countries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return sortedCountries;
}

+(NSArray *)relationshipStatus{
    return [[NSArray alloc] initWithObjects:@"Single", @"In a Relationship", @"It's Complicated", @"Married", @"Divorced", @"Engaged", @"In an Open Relationship", nil];
}

#pragma mark - Resize Image
+(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}



@end
