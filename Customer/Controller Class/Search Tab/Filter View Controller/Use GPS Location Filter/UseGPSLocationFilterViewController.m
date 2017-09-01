
//  UseGPSLocationFilterViewController.m
//  Customer
//  Created by Jamshed Ali on 23/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "UseGPSLocationFilterViewController.h"
#import "AddressAutoCompleteViewController.h"
#import "CommonUtils.h"
#import "ServerRequest.h"
#import "AlertView.h"
#import "AppDelegate.h"

@interface UseGPSLocationFilterViewController ()<AutoLocationDelegtae,CLLocationManagerDelegate> {
    SingletonClass *sharedInstance;
}
@end

@implementation UseGPSLocationFilterViewController

#pragma mark:- UIView Controller LifeCycle Methode
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    if (locationAllowed) {
        
        NSString *latitudeStr = sharedInstance.latiValueStr;
        NSString *lonitudeStr = sharedInstance.longiValueStr;
        if ([latitudeStr length] && [lonitudeStr length]) {
            if (sharedInstance.checkLocationAutoOrGPS == NO) {
                [gpsOnOffSwitch setOn:YES animated:YES];
                sharedInstance.checkLocationAutoOrGPS = NO;
                locationView.hidden = YES;
            }
            else{
                [gpsOnOffSwitch setOn:NO animated:YES];
                locationView.hidden = NO;
                sharedInstance.checkLocationAutoOrGPS = YES;
            }
            [self setLocationValue];
        }
        else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"We did not fetch your location.Do you want again to find the location?"
                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   if ([buttonTitle isEqualToString:@"Yes"]) {
                                                       if ([APPDELEGATE locationManager] != nil) {
                                                           [[APPDELEGATE locationManager] startUpdatingLocation];
                                                           
                                                       }
                                                       else {
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
    else{
        sharedInstance.latiValueStr = @"28.616789";
        sharedInstance.longiValueStr = @"77.74756";
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LocationDataValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           }];
    }
    
}

#pragma mark:- ADD Some Additional Method
-(void)setLocationValue {
    
    NSLog(@"Address Value %@",sharedInstance.selectedAddressStr);
    if (sharedInstance.selectedAddressStr.length == 0) {
        NSLog(@"Address Value %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"LocationDataValue"]);
        NSString *locationStrValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationDataValue"];
        [selectedAddressLabel setText:locationStrValue];
        selectedAddressLabel.adjustsFontSizeToFitWidth = YES;
        selectedAddressLabel.minimumScaleFactor = 13;
    }
    else{
        [selectedAddressLabel setText:sharedInstance.selectedAddressStr];
        selectedAddressLabel.adjustsFontSizeToFitWidth = YES;
        selectedAddressLabel.minimumScaleFactor = 13;
    }
}

-(void)locationString :(NSString*)str   {
    
    NSLog(@"location String%@",str);
    [[NSUserDefaults standardUserDefaults]setValue:str forKey:@"AutoLocation"];
    sharedInstance.selectedAddressStr = str;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark:- Memory Menagement Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- UIButton Action   Method

- (IBAction)gpsLocationOnOff:(id)sender {
    
    if([sender isOn]) {
        
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        locationView.hidden = YES;
        sharedInstance.selectedAddressStr = @"";
        sharedInstance.checkLocationAutoOrGPS = NO;
    }
    else {
        
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        locationView.hidden = NO;
        sharedInstance.checkLocationAutoOrGPS = YES;
    }
    [self setLocationValue];
}


- (IBAction)backBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)selectAddressOrPincode:(id)sender {
    AddressAutoCompleteViewController *gpsLocationView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressAutoCompleteView"];
    gpsLocationView.delegate = self;
    gpsLocationView.isFromGPSLocation = YES;
    gpsLocationView.isFromRequestNow = NO;
    [self.navigationController pushViewController:gpsLocationView animated:YES];
    
    
}


@end
