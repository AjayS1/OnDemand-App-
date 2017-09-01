


//  AppDelegate.m
//  Contractor
//  Created by Jamshed Ali on 17/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AppDelegate.h"
#import "ViewController.h"
#import "AFNetworking.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import "Define.h"
#import "ServerRequest.h"
#import "SingletonClass.h"
#import <AudioToolbox/AudioServices.h>
#import "BackgroundPopup.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <UserNotifications/UserNotifications.h>
#import "BackgroudVC.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width
#define SYSTEM_VERSION                  [[UIDevice currentDevice].systemVersion floatValue]

@interface AppDelegate () <BackgroundPopupDelegate,UNUserNotificationCenterDelegate>
{
    SingletonClass *sharedInstance;
    NSTimer *timer;
    NSString *userIdStr;
    NSMutableURLRequest *request;
    NSString *notificationMessage;
    UIStoryboard *storyboard;
    UIBackgroundTaskIdentifier bgTask;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [Fabric with:@[[Crashlytics class]]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    sharedInstance = [SingletonClass sharedInstance];
    //Get App Version Number
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"Version Number %@",version);
    sharedInstance.appVersionNumber = version;
    //  [self getCurrentAddressOfClient];
    
    //--1) Push Notification **************
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    else
    {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                         UIUserNotificationTypeAlert |
                                                         UIUserNotificationTypeSound)];
        [application registerForRemoteNotifications];
    }
    
    //Get the current Location
    [self getLongitudeAndLatitude];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdateValue)
                                                 name:@"loactionUpdate"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userOfflineStatusUpdate)
                                                 name:@"userOfflineStatusUpdate"
                                               object:nil];
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:ivc];
    self.window.rootViewController = navigationController;
    navigationController.navigationBarHidden=YES;
    [self.window makeKeyAndVisible];
    
    //    NSString *address = @"error";
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    [[NSUserDefaults standardUserDefaults]setObject:address forKey:@"IPAddressValue"];
    self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
        NSLog(@"lapsed: %f", lapse);
        NSLog(@"muted: %d", muted);
        if (muted) {
            NSLog(@"vibratePhone %@",@"here");
            if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
            {
                AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
            }
        }
    }];
    //return address;
    return YES;
}

