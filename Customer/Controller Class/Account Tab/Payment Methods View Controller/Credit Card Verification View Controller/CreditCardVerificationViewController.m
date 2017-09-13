
//  CreditCardVerificationViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "CreditCardVerificationViewController.h"

@interface CreditCardVerificationViewController () {
    
    SingletonClass *sharedInstance;
    SingletonClass *customObject ;
    NSString*  dateCountStr;
    NSString*    messageCountStr;
    NSString* notificationsCountStr;
    NSString *encodedUrl ;
}
@end

@implementation CreditCardVerificationViewController
@synthesize accountDataDictionary;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    customObject = (SingletonClass *)accountDataDictionary;
    NSString *accountStr = [NSString stringWithFormat:@"%@",customObject.accountNumStr];
    NSString *codeNumberStr = [accountStr substringFromIndex: [accountStr length] - 4];
    if (_isFromCreditCardAddStr) {
        cardTypeLabel.text =  [NSString stringWithFormat:@"%@",_accountDataStr];
    }
    else{
        cardTypeLabel.text =  [NSString stringWithFormat:@"%@ - XXXX XXXX XXXX %@",customObject.bankName,codeNumberStr];
    }
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    _amount.inputAccessoryView = numberToolbar;
    //_amount.text = [NSString stringWithFormat:@"%@",customObject.paymentAmount];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    if (self.isFromCreditCardAddStr) {
        if (self.isFromCreditCardDeclinedStr) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
            accountView.isFromOrderProcess = NO;
            accountView.isFromCreditCardProcess = YES;
            accountView.isEmailVerifiedOrNotPage = NO;
            accountView.isFromUpdateMobileNumber = NO;
            [self.navigationController pushViewController:accountView animated:NO];
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)submit:(id)sender {
    if([_amount.text length]==0) {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the amount." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else
    {
        if (self.isFromCreditCardDeclinedStr) {
            [self callPaynowCreditCardVerificationAPI];
        }
        else {
        [self callCreditCardVerificationAPI];
    }
}
}

-(void)callPaynowCreditCardVerificationAPI{

    NSString *userIdStr = sharedInstance.userId;
    NSString *isPriamryValue = [[NSUserDefaults standardUserDefaults] valueForKey:@"isPrimary"];
    if ([isPriamryValue isEqualToString:@"1"]) {
        self.primaryStringValue = @"1";
    }
    else
    {
        self.primaryStringValue = @"0";
    }

    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&cardNumber=%@&authenticationAmount=%@&VerifyID=%@&PastDue=%@&IsPrimary=%@&Dateid=%@&DateType=%@",APIPaynowCreditCardVerify,userIdStr,self.accountNumberStr,_amount.text,self.accountKeyStr,self.pastDueString,self.primaryStringValue,self.dateIdStringValue,@"1"];
    encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error)
     {
         
         NSLog(@"response object Get UserInfo List %@",responseObject);
         [ProgressHUD dismiss];
         
         if(!error)
         {
             NSLog(@"Response is --%@",responseObject);
             if ([[responseObject objectForKey:@"StatusCode"] intValue] ==3)
             {
                 [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                              andButtonsWithTitle:@[@"Ok"] onController:self
                                                    dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                        if ([buttonTitle isEqualToString:@"Ok"]) {
//                                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isPrimary"];
//                                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                                            if (sharedInstance.isFromCaneclDateByCustomer) {
                                                                [self.tabBarController.tabBar setHidden:NO];
                                                                DatesViewController *dateView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                                dateView.isFromDateDetails = YES;
                                                                [self.tabBarController setSelectedIndex:1];
                                                                [self.navigationController pushViewController:dateView animated:NO];
                                                            }
                                                            else
                                                            {
                                                            RatingViewController *rateViewCall = [self.storyboard instantiateViewControllerWithIdentifier:@"rating"];
                                                            if (self.isFromCreditCardDeclinedStr) {
                                                                rateViewCall.isFromLoginViewController = YES;
                                                            }
                                                            else{
                                                                rateViewCall.isFromLoginViewController = NO;
                                                            }
                                                            rateViewCall.self.dateIdStr = self.dateIdStringValue;
                                                            rateViewCall.isFromCreditCardView = YES;
                                                            rateViewCall.isFromDateDetails = NO;
                                                            rateViewCall.self.nameStr = [[_payNowDictionary objectForKey:@"EndDateCustomer"] objectForKey:@"UserName"];
                                                            rateViewCall.self.imageUrlStr = [NSString stringWithFormat:@"%@",[[_payNowDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"PicUrl"]];
                                                            NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[_payNowDictionary objectForKey:@"EndDateCustomer"]objectForKey:@"EndTime"]];
                                                            NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
                                                            // [endTimeLabel setText:[NSString stringWithFormat:@"%@",requestDate]];
                                                            rateViewCall.self.dateCompletedTimeStr = [CommonUtils changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
                                                            [self.navigationController pushViewController:rateViewCall animated:YES];
                                                        }
                                                        }
                                                    }];
                 
             }
             else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 2){
                 [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                              andButtonsWithTitle:@[@"Ok"] onController:self
                                                    dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                        if ([buttonTitle isEqualToString:@"Ok"]) {
                        ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                        [self.navigationController pushViewController:loginView animated:NO];
                }
                    }];
             }
             else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 4){
                 [self.view endEditing:YES];
                 [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
             }
             else
             {
                 [self.view endEditing:YES];
                 [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
             }
         } else {
             
             NSLog(@"Error");
         }
     }];
}


