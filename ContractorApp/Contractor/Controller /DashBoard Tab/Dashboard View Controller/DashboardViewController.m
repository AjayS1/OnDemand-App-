
//  DashboardViewController.m
//  Contractor
//  Created by Jamshed Ali on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DashboardViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "MessagesViewController.h"

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ServerRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "AlertView.h"
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface DashboardViewController ()<CLLocationManagerDelegate> {
    
    NSDictionary *profileDic;
    NSString *goOnlineOfflineStr;
    NSString *hiddenProfileStr;
    id signalReceivedData;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSString *onlineOfflineStatus ;
    NSDateFormatter *dateFormatter;
}
@property (weak, nonatomic) IBOutlet UIButton *onlineButton;
@end
@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    dateFormatter = [[NSDateFormatter alloc]init];
    _profileImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _profileImageView.layer.cornerRadius=_profileImageView.frame.size.height/2;
    _profileImageView.layer.borderWidth=2.0;
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
    _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _onlineOfflineButton.layer.cornerRadius=3;
    _onlineOfflineButton.layer.borderWidth=2.0;
     [self.showOnlineButton setExclusiveTouch:YES];
    _onlineOfflineButton.layer.masksToBounds = YES;
    _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
    _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
    _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
    _circleOnlineOfflineView.layer.masksToBounds = YES;
    // [self getCurrentDateAndTime];
}



-(void )getCurrentDateAndTime{
    
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    float timeZone =[destinationTimeZone secondsFromGMTForDate:sourceDate];
    float timeZoneOffset = timeZone / 3600.0;
    NSLog(@"sourceDate=%@ timeZoneOffset=%f", sourceDate, timeZoneOffset);
       NSString *currentDateAndTime = [NSString stringWithFormat:@"sourceDate=%@ timeZoneOffset=%f", sourceDate, timeZoneOffset];
    NSLog(@"Esstimate Value %@",currentDateAndTime);

    NSLog(@"timeZone %@", [destinationTimeZone abbreviation]);

}

#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //Log: dateString - 2016-03-08 06:00:00 // Time in UTC
    //dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    NSLog(@"DayLightValue %d",isDayLightSavingTime);
    //    if (isDayLightSavingTime) {
    //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
    //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    //    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    
    return dateRepresentation;
}


-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/YYYY hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tabBarController.tabBar setHidden:NO];
    self.navigationController.navigationBar.hidden=YES;
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiCallRefreshScreen:)
                                                 name:@"apiRefreshCall"
                                               object:nil];
    
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [self getProfileInfoApiCall];
  //  [self getCurrentAddressOfClient];
    
}
//-(void)getCurrentAddressOfClient {
//    
//    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:34.11922076970851 longitude:-118.1347215302915];
//      //   /*
//    //Reverse Geocoding
//    CLGeocoder *geoCod = [[CLGeocoder alloc]init];
//    [geoCod reverseGeocodeLocation:LocationAtual completionHandler:^(NSArray *placemarks, NSError *error) {
//        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
//        
//        if (error == nil && [placemarks count] > 0) {
//            
//           CLPlacemark *placemark = [placemarks lastObject];
//          //  countryIOSCode =[NSString stringWithFormat:@"%@", placemark.ISOcountryCode];
//          //  [[NSUserDefaults standardUserDefaults] setObject:countryIOSCode forKey:@"CountryISOCode"];
//            //   NSLog(@"Country ISO Code is: %@", countryIOSCode);
//            
//          //  userLocation = [NSString stringWithFormat:@"%@",placemark.locality];
//            //   NSLog(@"userLocation is: %@", userLocation);
//            NSString *addressStr =   [NSString stringWithFormat:@"%@", placemark.addressDictionary];
//            
//            NSString *addressDetailsStr =  [NSString stringWithFormat:@"name =%@, thoroughfare = %@, locality =%@, subLocality = %@, administrativeArea = %@,  postalCode = %@ , subThoroughfare = %@", placemark.name, placemark.thoroughfare,placemark.locality,placemark.subLocality,placemark.administrativeArea, placemark.postalCode,placemark.subThoroughfare];
//            NSLog(@"%@",addressStr);
//            NSLog(@"%@",addressDetailsStr);
//            
//            if ([placemark.locality length] ) {
//                sharedInstance.clientCurrentAddress = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,@"",placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea, placemark.postalCode];
//            }
//            else{
//                sharedInstance.clientCurrentAddress = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
//                
//            }
//            if ([placemark.subAdministrativeArea length] ) {
//                sharedInstance.clientCurrentAddress = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.administrativeArea,placemark.country, placemark.postalCode];
//            }
//            else
//            {
//                sharedInstance.clientCurrentAddress = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",placemark.name,placemark.locality,placemark.subLocality,placemark.subAdministrativeArea,placemark.administrativeArea,placemark.country, placemark.postalCode];
//                
//            }
//            NSLog(@"%@",  sharedInstance.clientCurrentAddress);
//            
//            
//            //                sharedInstance.cityValueStr = userLocation;
//            //                sharedInstance.countryValueStr = placemark.country;
//            //                sharedInstance.stateValueStr = placemark.administrativeArea;
//            //                sharedInstance.zipValueStr = placemark.postalCode;
//            //                sharedInstance.districValue = placemark.subAdministrativeArea;
//            
//            //    NSLog(@"addressStr is: %@", addressStr);
//            
//        } else {
//            NSLog(@"%@", error.debugDescription);
//        }
//    } ];
//    
//    //  [self stopSignificantChangesUpdates];
//    
//}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    sharedInstance.IsFromDateDetailsOnDemand = NO;
}