#pragma mark-- CLLocation Manager Method ::
-(void)getLongitudeAndLatitude {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    _geocoder = [[CLGeocoder alloc] init];
    
    if(IS_OS_8_OR_LATER) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else{
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    
}


-(void)locationUpdateValue {
    [self.locationManager startUpdatingLocation];
    
}

-(void)userOfflineStatusUpdate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self changeStatusWithValue:@"0"];
    });
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    //if (currentLocation != nil) {
    longitude_Reg = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    latitude_Reg = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    // NSLog(@"latitude_Reg is: %@, longitude_Reg is: %@", latitude_Reg,longitude_Reg);
    
    [[NSUserDefaults standardUserDefaults]setObject:longitude_Reg forKey:@"LONGITUDEDATA"];
    [[NSUserDefaults standardUserDefaults]setObject:latitude_Reg forKey:@"LATITUDEDATA"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //Reverse Geocoding
    [_geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            countryIOSCode =[NSString stringWithFormat:@"%@", placemark.ISOcountryCode];
            [[NSUserDefaults standardUserDefaults] setObject:countryIOSCode forKey:@"CountryISOCode"];
            
            userLocation = [NSString stringWithFormat:@"%@",placemark.locality];
            NSString *addressStr =   [NSString stringWithFormat:@"%@", placemark.addressDictionary];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"addressDictionary %@", placemark.addressDictionary);
            
            NSString *addressDetailsStr =  [NSString stringWithFormat:@"name =%@, thoroughfare = %@, locality =%@, subLocality = %@, administrativeArea = %@,  postalCode = %@ , subThoroughfare = %@", placemark.name, placemark.thoroughfare,placemark.locality,placemark.subLocality,placemark.administrativeArea, placemark.postalCode,placemark.subThoroughfare];
            NSLog(@"%@",addressStr);
            NSLog(@"%@",addressDetailsStr);
            NSString *currentAddressValue ;
            
            if ([placemark.name length] ) {
                if ([placemark.locality length] && (![placemark.locality isEqualToString:@"null"])) {
                    if ([placemark.subLocality length] && (![placemark.subLocality isEqualToString:@"null"])) {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else
                                    {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country];
                                    }
                                }
                                else
                                {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea, placemark.postalCode];
                                    }
                                }
                            }
                            else
                            {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                    }
                }
                
                else
                {
                    if ([placemark.subLocality length] && (![placemark.subLocality isEqualToString:@"null"])) {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                            else
                            {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                        //
                        else
                        {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                            else
                            {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else{
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                    
                                }
                                else{
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else{
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                if ([placemark.locality length] && (![placemark.locality isEqualToString:@"null"])) {
                    if ([placemark.subLocality length] && (![placemark.subLocality isEqualToString:@"null"])) {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if ([placemark.subLocality length] && (![placemark.subLocality isEqualToString:@"null"])) {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                            else
                            {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else
                                    {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                }
                                else
                                {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else
                                    {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        if ([placemark.subAdministrativeArea length] && (![placemark.subAdministrativeArea isEqualToString:@"null"])) {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ([placemark.administrativeArea length] && (![placemark.administrativeArea isEqualToString:@"null"])) {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.country, placemark.postalCode];
                                    }
                                }
                            }
                            else
                            {
                                if ([placemark.country length] && (![placemark.country isEqualToString:@"null"])) {
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else{
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                    
                                }
                                else{
                                    if ([placemark.postalCode length] && (![placemark.postalCode isEqualToString:@"null"])) {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country, placemark.postalCode];
                                    }
                                    else
                                    {
                                        sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.country];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            sharedInstance.currentAddressStr = [sharedInstance.currentAddressStr stringByReplacingOccurrencesOfString:@",(null)"
                                                                                                           withString:@""];
            if ([sharedInstance.currentAddressStr length])
            {
                if   ([sharedInstance.currentAddressStr containsString:@"(null)"]){
                    sharedInstance.currentAddressStr = locatedAt;
                }
            }
            
            NSLog(@"I am currently at %@",locatedAt);
            NSLog(@"%@",  sharedInstance.currentAddressStr);
            sharedInstance.cityValueStr = userLocation;
            sharedInstance.countryValueStr = placemark.country;
            sharedInstance.stateValueStr = placemark.administrativeArea;
            sharedInstance.zipValueStr = placemark.postalCode;
            sharedInstance.districValue = placemark.subAdministrativeArea;
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    }
     ];
    [self stopSignificantChangesUpdates];
}

-(BOOL)isNullOrEmpty:(NSString *)inString
{
    BOOL retVal = YES;
    
    if((inString != nil ) && (inString != NULL) && (![inString isEqualToString:@"null"]))
    {
        if( [inString isKindOfClass:[NSString class]] )
        {
            retVal = inString.length == 0;
        }
        else
        {
            NSLog(@"isNullOrEmpty, value not a string");
        }
    }
    return retVal;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        // permission denied
        NSLog(@"Hello");
        // [self getLongitudeAndLatitude];
        
    }
    else if ((status == kCLAuthorizationStatusAuthorizedAlways )|| (status == kCLAuthorizationStatusAuthorizedWhenInUse) ){
        if (self.locationManager != nil) {
            [self.locationManager startUpdatingLocation];
            
        }
        else {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
        }
        //sharedInstance.locationShareYesOrNO = YES;
    }
}


- (void)countdownTimer:(NSTimer *)timer {
    
    NSString *userIdString = sharedInstance.userId;
    
    NSLog(@"userIdStr == %@",userIdString);
    
    if ([userIdStr isKindOfClass:[NSString class]]) {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&latitude=%@&longitude=%@",APIUserLocationUpdateApiCall,userIdString,latitude_Reg,longitude_Reg];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            
            //[ProgressHUD dismiss];
            
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                } else {
                    
                }
            } else {
                
                NSLog(@"Error");
            }
        }];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)stopSignificantChangesUpdates{
    
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark On Demand Date Request NSNotification Method Call

- (void)onDemandDateRequest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSLog(@"%@",responseObject);
}


#pragma mark ---Push Notification **************************

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    sharedInstance.deviceToken = pushToken;
    [[NSUserDefaults standardUserDefaults]setObject:pushToken forKey:@"deviceToken"];
    NSLog(@" Did Register for Remote Notifications with Device Token %@", pushToken);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    if (SYSTEM_VERSION >= 7){
        NSLog(@"User Info : %@",response.notification.request.content.userInfo);
        completionHandler();
        
        self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
            NSLog(@"lapsed: %f", lapse);
            NSLog(@"muted: %d", muted);
            if (muted) {
                
                NSLog(@"vibratePhone %@",@"here");
                if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
                {
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                }
                else
                {
                    AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                }
            }
        }];
        
        NSLog(@"UserInfo is --%@",response.notification.request.content.userInfo);
        
        for (id key in response.notification.request.content.userInfo) {
            NSLog(@"key: %@, value: %@", key, [response.notification.request.content.userInfo objectForKey:key]);
        }
        
        NSString *typeStr = [NSString stringWithFormat:@"%@",[response.notification.request.content.userInfo objectForKey:@"Type"]];
        NSLog(@"Type Value %@",typeStr);
        
        if ([typeStr isEqualToString:@"7"] || [typeStr isEqualToString:@"11"] || [typeStr isEqualToString:@"5"] ||[typeStr isEqualToString:@"3"] ||[typeStr isEqualToString:@"16"])
        {
            sharedInstance.isFromCancelDateRequest = TRUE;
        }
        else
        {
            sharedInstance.isFromCancelDateRequest = FALSE;
        }
        
        if ([sharedInstance.refreshApiCallOrNotStr isEqualToString:@"yes"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"apiRefreshCall" object:self userInfo:nil];
            
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"apiRefreshCall" object:self userInfo:nil];
            
            NSString *userIdString = sharedInstance.userId;
            NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdString,@"UserID",@"2" ,@"userType",nil];
            
            [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get Comments List %@",responseObject);
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        NSDictionary *countDataDict = [responseObject objectForKey:@"result"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCount" object:self userInfo:countDataDict];
                    }
                    else
                    {
                    }
                }
                else
                {
                }
            }];
        }
        
        // custom code to handle notification content
        
        if( [UIApplication sharedApplication].applicationState == UIApplicationStateInactive ) {
            NSLog( @"INACTIVE" );
            completionHandler( UIBackgroundFetchResultNewData );
        }
        
        else if( [UIApplication sharedApplication].applicationState == UIApplicationStateBackground )
        {
            NSLog( @"BACKGROUND" );
            completionHandler( UIBackgroundFetchResultNewData );
            
            if ((unsigned int)self.muteChecker.soundId == 4099) {
                
                NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
                SystemSoundID soundID;
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
                AudioServicesPlaySystemSound (soundID);
            }
            else {
                NSLog(@"vibratePhone %@",@"here");
                if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]) {
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                }
                else{
                    AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                }
            }
            if([typeStr isEqualToString:@"1"]){
                // [self addBackgroundViewWithInfo:response.notification.request.content.userInfo];
            }
        }
        else
        {
            NSLog( @"FOREGROUND" );
            completionHandler( UIBackgroundFetchResultNewData );
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
            AudioServicesPlaySystemSound (soundID);
            
            if ((unsigned int)self.muteChecker.soundId == 4099) {
                NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
                SystemSoundID soundID;
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
                AudioServicesPlaySystemSound (soundID);
                
            } else {
                
                NSLog(@"vibratePhone %@",@"here");
                if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
                {
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                }
                else
                {
                    AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                }
            }
            NSArray *notificationMessageArray;
            notificationMessageArray = [[[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"]componentsSeparatedByString:@"#"];
            
            if (notificationMessageArray.count >1 )
            {
                NSString *messageString = [notificationMessageArray firstObject];
                ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
                ALAlertBannerPosition position = ALAlertBannerPositionTop;
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees Provider"] subtitle:messageString tappedBlock:^(ALAlertBanner *alertBanner) {
                    NSLog(@"tapped!");
                    
                    [alertBanner hide];
                    if([[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"current_user_id"]) {
                    }
                }];
                banner.secondsToShow = 3.5;
                banner.showAnimationDuration = 0.25;
                banner.hideAnimationDuration = 0.2;
                [banner show];
            }
            else
            {
                ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
                ALAlertBannerPosition position = ALAlertBannerPositionTop;
                ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees Provider"] subtitle:[[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"] tappedBlock:^(ALAlertBanner *alertBanner) {
                    NSLog(@"tapped!");
                    [alertBanner hide];
                    if([[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"current_user_id"]) {
                    }
                }];
                banner.secondsToShow = 3.5;
                banner.showAnimationDuration = 0.25;
                banner.hideAnimationDuration = 0.2;
                [banner show];
            }
        }
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted)
                        {
                            NSLog(@"lapsed: %f", lapse);
                            NSLog(@"muted: %d", muted);
                            if (muted) {
                                
                                NSLog(@"vibratePhone %@",@"here");
                                if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
                                {
                                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                                }
                                else
                                {
                                    AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                                }
                            }
                        }];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection reconnecting];
    }
    else{
        [self signalRHubCall];
    }
    NSLog(@"UserInfo is --%@",userInfo);
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSString *typeStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"Type"]];
    NSLog(@"Type Value %@",typeStr);
    if ([typeStr isEqualToString:@"7"]) {
        
        sharedInstance.IsCancelDateFromOnDemandPush = YES;
    }
    if ([typeStr isEqualToString:@"7"] || [typeStr isEqualToString:@"11"] || [typeStr isEqualToString:@"5"] ||[typeStr isEqualToString:@"3"] ||[typeStr isEqualToString:@"16"]  || [typeStr isEqualToString:@"3"]) {
        sharedInstance.isFromCancelDateRequest = TRUE;
    }
    else{
        sharedInstance.isFromCancelDateRequest = FALSE;
    }
    
    if ([sharedInstance.refreshApiCallOrNotStr isEqualToString:@"yes"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"apiRefreshCall" object:self userInfo:nil];
        
    }
    else {
        
        // if ([typeStr isEqualToString:@"18"]|| [typeStr isEqualToString:@"10"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"apiRefreshCall" object:self userInfo:nil];
        NSString *userIdStdgr = sharedInstance.userId;
        NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStdgr,@"UserID",@"2" ,@"userType",nil];
        [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get Comments List %@",responseObject);
            
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSDictionary *countDataDict = [responseObject objectForKey:@"result"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCount" object:self userInfo:countDataDict];
                }
                else
                {
                }
            }
            else
            {
            }
        }];
    }
    UIApplicationState appState = [application applicationState];
    if (appState == UIApplicationStateActive)
    {
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
        AudioServicesPlaySystemSound (soundID);
        if ((unsigned int)self.muteChecker.soundId == 4099) {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
            AudioServicesPlaySystemSound (soundID);
        }
        else
        {
            NSLog(@"vibratePhone %@",@"here");
            if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
            {
                AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
            }
        }
        
        NSArray *notificationMessageArray;
        notificationMessageArray = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]componentsSeparatedByString:@"#"];
        if (notificationMessageArray.count >1 ) {
            NSString *messageString = [notificationMessageArray firstObject];
            ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
            ALAlertBannerPosition position = ALAlertBannerPositionTop;
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees Provider"] subtitle:messageString tappedBlock:^(ALAlertBanner *alertBanner) {
                NSLog(@"tapped!");
                
                [alertBanner hide];
                if([[userInfo objectForKey:@"aps"] objectForKey:@"current_user_id"]) {
                }
            }];
            banner.secondsToShow = 3.5;
            banner.showAnimationDuration = 0.25;
            banner.hideAnimationDuration = 0.2;
            if([typeStr isEqualToString:@"1"]){
            }
            else{
                [banner show];
                
            }
        }
        else {
            ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
            ALAlertBannerPosition position = ALAlertBannerPositionTop;
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees Provider"] subtitle:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] tappedBlock:^(ALAlertBanner *alertBanner) {
                NSLog(@"tapped!");
                
                [alertBanner hide];
                if([[userInfo objectForKey:@"aps"] objectForKey:@"current_user_id"]) {
                }
            }];
            banner.secondsToShow = 3.5;
            banner.showAnimationDuration = 0.25;
            banner.hideAnimationDuration = 0.2;
            if([typeStr isEqualToString:@"1"]){
            }
            else{
                [banner show];
            }
        }
    }
    else
    {
        if ((unsigned int)self.muteChecker.soundId == 4099) {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Beep" ofType:@"mp3"];
            SystemSoundID soundID;
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
            AudioServicesPlaySystemSound (soundID);
        }
        else {
            
            NSLog(@"vibratePhone %@",@"here");
            if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
            {
                AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
            }
        }
        if([typeStr isEqualToString:@"1"]){
            NSLog(@"Hello Push ");
            //  [self addBackgroundViewWithInfo:userInfo];
        }
    }
}


