
//  AppDelegate.h
//  Contractor
//  Created by Jamshed Ali on 17/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import  <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "MuteChecker.h"
#import  "ALAlertBanner.h"
#import "ALAlertBannerManager.h"
#import "LCTabBarController.h"
#import "SRConnection.h"
#import "SRHubConnectionInterface.h"
#import "SRConnectionDelegate.h"
#import "SRConnectionState.h"
#import <SignalR.h>
#import <SRConnection.h>
#import "SRWebSocket.h"
#import "ServerRequest.h"
#import "SRNegotiationResponse.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,AVAudioSessionDelegate,SRConnectionDelegate>
{
    NSString *latitude_Reg;
    NSString *longitude_Reg;
    NSString *userLocation;
    CLPlacemark *placemark;
    NSString *countryIOSCode;
    NSString *device_id;
}

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) SRHubConnection *hubConnection;
@property(strong, nonatomic) UINavigationController *navController;
@property(strong, nonatomic) NSString *requestTypeStr;
@property(strong, nonatomic) NSString *searchCountString;
@property (strong, nonatomic)  LCTabBarController *tabBarC;
@property (strong, nonatomic)  CLGeocoder *geocoder;
@property (nonatomic) CGRect controllerCropRect;
@property (nonatomic, strong) MuteChecker *muteChecker;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer *timer;
@property (assign) BOOL isOfflineValue;

@end