- (void)apiCallRefreshScreen:(NSNotification*) noti {
    [self getProfileInfoApiCall];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    sharedInstance.refreshApiCallOrNotStr = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"apiRefreshCall"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkSignalRReqest:(NSNotification*) noti {
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        [self.navigationController pushViewController:dateDetailsView animated:YES];
    }
    else {
    }
}

- (IBAction)onlineButtonClicked:(id)sender {
    if ([sharedInstance.isDuePaymentValueStr isEqualToString:@"1"]) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Cannot Go Online" message:@"You cannot Go Online because\nyour account is on Hold status."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               
                                             //  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //[self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
    else{
    if ([goOnlineOfflineStr isEqualToString:@"1"]) {
        goOnlineOfflineStr = @"0";
    }
    else {
        goOnlineOfflineStr = @"1";
    }
    
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        
        if ([latitudeStr length] && [lonitudeStr length]) {
            NSString *deviceTokenStr = sharedInstance.deviceToken;
            if (!deviceTokenStr) {
                deviceTokenStr = @"";
            }
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,goOnlineOfflineStr,hiddenProfileStr,latitudeStr,lonitudeStr,deviceTokenStr,@"Online"];
            NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if(!error){
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                        [self profileStatusChange];
                    }
                    else {
                        [CommonUtils showAlertWithTitle:@"Cannot Go Online" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                } else {
                    
                    if ([goOnlineOfflineStr isEqualToString:@"1"]) {
                        goOnlineOfflineStr = @"0";
                    } else {
                        goOnlineOfflineStr = @"1";
                    }
                }
            }];
        }
        else
        {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"We did not fetch your location.Do you want again to find the location?"
                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   if ([buttonTitle isEqualToString:@"Yes"]) {
                                                       if ([APPDELEGATE locationManager] != nil) {
                                                           [[APPDELEGATE locationManager] startUpdatingLocation];
                                                           
                                   APPDELEGATE.locationManager= [[CLLocationManager alloc] init];
                                                           APPDELEGATE.locationManager.delegate = self;
                                                           APPDELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                                                           [APPDELEGATE.locationManager requestWhenInUseAuthorization];
                                                           [APPDELEGATE.locationManager startUpdatingLocation];
                                                       }
                                                   }
                                               }];
            
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults ] removeObjectForKey:@"LATITUDEDATA"];
        [[NSUserDefaults standardUserDefaults ] removeObjectForKey:@"LONGITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Is Off" message:@"Your location sharing is turned off. Your location is required to Go Online."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               //[self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
        
    }
    
    }
}