-(void)addSubviewWithBounce:(UIView*)theView {
    
    theView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [[APPDELEGATE window] addSubview:theView];
    theView.alpha = 0.1;
    [UIView animateWithDuration:1.0 animations: ^{ theView.alpha = 1.0; }];
    theView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1.0);
    CAKeyframeAnimation *bounceAnimation=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 1.0;
    bounceAnimation.removedOnCompletion = NO;
    [theView.layer addAnimation: bounceAnimation forKey: @"bounce"];
    theView.layer.transform = CATransform3DIdentity;
}

- (void)addBackgroundViewWithInfo:(NSDictionary *)userInfo {
    
    UILabel *lbl = [[UILabel alloc] init];
    [lbl setText:@"bvcbcvbvc"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil]];
    [[self window] setRootViewController:self.navController];
    
    BackgroudVC *gpsLocationView = [storyboard instantiateViewControllerWithIdentifier:@"BackgroudVC"];
    gpsLocationView.notificationDictionary = userInfo;
    [self.navController presentViewController:gpsLocationView animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self changeStatusWithValue:@"0"];
                
                // [self changeStatusWithValue:@"0" WithStringReservation:@"Both"];
            });
        });
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    if (APPDELEGATE.hubConnection)
    {
        [APPDELEGATE.hubConnection stop];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self checkUserInApp];
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection reconnecting];
    }
    else{
        [self signalRHubCall];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (  sharedInstance.isUserLoginManualyy) {
        if (sharedInstance.isUserLogoutManualyy) {
        }
        else
        {
            if (APPDELEGATE.hubConnection) {
                [APPDELEGATE.hubConnection start];
                [APPDELEGATE.hubConnection reconnecting];
                
            }
            else
            {
                [self signalRHubCall];
            }
        }
    }
    application.applicationIconBadgeNumber = 0;
}

