
//  ViewController.m
//  Contractor
//  Created by Jamshed Ali on 13/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "ViewController.h"
#import "SignUpViewController.h"
#import "DashboardViewController.h"
#import "DatesViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"
#import "ForgotPasswordViewController.h"
#import "DateDetailsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "LCTabBarCONST.h"
#import "LCTabBarController.h"
#import "SingletonClass.h"
#import "ServerRequest.h"
#import "Define.h"
#import "MuteChecker.h"
#import "RatingViewController.h"
#import <Crashlytics/Crashlytics.h>
#import  "ALAlertBanner.h"
#import "ALAlertBannerManager.h"
#import "AlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "NonSufficientVC.h"
#import "ChargeBackViewController.h"

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface ViewController ()<CLLocationManagerDelegate> {
    
    SingletonClass *sharedInstance;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    NSString *isDuePaymentStr;
    NSString *isDueDateIDStr;
    NSString *iOtherDeviceLoginValue;
    BOOL isCheckThatUSerisOnline;
}

@property (nonatomic, strong) MuteChecker *muteChecker;
@end

@implementation ViewController

#pragma mark:- UIViewController Life Cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.checkPushNotificationOnDemandStr = @"No";
    
    sharedInstance.onDemandPushNotificationArray = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden=YES;
    _emailTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _emailTextField.layer.borderWidth = 0.5;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _emailTextField.leftView = emailPaddingView;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _passwordTextField.layer.borderWidth = 0.5;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    _passwordTextField.leftView = passwordPaddingView;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    NSString *check=[[NSUserDefaults standardUserDefaults]objectForKey:@"check"];
    
    if([check isEqual:@"save"]){
        self.emailTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"email" ];
        self.passwordTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"password" ];
        [btnRememberMe setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        btnRememberMe.selected=YES;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUserAlreadyLogin:)
                                                 name:@"CheckUserAlreadyLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBadges:)
                                                 name:@"notificationCount"
                                               object:nil];
    
    [self createSlideToUnlockViewWithText:@"James"];
    iOtherDeviceLoginValue = @"0";
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  stop];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"CheckUserAlreadyLogin"
    //                                                  object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"notificationCount"
    //                                                  object:nil];
}

#pragma mark:- Additional Methode
- (void)createSlideToUnlockViewWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    [label sizeToFit];
    label.textColor = [UIColor whiteColor];
    
    //Create an image from the label
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0.0);
    [[label layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *textImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat textWidth = textImage.size.width;
    CGFloat textHeight = textImage.size.height;
    
    CALayer *textLayer = [CALayer layer];
    textLayer.contents = (id)[textImage CGImage];
    textLayer.frame = CGRectMake(self.view.frame.size.width / 2 - textWidth / 2, self.view.frame.size.height / 2 - textHeight / 2, textWidth, textHeight);
    
    UIImage *maskImage = [UIImage imageNamed:@"Mask.png"];
    CALayer *maskLayer = [CALayer layer];
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.15] CGColor];
    maskLayer.contents = (id)maskImage.CGImage;
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(-textWidth - maskImage.size.width, 0.0, (textWidth * 2) + maskImage.size.width, textHeight);
    
    CABasicAnimation *maskAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnimation.byValue = [NSNumber numberWithFloat:textWidth + maskImage.size.width];
    maskAnimation.repeatCount = HUGE_VALF;
    maskAnimation.duration = 2.0;
    maskAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [maskLayer addAnimation:maskAnimation forKey:@"slideAnimation"];
    textLayer.mask = maskLayer;
    [self.view.layer addSublayer:textLayer];
}

- (void)test
{
    self.view.layer.backgroundColor = [[UIColor blackColor] CGColor];
    
    UIImage *textImage = [UIImage imageNamed:@"blueGradient.png"];
    //    CGFloat textWidth = textImage.size.width;
    CGFloat textWidth = textImage.size.width;
    CGFloat textHeight = textImage.size.height;
    CALayer *textLayer = [CALayer layer];
    textLayer.contents = (id)[textImage CGImage];
    textLayer.frame = CGRectMake(10.0f, 215.0f, textWidth, textHeight);
    CALayer *maskLayer = [CALayer layer];
    // Mask image ends with 0.15 opacity on both sides. Set the background color of the layer
    // to the same value so the layer can extend the mask image.
    maskLayer.backgroundColor = [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.15f] CGColor];
    maskLayer.contents = (id)[[UIImage imageNamed:@"blueGradient.png"] CGImage];
    // Center the mask image on twice the width of the text layer, so it starts to the left
    // of the text layer and moves to its right when we translate it by width.
    maskLayer.contentsGravity = kCAGravityCenter;
    maskLayer.frame = CGRectMake(-textWidth, 0.0f, textWidth * 2, textHeight);
    
    // Animate the mask layer's horizontal position
    CABasicAnimation *maskAnim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    maskAnim.byValue = [NSNumber numberWithFloat:textWidth];
    maskAnim.repeatCount = HUGE_VALF;
    maskAnim.duration = 1.0f;
    [maskLayer addAnimation:maskAnim forKey:@"slideAnim"];
    textLayer.mask = maskLayer;
    [self.view.layer addSublayer:textLayer];
    
    // [super viewDidLoad];
}

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, 0, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, 0, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, self.view.frame.size.width, 0.0);
    }];
}


