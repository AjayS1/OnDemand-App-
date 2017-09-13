
//  ViewController.m
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "ViewController.h"

@interface ViewController () {
    
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    LCTabBarController *tabBarC;
    SingletonClass *sharedInstance;
    UIView *requestSendPopUpView;
    UIView *firstLineView;
    NSString *iOtherDeviceLoginValue;
    CALayer *cloudLayer;
    CABasicAnimation *cloudLayerAnimation;
    
}
@property (nonatomic, strong) MARKRangeSlider *rangePromotionSlider;
@property (strong, nonatomic) CAGradientLayer *gradient;
@property (nonatomic,strong) ITProgressBar *progressBar;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUserAlreadyLogin:)
                                                 name:@"CheckUserAlreadyLogin"
                                               object:nil];
    }

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    //check the day light is saving BOOL dst = [[[NSCalendar currentCalendar] timeZone] isDaylightSavingTime];
    sharedInstance = [SingletonClass sharedInstance];
    dateCountStr = @"";
    messageCountStr = @"";
    notificationsCountStr = @"";
    self.userTypeArr = [[NSMutableArray alloc]init];
    txtEmail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtEmail.layer.borderWidth = 0.5;
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    txtEmail.leftView = emailPaddingView;
    txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    txtPassword.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtPassword.layer.borderWidth = 0.5;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    txtPassword.leftView = passwordPaddingView;
    txtPassword.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *check=[[NSUserDefaults standardUserDefaults]objectForKey:@"check"];
    
    if([check isEqual:@"save"]){
        
        txtEmail.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"email" ];
        txtPassword.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"password" ];
        [rememberMeButton setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        rememberMeButton.selected=YES;
    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    
    iOtherDeviceLoginValue =@"0";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateBadges:)
                                                 name:@"notificationCount"
                                               object:nil];
    
    self.navigationController.navigationBar.hidden=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  stop];
    }
}

-(void)dealloc {
    
   // [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"notificationCount"
                                                  object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"notificationCount"
                                                 object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:@"CheckUserAlreadyLogin"
//                                                  object:nil];
}


#pragma mark  Promotional- Actions
- (void)rangePromotionalSliderValueDidChange:(MARKRangeSlider *)slider
{
    [self updatePromotionRangeText];
}

- (void)updatePromotionRangeText
{
    // miniPromotionalPriceLabel.text =[NSString stringWithFormat:@"$%0.2f",self.rangePromotionSlider.leftValue];
    // maxPromotionalPriceLabel.text =[NSString stringWithFormat:@"$%0.2f",self.rangePromotionSlider.rightValue];
}

- (IBAction)crashButtonTapped:(id)sender {
    [self.view endEditing:YES];
    [[Crashlytics sharedInstance] crash];
}

- (void) hideKeyBoard:(id) sender {
    
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
}