- (IBAction)profileHideShow:(id)sender {
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
    } else{
        NSLog(@"Switch is OFF");
    }
    
    if ([hiddenProfileStr isEqualToString:@"1"]) {
        hiddenProfileStr = @"0";
    } else {
        hiddenProfileStr = @"1";
    }
    
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        if (!latitudeStr) {
            latitudeStr = @"28.6242";
        }
        
        if (!lonitudeStr) {
            lonitudeStr = @"77.3834";
        }
        
        NSString *deviceTokenStr = sharedInstance.deviceToken;
        
        if (!deviceTokenStr) {
            deviceTokenStr = @"";
        }
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,goOnlineOfflineStr,hiddenProfileStr,latitudeStr,lonitudeStr,deviceTokenStr,@"Reservation"];
        NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"OK"]) {
                             [self getProfileInfoApiCallForAnotherPurpose];
                             
                         }}];
                    
                } else {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            else {
                
                if ([hiddenProfileStr isEqualToString:@"1"]) {
                    hiddenProfileStr = @"0";
                } else {
                    hiddenProfileStr = @"1";
                }
            }
        }];
    }
    else{
        [[NSUserDefaults standardUserDefaults ] removeObjectForKey:@"LATITUDEDATA"];
        [[NSUserDefaults standardUserDefaults ] removeObjectForKey:@"LONGITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               // [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
    
}

-(void)obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)changeStatusWithValue:(NSString *)str{
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,str,@"0",latitudeStr,lonitudeStr,deviceTokenStr,@"Online"];
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

-(void)reservationStatusChange{
    
}

- (void)profileStatusChange {
    
    if ([goOnlineOfflineStr isEqualToString:@"1"]) {
        
        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _onlineOfflineButton.layer.cornerRadius=3;
        _onlineOfflineButton.layer.borderWidth=2.0;
        _onlineOfflineButton.layer.masksToBounds = YES;
        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6] forState:UIControlStateNormal];
        [_onlineOfflineButton setTitle:@"ONLINE" forState:UIControlStateNormal];
        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
        _circleOnlineOfflineView.layer.masksToBounds = YES;
        onlineOfflineStatus = @"Online";
        APPDELEGATE.isOfflineValue = false;
        sharedInstance.checkThatUserIsOnline = YES;

        [[NSUserDefaults standardUserDefaults] setValue:@"20" forKey:@"ContrctorOnlineOrOffline"];
        [[NSUserDefaults standardUserDefaults] synchronize ];
        [_showOnlineButton setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
    }
    else {
        
        goOnlineOfflineStr = @"0";
        APPDELEGATE.isOfflineValue = true;
        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _onlineOfflineButton.layer.cornerRadius=3;
        _onlineOfflineButton.layer.borderWidth=2.0;
        _onlineOfflineButton.layer.masksToBounds = YES;
        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6] forState:UIControlStateNormal];
        [_onlineOfflineButton setTitle:@"OFFLINE" forState:UIControlStateNormal];
        onlineOfflineStatus = @"Online";
        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
        _circleOnlineOfflineView.layer.masksToBounds = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"10" forKey:@"ContrctorOnlineOrOffline"];
        [[NSUserDefaults standardUserDefaults] synchronize ];
        sharedInstance.checkThatUserIsOnline = NO;

        [_showOnlineButton setTitle:@"GO ONLINE" forState:UIControlStateNormal];
    }
}


- (void)getProfileInfoApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?UserID=%@",APIAccountUserInfo,userIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    profileDic = [responseObject objectForKey:@"result"];
                    userNameLabel.text = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"UserName"]];
                    rateLabel.text = [NSString stringWithFormat:@"%.1f",[[profileDic valueForKey:@"Rating"] floatValue]];
                    NSString *imageData = [profileDic valueForKey:@"UserPhoto"];
                    NSURL *imageUrl = [NSURL URLWithString:imageData];
                    [_profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    hiddenProfileStr = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"isReservationAllowed"]];
                    if ([hiddenProfileStr isEqualToString:@"1"]) {
                        [profileHideShowSwitch setOn:YES animated:YES];
                        hiddenProfileStr = @"1";
                        sharedInstance.checkThatUserReservationOnline = YES;

                    }
                    else {
                        
                        [profileHideShowSwitch setOn:NO animated:YES];
                        sharedInstance.checkThatUserReservationOnline = NO;
                        hiddenProfileStr = @"0";
                    }
                    
                    goOnlineOfflineStr = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"IsOnline"]];
                    
                    if ([goOnlineOfflineStr isEqualToString:@"1"]) {
                        
                        APPDELEGATE.isOfflineValue = false;
                        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        _onlineOfflineButton.layer.cornerRadius=3;
                        _onlineOfflineButton.layer.borderWidth = 2.0;
                        _onlineOfflineButton.layer.masksToBounds = YES;
                        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6] forState:UIControlStateNormal];
                        [_onlineOfflineButton setTitle:@"ONLINE" forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
                        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
                        _circleOnlineOfflineView.layer.masksToBounds = YES;
                        [_showOnlineButton setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
                        sharedInstance.checkThatUserIsOnline = YES;
                        
                    }
                    else {
                        
                        APPDELEGATE.isOfflineValue = true;
                        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        _onlineOfflineButton.layer.cornerRadius=3;
                        _onlineOfflineButton.layer.borderWidth=2.0;
                        _onlineOfflineButton.layer.masksToBounds = YES;
                        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitle:@"OFFLINE" forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6] forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
                        _circleOnlineOfflineView.layer.masksToBounds = YES;
                        onlineOfflineStatus = @"Online";
                        [_showOnlineButton setTitle:@"GO ONLINE" forState:UIControlStateNormal];
                        sharedInstance.checkThatUserIsOnline = NO;

                    }
                }
                else{
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            else
            {
                
                NSLog(@"Error is found");
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Request time out." inController:self];
            }
        }
    }];
}