-(void)secondBlackSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, 0, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, self.view.frame.size.width, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, self.view.frame.size.width, 0.0);
        
    }];
}


-(void)thirdBlackSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, self.view.frame.size.width, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, self.view.frame.size.width, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, self.view.frame.size.width, 0.0);
        
    }];
}


-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -self.view.frame.size.width, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -self.view.frame.size.width, 0.0);
        // self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -(self.view.frame.size.width)*3, 0.0);
        
    }];
}

-(void)secondSlideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        //self.viewOrange.frame = CGRectOffset(self.viewOrange.frame, -self.view.frame.size.width, 0.0);
        self.viewBlack.frame = CGRectOffset(self.viewBlack.frame, -self.view.frame.size.width, 0.0);
        self.viewGreen.frame = CGRectOffset(self.viewGreen.frame, -self.view.frame.size.width, 0.0);
        
    }];
}

-(void) hideKeyBoard:(id) sender
{
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
}

- (IBAction)crashButtonTapped:(id)sender {
    [[Crashlytics sharedInstance] crash];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Sign In Method Call
- (IBAction)signInBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if([_emailTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter your email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else  if (![CommonUtils isValidEmailId:_emailTextField.text]){
        [[[ UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter valid email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
    }
    else if([_passwordTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else{
        [self callLoginApiwithSomeData:iOtherDeviceLoginValue];
    }
}

-(void)callLoginApiwithSomeData:(NSString *)str{
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        
        if ([latitudeStr length] && [lonitudeStr length] && (![latitudeStr isEqualToString:@"NULL"])  && (![lonitudeStr isEqualToString:@"NULL"]))
        {
            NSString *ipAddressStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"IPAddressValue"];
            if (!ipAddressStr) {
                ipAddressStr = @"";
        }
            NSString *deviceTokenStr = sharedInstance.deviceToken;
            if (!deviceTokenStr) {
                deviceTokenStr = @"";
            }
            NSString *cityStr = sharedInstance.cityValueStr;
            NSString *stateStr = [ sharedInstance.stateValueStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *countryStr = sharedInstance.countryValueStr;
            
            if (!cityStr) {
                cityStr = NULL;
            }
            
            if (!stateStr) {
                stateStr = NULL;
            }
            if (!countryStr) {
                countryStr = NULL;
            }
            
            NSString *urlstr=[NSString stringWithFormat:@"%@?userEmailID=%@&userPassword=%@&deviceID=%@&latitude=%@&longitude=%@&ipAddress=%@&DeviceType=%@&usertype=%@&city=%@&state=%@&country=%@&appType=%@&isOtherDeviceLogout=%@&versionNumber=%@",APIAccountLogin,self.emailTextField.text,self.passwordTextField.text ,deviceTokenStr,latitudeStr,lonitudeStr,ipAddressStr,@"IOS",@"1",cityStr,stateStr,countryStr,@"1",iOtherDeviceLoginValue,sharedInstance.appVersionNumber];
                NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"params =======   %@",urlstr);
                [ProgressHUD show:@"Please wait..." Interaction:NO];
                [ServerRequest requestWIthNewURLForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                    NSLog(@"response object Get Comments List %@",responseObject);
                    [ProgressHUD dismiss];
                    if(!error){
                        NSLog(@"Response is --%@",responseObject);
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            sharedInstance.isUserLogoutManualyy = NO;
                            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                            NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                            NSString *userIdStr = [resultDict valueForKey:@"UserID"];
                            isDuePaymentStr =[resultDict valueForKey:@"isDuePayment"];
                            sharedInstance.userId = userIdStr;
                            sharedInstance.isDuePaymentValueStr = isDuePaymentStr;
                            sharedInstance.VersionValue = [resultDict valueForKey:@"Version"];
                            sharedInstance.BuildValueStr = [resultDict valueForKey:@"BuildNumber"];
                            sharedInstance.strUnitType =[resultDict valueForKey:@"UnitType"];
                            sharedInstance.isUserLoginManualyy = YES;
                            NSString *userTypeStr = [resultDict valueForKey:@"UserType"];
                            [self.userTypeArr addObject:userTypeStr];
                            [[NSUserDefaults standardUserDefaults]setObject:userIdStr forKey:@"USERIDDATA"];
                            [[NSUserDefaults standardUserDefaults]setObject:self.userTypeArr forKey:@"USERTYPEDATA"];
                            
                            NSString *check=[[NSUserDefaults standardUserDefaults]objectForKey:@"check"];
                            if([check isEqual:@"save"]){
                                [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"email"];
                                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
                            }
                            [self signalRHubCall];
                            if ([isDuePaymentStr isEqualToString:@"0"]) {
                                [self tabBarCountApiCall];
                            }
                            else if ([isDuePaymentStr isEqualToString:@"1"])
                            {
                                sharedInstance.isPastDuePayment = [resultDict valueForKey:@"isDuePayment"];
                                if ([sharedInstance.isPastDuePayment  isEqualToString:@"1"]) {
                                    ChargeBackViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"ChargeBackViewController"];
                                    notiView.dateIDString = [resultDict valueForKey:@"DateID"];
                                    notiView.userIDString = [resultDict valueForKey:@"UserID"];
                                    notiView.pendingChargeBackString  = [responseObject objectForKey:@"Message"];
                                    [self.navigationController pushViewController:notiView animated:YES];
                                    
                                    // [self pastDuePaymentDetailsApiCall];
                                }
                            }
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 2){
                            iOtherDeviceLoginValue = @"1";
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Already Signed In" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   if (index == 1) {
                                                                       [self callLoginApiwithSomeData:iOtherDeviceLoginValue];
                                                                   }
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 3){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"App Not Launched" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 4){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 5){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 6){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==7){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Account Suspended" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"Ok"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 8){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Account Closed" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"Ok"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 9){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Incomplete Account" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"ok"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 10){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Inactive Account" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                                   
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 11){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Sign In Failed" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 12){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Sign In Failed" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 13){
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Sign In Failed" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                               }];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 26){
                            
                            NonSufficientVC *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"NonSufficientVC"];
                            notiView.nonSufficientMessage  = [responseObject objectForKey:@"Message"];
                            [self.navigationController pushViewController:notiView animated:YES];
                        }
                        else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 503){
                            
                           [CommonUtils showAlertWithTitle:@"System Unavailable" withMsg:@"Our system is currently unavailable at this time. Please try again later."  inController:self];
                        }
                        
                        else{
                        [CommonUtils showAlertWithTitle:@"System Unavailable" withMsg:@"Our system is currently unavailable at this time. Please try again later."  inController:self];
                        }
                    }
                    else {
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Request time out." inController:self];
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
    
    else {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                               // [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                           }];
    }
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
        if (sharedInstance.userId.length) {
            [chat invoke:@"GetConnected" withArgs:[NSArray arrayWithObjects:sharedInstance.userId, nil]];
        }
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
//        if ( sharedInstance.checkThatUserIsOnline == YES) {
//            static dispatch_once_t once;
//            dispatch_once(&once, ^ {
//                NSLog(@"Do it once");
//                [self changeStatusWithValue:@"1"];
//
//            });
//        }
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
        
        if ( sharedInstance.checkThatUserIsOnline == YES) {
            static dispatch_once_t once;
            dispatch_once(&once, ^ {
                NSLog(@"Do it once");
                if ( sharedInstance.checkThatUserReservationOnline == YES) {
                    [self changeStatusWithValue:@"0" WithReservationStr:@"1"];

                }
                else
                {
                    [self changeStatusWithValue:@"0" WithReservationStr:@"0"];
                }

                
            });
        }
        if (sharedInstance.isUserLogoutManualyy) {
            
        }
        else
        {
            if (APPDELEGATE.hubConnection) {
                if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive) {
                    if([AFNetworkReachabilityManager sharedManager].reachable)
                    {
                        [APPDELEGATE.hubConnection start];
                        [APPDELEGATE.hubConnection reconnecting];
                    }
                    else{
                        [APPDELEGATE.hubConnection stop];
                    }
                }
                else{
                    NSLog(@"App Is in Background State");
                }
            }
            else
            {
                [self signalRHubCall];
            }
        }
    }];
    [APPDELEGATE.hubConnection setError:^(NSError *error) {
        NSLog(@"Connection Error %@",error);
    }];
    
    // Start the connection
    [APPDELEGATE.hubConnection start];
}

-(void)changeStatusWithValue:(NSString *)str WithReservationStr:(NSString *)reservationStr{
    
    sharedInstance = [SingletonClass sharedInstance];
    NSString  *userIdStr = sharedInstance.userId;
    NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    if (!deviceTokenStr) {
        deviceTokenStr = @"";
    }
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?contractorID=%@&onlineStatus=%@&HideStatus=%@&latitude=%@&longitude=%@&deviceID=%@&flag=%@",APIContractorChangeProfileShownStatus,userIdStr,str,reservationStr,latitudeStr,lonitudeStr,deviceTokenStr,@"Online"];
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

- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"2" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                    dateCountStr  = nil;
                }
                else {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                    messageCountStr = nil;
                }
                else {
                    messageCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                    notificationsCountStr   = nil;
                }
                else {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
            else{
            }
        }
        else
        {
        }
        [self tabBarControllerClass];
    }];
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashBoardScreenView = [storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
    dashBoardScreenView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    dashBoardScreenView.title = @"Dashboard";
    dashBoardScreenView.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    dashBoardScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"dashboard_hover"];
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.isFromDateDetails = NO;
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    messageView.tabBarItem.badgeValue = messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    // accountView.view.backgroundColor = [UIColor whiteColor];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:dashBoardScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    [APPDELEGATE tabBarC].selectedItemTitleColor = [UIColor purpleColor];
    [APPDELEGATE tabBarC].viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    
    // self.window.rootViewController = tabBarC;
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:YES];
}