#pragma mark - Sign In Method Call
- (IBAction)signInBtnClicked:(id)sender {
    [self.view endEditing:YES];
    
    if([txtEmail.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter your email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else  if (![CommonUtils isValidEmailId:txtEmail.text]){
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Please enter valid email" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
    }
    else if([txtPassword.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if(!sharedInstance.locationShareYesOrNO){
        
        [self.view endEditing:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled"
                                                        message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    else {
        
        BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
        if (locationAllowed) {
            [self callLoginApiwithSomeData:iOtherDeviceLoginValue];
        }
        else
        {
            sharedInstance.latiValueStr = NULL;
            sharedInstance.longiValueStr = NULL;
            [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                         andButtonsWithTitle:@[@"OK"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                   // [self performSelector:@selector(obj) withObject:self afterDelay:3];
                                               }];
        }
    }
}

#pragma mark: Login APi Call
-(void)callLoginApiwithSomeData:(NSString *)string{
    
    [self.view endEditing:YES];
    NSString *latitudeStr = sharedInstance.latiValueStr;
    NSString *lonitudeStr = sharedInstance.longiValueStr;
    
    if ([latitudeStr length] && [lonitudeStr length] && (![latitudeStr isEqualToString:@"NULL"])  && (![lonitudeStr isEqualToString:@"NULL"]))
    {
        
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
        
        //  NSString *ipAddressStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"IPAddressValue"];
        NSString *ipAddressStr  = sharedInstance.ipAddressStr;
        
        if (!ipAddressStr) {
            ipAddressStr = @"";
        }
        
        NSString *deviceTokenStr = sharedInstance.deviceToken;
        if (!deviceTokenStr) {
            deviceTokenStr = @"";
        }

   // http://localhost:49647/API/Account/AccountLoginNew?state=Uttar+Pradesh&city=Noida&country=India&usertype=2&userEmailID=h@doumees.com&userPassword=Test123&latitude=28.6185401&longitude=77.3906674&deviceID=cY8yw-spsf0:APA91bHG35ikunO5dl_bgZ3GTHZNEqzoc8PfNwwkJWg6ckdXSJaTIVyxCC1wi0Tz-McqaeQ8m83b9j4a4Yv0fBwDj32ePMymlssgpLaeqpEAeqpG7HPx48bq5OnSpdiL0hzYWOenjhKV&ipAddress=10.0.0.23&isOtherDeviceLogout=1&DeviceType=Android&appType=2&versionNumber=1.0
         
        NSString *urlstr=[NSString stringWithFormat:@"%@?userEmailID=%@&userPassword=%@&deviceID=%@&latitude=%@&longitude=%@&ipAddress=%@&DeviceType=%@&usertype=%@&city=%@&state=%@&country=%@&appType=%@&isOtherDeviceLogout=%@&versionNumber=%@",APIAccountLogin,txtEmail.text,txtPassword.text,deviceTokenStr,latitudeStr,lonitudeStr,ipAddressStr,@"IOS",@"2",cityStr,stateStr,countryStr,@"2",iOtherDeviceLoginValue,sharedInstance.appVersionNumber];
        
        NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"Param%@",urlstr);
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get Comments List %@",responseObject);
            
            [ProgressHUD dismiss];
            if(!error)
            {
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
                    NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                    NSString *userIdStr = [resultDict valueForKey:@"UserID"];
                    NSString *userTypeStr = [resultDict valueForKey:@"UserType"];
                    [self.userTypeArr addObject:userTypeStr];
                    sharedInstance.userId = userIdStr;
                    sharedInstance.strBuildValue = [resultDict valueForKey:@"BuildNumber"];
                    sharedInstance.strVersionValue = [resultDict valueForKey:@"Version"];
                    sharedInstance.strUnityTypeValue =[resultDict valueForKey:@"UnitType"];
                    [[NSUserDefaults standardUserDefaults] setObject:userIdStr forKey:@"USERIDDATA"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.userTypeArr forKey:@"USERTYPEDATA"];
                    NSString *check=[[NSUserDefaults standardUserDefaults]objectForKey:@"check"];
                    sharedInstance.isUserLogoutManualyy = NO;
                    sharedInstance.isUserLoginManualyy = YES;
                    
                    if([check isEqual:@"save"]){
                        [[NSUserDefaults standardUserDefaults]setObject:txtEmail.text forKey:@"email"];
                        [[NSUserDefaults standardUserDefaults]setObject:txtPassword.text forKey:@"password"];
                    }
                    
                    [self signalRHubCall];
                    NSString *duePaymentType = [NSString stringWithFormat:@"%@",[resultDict valueForKey:@"isDuePayment"]];
                    NSString *dueDateType;
                    NSString *dueDateId;
                    
                    if ([[NSString stringWithFormat:@"%@",[resultDict valueForKey:@"DateType"]] length]) {
                        dueDateType = [NSString stringWithFormat:@"%@",[resultDict valueForKey:@"DateType"]];

                    }
                    if ([[NSString stringWithFormat:@"%@",[resultDict valueForKey:@"DateID"]] length]) {
                       dueDateId = [NSString stringWithFormat:@"%@",[resultDict valueForKey:@"DateID"]];
                    }

                    if (([duePaymentType isEqualToString:@"1"]) && [dueDateType isEqualToString:@"17" ])
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
                    else if (([duePaymentType  isEqualToString:@"2"])) {
                        [self paymentCompletedApiCallWithDateType:dueDateType WithDateID:dueDateId];
                    }
                    else if (([duePaymentType  isEqualToString:@"0"])){
                        [self tabBarCountApiCall];
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
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Account Blocked" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 5){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 6){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] ==7){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Account Inactive" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if (index == 1) {
                                                               [self callLoginApiwithSomeData:iOtherDeviceLoginValue];
                                                           }
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 8){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Account Closed" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           if (index == 1) {
                                                               [self callLoginApiwithSomeData:iOtherDeviceLoginValue];
                                                           }
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 9){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Incomplete Account" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           
                                                       }];
                }
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 10){
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
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
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 18){
                    
//                    PendingChargebackVC *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"PendingChargebackVC"];
//                    notiView.pendingChargeBackString  = [responseObject objectForKey:@"Message"];
//                    [self.navigationController pushViewController:notiView animated:YES];
                }
                
                else  if ([[responseObject objectForKey:@"StatusCode"] intValue] == 503){
                    
                    [CommonUtils showAlertWithTitle:@"System Unavailable" withMsg:@"Our system is currently unavailable at this time. Please try again later."  inController:self];

                }
                
                else {
                 [CommonUtils showAlertWithTitle:@"System Unavailable" withMsg:@"Our system is currently unavailable at this time. Please try again later."  inController:self];
                }
            }
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Request time out." inController:self];
            }
        }];
        
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"We did not fetch your location.Do you want again to find the location?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   //[self obj];
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