-(void)callCreditCardVerificationAPI{
    if (_isFromCreditCardAddStr) {
        NSString *userIdStr = sharedInstance.userId;
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&cardNumber=%@&authenticationAmount=%@&VerifyID=%@",APIVerifyCreditCardApiCall,userIdStr,self.accountNumberStr,_amount.text,self.accountKeyStr];
        encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error)
     {
         
         NSLog(@"response object Get UserInfo List %@",responseObject);
         [ProgressHUD dismiss];
         
         if(!error)
         {
             NSLog(@"Response is --%@",responseObject);
             if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
             {
                 [[AlertView sharedManager] presentAlertWithTitle:@"Success" message:[responseObject objectForKey:@"Message"]
                                              andButtonsWithTitle:@[@"Ok"] onController:self
                                                    dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                        if ([buttonTitle isEqualToString:@"Ok"]) {
                                                            if (_isFromCreditCardAddSxreen) {
                                                                if (self.isFromCreditCardDeclinedStr) {
                                                                    [self tabBarCountApiCall];
                                                                    [self.tabBarController setSelectedIndex:1];
                                                                }
                                                                else
                                                                {
                                                                    AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                                    accountView.isFromOrderProcess = NO;
                                                                    accountView.isFromCreditCardProcess = YES;
                                                                    accountView.isEmailVerifiedOrNotPage = NO;
                                                                    accountView.isFromUpdateMobileNumber = NO;
                                                                    [self.tabBarController setSelectedIndex:4];
                                                                    [self.navigationController pushViewController:accountView animated:NO];
                                                                }
                                                            }
                                                            else
                                                            {
                                                                [self.navigationController popViewControllerAnimated:YES];
                                                            }
                                                        }
                                                    }];
                 
             }
             else
             {
                 [self.view endEditing:YES];
                 [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
             }
         } else {
             
             NSLog(@"Error");
         }
     }];

}

- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    // [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        // [ProgressHUD dismiss];
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

    // Dispose of any resources that can b
-(void)doneWithNumberPad{
    [self.view endEditing:YES];
}

- (IBAction)comeBackLater:(id)sender {
    if (self.isFromCreditCardDeclinedStr) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSArray *viewControlles = self.navigationController.viewControllers;
        for (id object in viewControlles) {
            if ([object isKindOfClass:[AccountViewController class]]) {
                AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                accountView.isEmailVerifiedOrNotPage = NO;
                accountView.isFromUpdateMobileNumber = NO;
                accountView.isFromOrderProcess = NO;
                accountView.isFromCreditCardProcess = NO;
                [self.navigationController pushViewController:accountView animated:NO];
            }
        }
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