- (void)updateBadges:(NSNotification*) noti {
    
    NSDictionary* responseObject = noti.userInfo;
    
    if ([[responseObject objectForKey:@"Dates"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue  = nil;
        
    } else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [responseObject objectForKey:@"Dates"];
    }
    
    if ([[responseObject  objectForKey:@"Mesages"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = nil;
        
    }
    else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = [responseObject objectForKey:@"Mesages"];
    }
    
    if ([[responseObject objectForKey:@"Notifications"] isEqualToString:@"0"]) {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
        
    }
    else {
        
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = [responseObject objectForKey:@"Notifications"];
        
    }
}


- (void)notifybeginCall:(NSString *)message {
    // Print the message when it comes in
    NSLog(@" Test jamshed notifybeginCall Client Server Method Call===== %@",message);
    
    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"notifybeginCall Method Invoke by Server! Done" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrtShow show];
}



- (void)SRConnection:(SRConnection *)connection didReceiveData:(id)data {
    
    NSLog(@"data recieved %@",data);
    NSArray *dataArray = [data objectForKey:@"A"];
    NSString *requestedMeesage = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:0]];
    NSArray* foo = [requestedMeesage componentsSeparatedByString: @","];
    NSString* firstBit = [foo objectAtIndex: 0];
    NSString* secondBit = [foo objectAtIndex: 1];
    NSString* thirdBit = [foo objectAtIndex: 2];
    NSString* fourthBit = [foo objectAtIndex: 3];
    NSString* fiftBit = [foo objectAtIndex: 4];
    NSString* sixBit = [foo objectAtIndex: 5];
    
    NSArray* temp1 = [firstBit componentsSeparatedByString: @"="];
    NSString *userIdStr = [temp1 objectAtIndex: 1];
    NSArray* temp2 = [secondBit componentsSeparatedByString: @"="];
    NSString *dateCountValueStr = [temp2 objectAtIndex: 1];
    NSArray* temp3 = [thirdBit componentsSeparatedByString: @"="];
    NSString *mesagesCountStr = [temp3 objectAtIndex: 1];
    NSArray* temp4 = [fourthBit componentsSeparatedByString: @"="];
    NSString *notificationsCountValueStr = [temp4 objectAtIndex: 1];
    NSArray* temp5 = [fiftBit componentsSeparatedByString: @"="];
    NSString *typeIdStr = [temp5 objectAtIndex: 1];
    NSArray* temp6 = [sixBit componentsSeparatedByString: @"="];
    NSString *dateIdStr = [temp6 objectAtIndex: 1];
    NSDictionary *responseObject = @{@"userId":userIdStr,@"dateCount":dateCountValueStr,@"messageCount":mesagesCountStr,@"notificationCount":notificationsCountValueStr,@"dateType":typeIdStr,@"dateId":dateIdStr};
    NSString *loginUserIdStr = sharedInstance.userId;
    if ([loginUserIdStr isEqualToString:userIdStr]) {
        
        if ([dateCountValueStr isEqualToString:@"0"]) {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
            
        } else {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = dateCountValueStr;
        }
        
        if ([mesagesCountStr isEqualToString:@"0"]) {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
            
        } else {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = mesagesCountStr;
        }
        
        if ([notificationsCountValueStr isEqualToString:@"0"]) {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
            
        } else {
            
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = notificationsCountValueStr;
            
        }
        
        NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
        if ([requestTypeStr isEqualToString:@"1"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignalR" object:self userInfo:responseObject];
            
        }
        else if ([requestTypeStr isEqualToString:@"7"] || [requestTypeStr isEqualToString:@"3"] ||[requestTypeStr isEqualToString:@"11"] || [requestTypeStr isEqualToString:@"5"]) {
            [APPDELEGATE setRequestTypeStr:requestTypeStr];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dateRequestCancelByCustomer" object:self userInfo:nil];
        }
        else if ([requestTypeStr isEqualToString:@"16"]) {
        }
        else if([requestTypeStr isEqualToString:@"100"])
        {
            NSString *deviceTokenStr = sharedInstance.deviceToken;
            if ([dateIdStr isEqualToString:deviceTokenStr]) {
            }
            else
            {
                sharedInstance.isUserLogoutManualyy = YES;
                sharedInstance.isUserLoginManualyy = NO;
                ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                [self.navigationController pushViewController:loginView animated:NO];
                return;

               // [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
    }
}

- (void)SRConnectionDidOpen:(SRConnection *)connection {
    NSLog(@"get connected using HubConnection");
    
}

- (void)SRConnectionDidClose:(SRConnection *)connection{
    NSLog(@"close");
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error
{
    NSLog(@"error%@",error.description);
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
        NSLog(@"sharedInstance.onDemandPushNotificationArray ViewController ==  %@",sharedInstance.onDemandPushNotificationArray);
        if([sharedInstance.checkPushNotificationOnDemandStr isEqualToString:@"No"]) {
            OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
            [self.navigationController pushViewController:dateDetailsView animated:YES];
            
        }
    }
    else if ([requestTypeStr isEqualToString:@"7"])
    {
        [APPDELEGATE setRequestTypeStr:requestTypeStr];
        // Bug here If Condition dor Dateid is equal or Not
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dateRequestCancelByCustomer" object:self userInfo:nil];
    }
    else if ([requestTypeStr isEqualToString:@"16"])
    {
    }
}

- (void)checkUserAlreadyLogin:(NSNotification*) noti
{
    NSDictionary* responseObject = noti.userInfo;
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    NSString *useIDStr = sharedInstance.userId;
    
    NSLog(@"Notification UserID %@",useIDStr);
    NSLog(@"Notification value UserID %@",[responseObject objectForKey:@"UserId"] );
    NSLog(@"Notification value UserID %@",[responseObject objectForKey:@"Device"] );
    
    NSString *loginDeviceID = [responseObject objectForKey:@"Device"] ;
    UIViewController *vc = self.navigationController.visibleViewController;
    NSLog(@"Visible View Controller %@",vc);
    
    NSString *loginID = [responseObject objectForKey:@"UserId"];
    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    if ([loginID isEqualToString:useIDStr]) {
        if ([loginDeviceID isEqualToString:deviceTokenStr]) {
        }
        else
        {
            if ((vc == [ViewController class] ) || (vc == [loginView class])||([vc isKindOfClass:[ViewController class]])) {
            }
            else
            {
                [self.navigationController pushViewController:loginView animated:NO];
                return;
            }
        }
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CheckUserAlreadyLogin"
                                                  object:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)forgotButtonClicked:(id)sender {
    
    ForgotPasswordViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"forgot"];
    [self.navigationController pushViewController:obj animated:YES];
    
}
- (IBAction)signUpButtonClicked:(id)sender {
    
    SignUpViewController *signUpview = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    [self.navigationController pushViewController:signUpview animated:YES];
    
}

- (IBAction)RememberMeBtnClicked:(id)sender {
    
    if ([sender isSelected])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
      
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"check"];
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.emailTextField.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:@"save" forKey:@"check"];
        [sender setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        [sender setSelected:YES];
    }
}

@end