- (void)getProfileInfoApiCallForAnotherPurpose {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?UserID=%@",APIAccountUserInfo,userIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",nil];
   // [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
       // [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    profileDic = [responseObject objectForKey:@"result"];
                    userNameLabel.text = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"UserName"]];
                    rateLabel.text = [NSString stringWithFormat:@"%.1f",[[profileDic valueForKey:@"Rating"] floatValue]];
                    NSString *imageData = [profileDic valueForKey:@"UserPhoto"];
                    NSURL *imageUrl = [NSURL URLWithString:imageData];
                    [_profileImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    hiddenProfileStr = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"isReservationAllowed"]];
                    if ([hiddenProfileStr isEqualToString:@"1"]) {
                        [profileHideShowSwitch setOn:YES animated:YES];
                        hiddenProfileStr = @"1";
                        sharedInstance.checkThatUserReservationOnline = YES;
                        
                    }
                    else {
                        
                        [profileHideShowSwitch setOn:NO animated:YES];
                        sharedInstance.checkThatUserReservationOnline = NO;
                        hiddenProfileStr = @"0";
                    }
                    
                    goOnlineOfflineStr = [NSString stringWithFormat:@"%@",[profileDic valueForKey:@"IsOnline"]];
                    
                    if ([goOnlineOfflineStr isEqualToString:@"1"]) {
                        
                        APPDELEGATE.isOfflineValue = false;
                        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        _onlineOfflineButton.layer.cornerRadius=3;
                        _onlineOfflineButton.layer.borderWidth = 2.0;
                        _onlineOfflineButton.layer.masksToBounds = YES;
                        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6] forState:UIControlStateNormal];
                        [_onlineOfflineButton setTitle:@"ONLINE" forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:19/255.0 green:145/255.0 blue:72/255.0 alpha:0.6].CGColor;
                        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
                        _circleOnlineOfflineView.layer.masksToBounds = YES;
                        [_showOnlineButton setTitle:@"GO OFFLINE" forState:UIControlStateNormal];
                        sharedInstance.checkThatUserIsOnline = YES;
                        
                    }
                    else {
                        
                        APPDELEGATE.isOfflineValue = true;
                        _onlineOfflineButton.layer.backgroundColor=[[UIColor clearColor] CGColor];
                        _onlineOfflineButton.layer.cornerRadius=3;
                        _onlineOfflineButton.layer.borderWidth=2.0;
                        _onlineOfflineButton.layer.masksToBounds = YES;
                        _onlineOfflineButton.layer.borderColor= [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitle:@"OFFLINE" forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.backgroundColor = [UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6].CGColor;
                        [_onlineOfflineButton setTitleColor:[UIColor colorWithRed:109/255.0 green:68/255.0 blue:126/255.0 alpha:0.6] forState:UIControlStateNormal];
                        _circleOnlineOfflineView.layer.cornerRadius=_circleOnlineOfflineView.frame.size.height/2;
                        _circleOnlineOfflineView.layer.masksToBounds = YES;
                        onlineOfflineStatus = @"Online";
                        [_showOnlineButton setTitle:@"GO ONLINE" forState:UIControlStateNormal];
                        sharedInstance.checkThatUserIsOnline = NO;
                        
                    }
                }
                else{
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            else
            {
                
                NSLog(@"Error is found");
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Request time out." inController:self];
            }
        }
    }];
}




@end