#pragma mark Check user already login

- (void)checkUserInApp
{
    NSString *userIdString = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdString,@"UserID",nil];
    [ServerRequest requestWithUrl:APIGetBackgroutLogoutDeviceIdCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response objeIDct Get Comments List %@",responseObject);
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                NSString *deviceIDStr = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] valueForKey:@"Device"]];
                NSString *userIDStringValue = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"result"] valueForKey:@"UserId"]];
                NSDictionary *dataDictionary = @{@"Device":deviceIDStr,@"UserId":userIDStringValue};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CheckUserAlreadyLogin" object:self userInfo:dataDictionary];
            }
            else
            {
            }
        }
        else
        {
            NSLog(@"Hello World!");
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self changeStatusWithValue:@"0" WithStringReservation:@"Both"];
    });
}

-(void)changeStatusWithValue:(NSString *)onlineValue WithStringReservation:(NSString *)flagValue{
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,onlineValue,@"0",latitudeStr,lonitudeStr,deviceTokenStr,flagValue];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                NSLog(@"STATUS CHANGE SUCCESFULLY SUCCESS");
            }
        }
    }];
}

-(void)changeStatusWithValue:(NSString *)str{
    
    sharedInstance = [SingletonClass sharedInstance];
    NSString  *userIdString = sharedInstance.userId;
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdString,str,@"0",latitudeStr,lonitudeStr,deviceTokenStr,@"Online"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error)
        {
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                NSLog(@"STATUS CHANGE SUCCESFULLY SUCCESS");
            }
        }
    }];
}


