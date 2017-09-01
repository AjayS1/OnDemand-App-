
//  AppDelegate.h
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UITabBarDelegate,SRConnectionDelegate> {
    
    NSString *latitude_Reg;
    NSString *longitude_Reg;
    CLGeocoder *geocoder;
    NSString *userLocation;
    NSString *countryIOSCode;
    NSString *device_id;
    UIImageView *imageView;
 
}

@property(strong, nonatomic) SRHubConnection *hubConnection;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) MuteChecker *muteChecker;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *countryCodeDict;
@property (strong, nonatomic) LCTabBarController *tabBarC;
@property(nonatomic,strong)UIImageView *imageView;
@property(assign)BOOL needToHide;
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)HomeTabBarViewController *homeViewController;
@property (strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSString *searchCountString;
@property(strong, nonatomic) NSMutableArray *imageDataArrayValue;

@end

