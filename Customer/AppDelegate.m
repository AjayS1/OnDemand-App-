
//  AppDelegate.m
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AppDelegate.h"

#define SYSTEM_VERSION                  [[UIDevice currentDevice].systemVersion floatValue]

@interface AppDelegate () <CLLocationManagerDelegate>{
    NSTimer *timer;
    SingletonClass *sharedInstance;
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    sharedInstance = [SingletonClass sharedInstance];
    [self getLongitudeAndLatitude];
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    //--1) Camera Screenshot Warnnig **************
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *note) {
                                                      // executes after screenshot
                                                      self.window.backgroundColor = [UIColor greenColor];
                                                      NSLog(@"Screenshot Detection : %@", note);
                                                      UIAlertView *screenshotAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"It is prohibited to take screenshots in the Doumee App. If you continue to do so, your account will be blocked." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                      [screenshotAlert show];
                                                  }];
    
    APPDELEGATE.searchCountString = @"0";
    //--2) Push Notification **************
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        //[application registerForRemoteNotifications];
    }
    else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //Get App Version Number
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"Version Number %@",version);
    sharedInstance.appVersionNumber = version;
    
    //--3) Get IP Address **************
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
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
    
    freeifaddrs(interfaces);
    NSLog(@"IP Address is ==== %@",address);
    if (!address) {
        address = @"";
    }
    sharedInstance.ipAddressStr = address;
    NSLog(@"IP Address is ==== %@",sharedInstance.ipAddressStr);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:ivc];
    self.window.rootViewController = navigationController;
    navigationController.navigationBarHidden=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationUpdateValue)
                                                 name:@"loactionUpdate"
                                               object:nil];
    [self.window makeKeyAndVisible];
    [Fabric with:@[[Crashlytics class]]];
    [self logUser];
    return YES;
}

- (void) logUser {
    
    // TODO: Use the current user's information
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:@"Helloworld#1"];
    [CrashlyticsKit setUserEmail:@"aditi_tiwari@seologistics.com"];
    [CrashlyticsKit setUserName:@"Test User"];
}