#pragma mark Connect to SignalRHub
- (void)signalRHubCall {
    
    // SignalR Code Here
    //http://ondemandapinew.flexsin.in/signalr/hubs
    //http://ondemandapiqa.flexsin.in/signalr/hubs
    APPDELEGATE.hubConnection = [SRHubConnection connectionWithURLString:SignalRBaseUrl];
    APPDELEGATE.hubConnection.delegate = self;
    SRHubProxy *chat = [APPDELEGATE.hubConnection createHubProxy:@"RtcHub"];
    [chat on:@"notifybeginCall" perform:self selector:@selector(notifybeginCall:)];
    
    // Register for connection lifecycle events
    [APPDELEGATE.hubConnection setStarted:^{
        NSLog(@"Connection Started");
    }];
    
    [APPDELEGATE.hubConnection setReceived:^(NSString *message) {
        NSLog(@"Connection Recieved Data: %@",message);
        
    }];
    [APPDELEGATE.hubConnection setConnectionSlow:^{
        NSLog(@"Connection Slow");
    }];
    [APPDELEGATE.hubConnection setReconnecting:^{
        NSLog(@"Connection Reconnecting");
        
        [APPDELEGATE.hubConnection reconnecting];
        // NSLog(@"Application ")
        // [APPDELEGATE.hubConnection stop];
        // [self signalRHubCall];
    }];
    
    [APPDELEGATE.hubConnection setReconnected:^{
        NSLog(@"Connection Reconnected");
        
    }];
    [APPDELEGATE.hubConnection setClosed:^{
        NSLog(@"KEEP AlIVE DATE %@",APPDELEGATE.hubConnection.keepAliveData);
        NSLog(@"Connection Closed");
        [self signalRHubCall];
        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //                [self changeStatusWithValue:@"0"];
        //            });
    }];
    [APPDELEGATE.hubConnection setError:^(NSError *error) {
        NSLog(@"Connection Error %@",error);
    }];
    // Start the connection
    [APPDELEGATE.hubConnection start];
}


@end