// SignalR Code Here
- (void)signalRHubCall {
    
    // SignalR Code Here
    APPDELEGATE.hubConnection = [SRHubConnection connectionWithURLString:SignalRBaseUrl];
    APPDELEGATE.hubConnection.delegate = self;
    SRHubProxy *chat = [APPDELEGATE.hubConnection  createHubProxy:@"RtcHub"];
    [chat on:@"notifybeginCall" perform:self selector:@selector(notifybeginCall:)];
    NSString *userId = sharedInstance.userId ;
    NSMutableArray *userArray = [[NSMutableArray alloc]init];
    [userArray addObject:userId];
    
    // Register for connection lifecycle events
    [APPDELEGATE.hubConnection  setStarted:^{
        NSLog(@"Connection Started");
        //    [self getCurrentTime];
        //  [  self loginApiCall];
    }];
    [APPDELEGATE.hubConnection  setReceived:^(NSString *message) {
        //NSLog(@"Connection Recieved Data: %@",message);
        
    }];
    [APPDELEGATE.hubConnection  setConnectionSlow:^{
        NSLog(@"Connection Slow");
    }];
    [APPDELEGATE.hubConnection  setReconnecting:^{
        NSLog(@"Connection Reconnecting");
        [APPDELEGATE.hubConnection reconnecting];
        //[APPDELEGATE.hubConnection  stop];
        [self getCurrentTime];
        // [self signalRHubCall];
        
    }];
    [APPDELEGATE.hubConnection  setReconnected:^{
        NSLog(@"Connection Reconnected");
    }];
    [APPDELEGATE.hubConnection  setClosed:^{
        
        NSLog(@"Connection Closed");
        if (sharedInstance.isUserLogoutManualyy) {
        }
        else{
            if (APPDELEGATE.hubConnection) {
                if ([[UIApplication sharedApplication] applicationState]==UIApplicationStateActive) {
                    if([AFNetworkReachabilityManager sharedManager].reachable)
                    {
                        [APPDELEGATE.hubConnection start];
                        [APPDELEGATE.hubConnection reconnecting];
                    }
                    else
                    {
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
    [APPDELEGATE.hubConnection  setError:^(NSError *error) {
        NSLog(@"Connection Error %@",error);
    }];
    // Start the connection
    [APPDELEGATE.hubConnection  start];
    
}

-(void)getCurrentTime
{
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    NSLog(@"newDateStringFormatted %@", newDateString);
}

-(void)getConnected:(NSString *)newUser{
    NSLog(@" Test jamshed notifybeginCall Client Server Method Call ");
    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"NotifybeginCall Method Invoke by Server! Done" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrtShow show];
    
}

- (void)notifybeginCall:(NSString *)message {
    // Print the message when it comes in
    NSLog(@" Test jamshed notifybeginCall Client Server Method Call===== %@",message);
    
    UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"NotifybeginCall Method Invoke by Server! Done" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alrtShow show];
}

- (void)SRConnection:(SRConnection *)connection didReceiveData:(id)data {
    
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
    NSDictionary *dateValueData = @{@"userId":userIdStr,@"dateCount":dateCountValueStr,@"messageCount":mesagesCountStr,@"notificationCount":notificationsCountValueStr,@"dateType":typeIdStr,@"dateId":dateIdStr};
    NSString *loginUserIdStr = sharedInstance.userId;
    
    if ([loginUserIdStr isEqualToString:userIdStr]) {
        
        if ([dateCountValueStr isEqualToString:@"0"]) {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue  = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = dateCountValueStr;
        }
        
        if ([mesagesCountStr isEqualToString:@"0"]) {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = mesagesCountStr;
        }
        
        if ([notificationsCountValueStr isEqualToString:@"0"])
        {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
            
        }
        else {
            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = notificationsCountValueStr;
        }
        
        if ([typeIdStr isEqualToString:@"4"] || [typeIdStr isEqualToString:@"3"] || [typeIdStr isEqualToString:@"16"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkDateReqestBySignalR" object:self userInfo:dateValueData];
        }
        
        else if ([typeIdStr isEqualToString:@"10"]) {
            
            NSLog(@"Date Payment Notification Center method Call in View Controller Class");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dateEndThenPaymentScreen" object:self userInfo:dateValueData];
            
        }
        else if([typeIdStr isEqualToString:@"100"]) {
            NSString *deviceTokenStr = sharedInstance.deviceToken;
            if ([dateIdStr isEqualToString:deviceTokenStr]) {
            }
            else
            {
                sharedInstance.isUserLogoutManualyy = YES;
                sharedInstance.isUserLoginManualyy = NO;
                ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                [self.navigationController pushViewController:loginView animated:NO];
               //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
//                sharedInstance.isUserLogoutManualyy = NO;
//                sharedInstance.isUserLoginManualyy = NO;
                //[self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.isFromLoginView = NO;
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}


- (void)SRConnectionDidOpen:(SRConnection *)connection {
    NSLog(@"get connected using HubConnection");
    NSLog(@"Hub Connection Method CallTest");
    
}

- (void)SRConnectionDidClose:(SRConnection *)connection {
    NSLog(@"close");
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error {
    NSLog(@"error%@",error.description);
}


- (void)pastDuePaymentDetailsApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    NSString *urlstr=[NSString stringWithFormat:@"%@?customerID=%@",APIPastDueDate,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error) {
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                PastDuePaymentViewController *pastDueView = [self.storyboard instantiateViewControllerWithIdentifier:@"pastDuePayment"];
                pastDueView.self.pastDuePaymentDetailsDictionary = [responseObject objectForKey:@"result"];
                [self.navigationController pushViewController:pastDueView animated:YES];
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

-(void)paymentCompletedApiCallWithDateType:(NSString *)dateType WithDateID:(NSString *)dateId{
    PaymentDateCompletedViewController *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    paymentView.self.dateIdStr =  dateId;
    paymentView.isFromLoginView = YES;
    paymentView.self.dateTypeStr = [NSString stringWithFormat:@"%@",dateType];
    [self.navigationController pushViewController:paymentView animated:YES];
}

- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"])
                {
                    dateCountStr  = nil;
                }
                else
                {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"])
                {
                    messageCountStr = nil;
                }
                else
                {
                    messageCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"])
                {
                    notificationsCountStr   = nil;
                }
                else
                {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
        }
        [self tabBarControllerClass];
    }];
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    //searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    //datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    [datesView.dontHaveMessage setHidden:YES];
    [datesView.dateImageView setHidden:YES];

    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    messageView.tabBarItem.badgeValue =messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
  
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:searchScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    APPDELEGATE.tabBarC.selectedItemTitleColor = [UIColor purpleColor];
    APPDELEGATE.tabBarC.viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:YES];
}

-(void)updateBadges:(NSNotification*) noti {
    
    NSDictionary* responseObject = noti.userInfo;
    if ([[responseObject objectForKey:@"Dates"] isEqualToString:@"0"]) {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
    }
    else
    {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [responseObject objectForKey:@"Dates"];
    }
    if ([[responseObject  objectForKey:@"Mesages"] isEqualToString:@"0"])
    {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
    }
    else
    {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue  = [responseObject objectForKey:@"Mesages"];
    }
    
    if ([[responseObject objectForKey:@"Notifications"] isEqualToString:@"0"]) {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
    }
    else
    {
        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue  = [responseObject objectForKey:@"Notifications"];
    }
}

- (void)checkUserAlreadyLogin:(NSNotification*) noti {
    
    NSDictionary* responseObject = noti.userInfo;
    NSString *deviceTokenStr = sharedInstance.deviceToken;
    NSString *useIDStr = sharedInstance.userId;
    
    NSLog(@"Notification UserID %@",useIDStr);
    NSLog(@"Notification value UserID %@",[responseObject objectForKey:@"UserId"] );
    NSLog(@"Notification value DeviceID %@",[responseObject objectForKey:@"Device"] );
    
    NSString *loginDeviceID =[responseObject objectForKey:@"Device"] ;
    NSString *loginID =[responseObject objectForKey:@"UserId"];
    UIViewController *vc = self.navigationController.visibleViewController;
    NSLog(@"Visible View Controller %@",vc);
    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    
    if ([loginID isEqualToString:useIDStr]) {
        if ([loginDeviceID isEqualToString:deviceTokenStr]) {
        }
        else
        {
            if ((vc == [ViewController class] ) || (vc == [loginView class])||([vc isKindOfClass:[ViewController class]])) {
                return;
            }
            else
            {
                [self.navigationController pushViewController:loginView animated:NO];
            }
        }
    }
}

- (void)dateRequest:(NSNotification*) noti {
    
    NSDictionary* responseObject = noti.userInfo;
    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
}

- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSLog(@"checkSignalRReqest method Call");
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    if ([requestTypeStr isEqualToString:@"4"]) {
    }
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

#pragma mark - Sign Up Method Call
- (IBAction)signUpBtnClicked:(id)sender {
    
    SignUpViewController *signUpview = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUp"];
    [self.navigationController pushViewController:signUpview animated:YES];
    
}

#pragma mark Forgot Password Method Call

- (IBAction)forgotPasswordButtonClicked:(id)sender {
    //forgot
    ForgotPasswordViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"forgot"];
    [self.navigationController pushViewController:accountInfoView animated:YES];
}

- (IBAction)rememberMeButtonClicked:(UIButton *)sender {
    
    if ([sender isSelected]) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"email"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"check"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
        [sender setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    
    else {
        
        [[NSUserDefaults standardUserDefaults]setObject:txtEmail.text forKey:@"email"];
        [[NSUserDefaults standardUserDefaults]setObject:txtPassword.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults]setObject:@"save" forKey:@"check"];
        [sender setImage:[UIImage imageNamed:@"checked_checkbox"] forState:UIControlStateNormal];
        [sender setSelected:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