-(void)locationUpdateValue {
    [self.locationManager startUpdatingLocation];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark-- CLLocation Manager Method :
-(void)getLongitudeAndLatitude {
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    if(IS_OS_8_OR_LATER) {
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
    else {
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        longitude_Reg = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        latitude_Reg = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        NSLog(@"latitude_Reg is: %@, longitude_Reg is: %@", latitude_Reg,longitude_Reg);
        sharedInstance.latiValueStr = latitude_Reg;
        sharedInstance.longiValueStr = longitude_Reg;
        sharedInstance.locationShareYesOrNO = YES;
        [self.locationManager stopUpdatingLocation];
        //Reverse Geocoding
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *_placemarks, NSError *error) {
            
            if (error == nil && [_placemarks count] > 0) {
                
                self.placemark = [_placemarks lastObject];
                countryIOSCode =[NSString stringWithFormat:@"%@", self.placemark.ISOcountryCode];
                [[NSUserDefaults standardUserDefaults] setObject:countryIOSCode forKey:@"CountryISOCode"];
                NSLog(@"Country ISO Code is: %@", countryIOSCode);
                [[NSUserDefaults standardUserDefaults]setObject:countryIOSCode forKey:@"CountryISOCode"];
                userLocation = [NSString stringWithFormat:@"%@",self.placemark.locality];
                NSString *addressStr =   [NSString stringWithFormat:@"%@", self.placemark.addressDictionary];
                NSString *locationDetailValue =[NSString stringWithFormat:@"%@,%@,%@,%@", self.placemark.locality, self.placemark.administrativeArea,self.placemark.country,self.placemark.postalCode];
                [[NSUserDefaults standardUserDefaults] setValue:locationDetailValue forKey:@"LocationDataValue"];
                [[NSUserDefaults standardUserDefaults] synchronize ];
                NSString *addressDetailsStr =  [NSString stringWithFormat:@"name =%@, thoroughfare = %@, locality =%@, subLocality = %@, administrativeArea = %@,  postalCode = %@ , subThoroughfare = %@", self.placemark.name, self.placemark.thoroughfare, self.placemark.locality, self.placemark.subLocality,self.placemark.administrativeArea, self.placemark.postalCode, self.placemark.subThoroughfare];
                NSString *locatedAt = [[_placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                
                sharedInstance.cityValueStr = userLocation;
                if (!userLocation) {
                    sharedInstance.cityValueStr = self.placemark.subAdministrativeArea;
                }
                
                if ( [ self.placemark.country length]) {
                    sharedInstance.countryValueStr = self.placemark.country;
                }
                else{
                    sharedInstance.countryValueStr = @"";
                }
                if ( [ self.placemark.administrativeArea length]) {
                    sharedInstance.stateValueStr = self.placemark.administrativeArea;
                }
                else{
                    sharedInstance.stateValueStr = @"";
                }
                if ( [ self.placemark.postalCode length]) {
                    sharedInstance.zipValueStr = self.placemark.postalCode;
                }
                else{
                    sharedInstance.zipValueStr = @"";
                }
                if ( [ self.placemark.subAdministrativeArea length]) {
                    sharedInstance.districtValueStr = self.placemark.subAdministrativeArea;
                }
                else{
                    sharedInstance.districtValueStr = @"";
                }
                sharedInstance.locationValueStr = [NSString stringWithFormat:@"%@,%@", self.placemark.name, self.placemark.locality];
                if ([_placemark.name length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else{
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                    
                }
                if ([_placemark.locality length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else{
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                    
                }
                
                if ([_placemark.subLocality length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else
                {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                    
                }
                
                if ([_placemark.subAdministrativeArea length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else
                {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                    
                }
                if ([_placemark.administrativeArea length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else
                {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                    
                }
                
                if ([_placemark.country length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else
                {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea, _placemark.postalCode];
                    
                }
                
                if ([_placemark.postalCode length] ) {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                }
                else
                {
                    sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country];
                    
                }
                
                if ([_placemark.name length] ) {
                    if ([_placemark.locality length] && (![_placemark.locality isEqualToString:@"null"])) {
                        if ([_placemark.subLocality length] && (![_placemark.subLocality isEqualToString:@"null"])) {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else
                                        {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country];
                                        }
                                    }
                                    else
                                    {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea, _placemark.postalCode];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        
                                    }
                                }
                            }
                            else
                            {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                        else
                        {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    else
                    {
                        if ([_placemark.subLocality length] && (![_placemark.subLocality isEqualToString:@"null"])) {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        
                                    }
                                }
                            }
                            //
                            else
                            {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else{
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
                                        }
                                        
                                    }
                                    else{
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else{
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.name,_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if ([_placemark.locality length] && (![_placemark.locality isEqualToString:@"null"])) {
                        if ([_placemark.subLocality length] && (![_placemark.subLocality isEqualToString:@"null"])) {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        if ([_placemark.subLocality length] && (![_placemark.subLocality isEqualToString:@"null"])) {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else{
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
                                        }
                                        
                                    }
                                    else{
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else{
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if ([_placemark.subAdministrativeArea length] && (![_placemark.subAdministrativeArea isEqualToString:@"null"])) {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subAdministrativeArea,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                if ([_placemark.administrativeArea length] && (![_placemark.administrativeArea isEqualToString:@"null"])) {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.administrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                    }
                                }
                                else
                                {
                                    if ([_placemark.country length] && (![_placemark.country isEqualToString:@"null"])) {
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else{
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
                                        }
                                        
                                    }
                                    else{
                                        if ([_placemark.postalCode length] && (![_placemark.postalCode isEqualToString:@"null"])) {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country, _placemark.postalCode];
                                        }
                                        else
                                        {
                                            sharedInstance.currentAddressStr = [NSString stringWithFormat:@"%@,%@,%@,%@",_placemark.locality,_placemark.subLocality,_placemark.subAdministrativeArea,_placemark.country];
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
                NSLog(@"%@",  sharedInstance.currentAddressStr);
                NSLog(@"userLocation is: %@", sharedInstance.cityValueStr);
                NSLog(@"addressDetailsStr is: %@", addressDetailsStr);
                NSLog(@"address is: %@", sharedInstance.locationValueStr );
                NSLog(@"addressStr is: %@", addressStr);
                
            }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
        
        NSLog(@"Country ISO Code is: %@", self.placemark.ISOcountryCode);
        NSLog(@"Longitude is: %.8f", currentLocation.coordinate.longitude);
        NSLog(@"Latitude is: %.8f", currentLocation.coordinate.latitude);
    }
    [self stopSignificantChangesUpdates];
    
}

-(BOOL)isNullOrEmpty:(NSString *)inString {
    BOOL retVal = YES;
    if((inString != nil )&&(inString != NULL) && (![inString isEqualToString:@"null"]))
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if([CLLocationManager locationServicesEnabled]) {
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            NSLog(@"Permission Denied");
            sharedInstance.locationShareYesOrNO = NO;
        }
        else {
            NSLog(@"Enabled");
        }
    }
}


- (void)countdownTimer:(NSTimer *)timer {
    
    NSString *userIdStr = sharedInstance.userId;
    NSLog(@"userIdStr == %@",userIdStr);
    if ([userIdStr isKindOfClass:[NSString class]]) {
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&latitude=%@&longitude=%@",APIUserLocationUpdateApiCall,userIdStr,latitude_Reg,longitude_Reg];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                } else
                {
                }
            }
            else
            {
                NSLog(@"Error");
            }
        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Hello");
        //  [self getLongitudeAndLatitude];
    }
    else if ((status == kCLAuthorizationStatusAuthorizedAlways )|| (status == kCLAuthorizationStatusAuthorizedWhenInUse) ){
        sharedInstance.locationShareYesOrNO = YES;
        
        if (_locationManager != nil) {
            [_locationManager startUpdatingLocation];
        }
        else {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)stopSignificantChangesUpdates{
    
    if (nil == self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    [self.locationManager stopMonitoringSignificantLocationChanges];
}


#pragma mark ---Push Notification **************************

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *tokenStr = [deviceToken description];
    NSString *pushToken = [[[tokenStr
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    sharedInstance.deviceToken = pushToken;
    NSLog(@" Did Register for Remote Notifications with Device Token %@", sharedInstance.deviceToken);
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    
    if(IS_OS_8_OR_LATER) {
        // code here
        NSLog(@"User Info : %@",response.notification.request.content.userInfo);
        for (id key in response.notification.request.content.userInfo) {
            NSLog(@"key: %@, value: %@", key, [response.notification.request.content.userInfo objectForKey:key]);
        }
        NSString *typeStr = [NSString stringWithFormat:@"%@",[response.notification.request.content.userInfo objectForKey:@"Type"]];
        if ([typeStr isEqualToString:@"7"] || [typeStr isEqualToString:@"11"] || [typeStr isEqualToString:@"5"] ||[typeStr isEqualToString:@"3"] ||[typeStr isEqualToString:@"16"]) {
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
            NSString *typeStr = [NSString stringWithFormat:@"%@",[response.notification.request.content.userInfo objectForKey:@"Type"]];
            NSLog(@"typeStr %@",typeStr);
            // if ([typeStr isEqualToString:@"18"]|| [typeStr isEqualToString:@"10"]) {
            NSString *userIdStr = sharedInstance.userId;
            NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
            [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get Comments List %@",responseObject);
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        NSDictionary *countDataDict = [responseObject objectForKey:@"result"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCount" object:self userInfo:countDataDict];
                    }
                    else{
                    }
                }
                else
                {
                }
            }];
        }
        
        UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
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
            //--1) Custom ALAlertBannerStyleNotify Push Notification **************
            ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
            ALAlertBannerPosition position = ALAlertBannerPositionTop;
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees"] subtitle:[[response.notification.request.content.userInfo objectForKey:@"aps"] objectForKey:@"alert"] tappedBlock:^(ALAlertBanner *alertBanner) {
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
        else {
            
            self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
                NSLog(@"lapsed: %f", lapse);
                NSLog(@"muted: %d", muted);
                if (muted) {
                    
                    NSLog(@"vibratePhone %@",@"here");
                    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]){
                        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                    }
                    else {
                        AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                    }
                }
            }];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"UserInfo is --%@",userInfo);
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSString *typeStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"Type"]];
    if ([typeStr isEqualToString:@"7"] || [typeStr isEqualToString:@"11"] || [typeStr isEqualToString:@"5"] ||[typeStr isEqualToString:@"3"] ||[typeStr isEqualToString:@"16"]) {
        sharedInstance.isFromCancelDateRequest = TRUE;
    }
    else{
        sharedInstance.isFromCancelDateRequest = FALSE;
    }
    
    if ([sharedInstance.refreshApiCallOrNotStr isEqualToString:@"yes"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"apiRefreshCall" object:self userInfo:nil];
    }
    else {
        
        NSString *typeStr = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"Type"]];
        NSLog(@"typeStr %@",typeStr);
        NSString *userIdStr = sharedInstance.userId;
        NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
        [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get Comments List %@",responseObject);
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSDictionary *countDataDict = [responseObject objectForKey:@"result"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationCount" object:self userInfo:countDataDict];
                }
                else{
                    
                }
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
        //--1) Custom ALAlertBannerStyleNotify Push Notification **************
        ALAlertBannerStyle randomStyle = ALAlertBannerStyleNotify;
        ALAlertBannerPosition position = ALAlertBannerPositionTop;
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:self.window style:randomStyle position:position title:[NSString stringWithFormat:@"%@",@"Doumees"] subtitle:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] tappedBlock:^(ALAlertBanner *alertBanner) {
            NSLog(@"tapped!");
            [alertBanner hide];
            if([[userInfo objectForKey:@"aps"] objectForKey:@"current_user_id"]) {
            }
        }];
        banner.secondsToShow = 3.5;
        banner.showAnimationDuration = 0.25;
        banner.hideAnimationDuration = 0.2;
        [banner show];
    }
    else
    {
        self.muteChecker = [[MuteChecker alloc] initWithCompletionBlk:^(NSTimeInterval lapse, BOOL muted) {
            NSLog(@"lapsed: %f", lapse);
            NSLog(@"muted: %d", muted);
            if (muted) {
                
                NSLog(@"vibratePhone %@",@"here");
                if([[UIDevice currentDevice].model isEqualToString:@"iPhone"]){
                    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                }
                else
                {
                    AudioServicesPlayAlertSound (kSystemSoundID_Vibrate);
                }
            }
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.hubConnection) {
        [self.hubConnection  stop];
    }
}

- (void)UIApplicationUserDidTakeScreenshot:(UIApplication *)application {
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Hey!"
                                                     message:@"You're not allowed to do that"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles: nil];
    [alert addButtonWithTitle:@"GO"];
    [alert show];
    return;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkUserInApp];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Check user already login
- (void)checkUserInApp {
    
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
            else{
            }
        }
        else
        {
        }
    }];
}
#pragma mark Connect to SignalRHub
- (void)signalRHubCall {
    
    // SignalR Code Here
    
    //http://ondemandapinew.flexsin.in/signalr/hubs
    //http://ondemandapiqa.flexsin.in/signalr/hubs
    APPDELEGATE.hubConnection = [SRHubConnection connectionWithURLString:SignalRBaseUrl];
    //APPDELEGATE.hubConnection = [SRHubConnection connectionWithURLString:@"http://ondemandapinew.flexsin.in/signalr/hubs"];
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
        if (sharedInstance.isUserLogoutManualyy) {
            
        }
        else
        {
            if (APPDELEGATE.hubConnection) {
                if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive) {
                    [APPDELEGATE.hubConnection start];
                    [APPDELEGATE.hubConnection reconnecting];
                }
                else{
                    NSLog(@"App Is in Background State");
                }
            }
            else
            {
                [self signalRHubCall];
            }
        }        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
