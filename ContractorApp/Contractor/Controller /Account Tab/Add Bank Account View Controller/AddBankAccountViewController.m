
//  AddBankAccountViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "AddBankAccountViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "BankAccountVerificationViewController.h"
#import "ServerRequest.h"
#import "AlertView.h"
#import "OptionPickerViewSheet.h"
#import "AppDelegate.h"
#import "DatesViewController.h"
#import "DashboardViewController.h"
#import "AccountViewController.h"
#import "NotificationsViewController.h"
#import "MessagesViewController.h"
#import "ViewController.h"
@interface AddBankAccountViewController () {
    
    SingletonClass *sharedInstance;
    NSArray *arrAccountType;
    NSString *currenTDateTime;
    NSString * dateCountStr;
    NSString *messageCountString;
    NSString * notificationsCountStr;
    
}

@end

@implementation AddBankAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    arrAccountType = [[NSArray alloc]initWithObjects:@"Personal Checking",@"Personal Savings", nil];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    [scrollView addGestureRecognizer:gestureRecognizer];
    
}

-(void)getCurrenTDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, YYYY"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    currenTDateTime =[dateFormatter stringFromDate:[NSDate date]];
    
}
-(void) hideKeyBoard:(id) sender {
    // Do whatever such as hiding the keyboard
    [self.view endEditing:YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self getCurrenTDate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
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
        
    } else {
        
    }
}


- (void)viewDidLayoutSubviews {
    
    scrollView.contentSize = CGSizeMake(320, 800);
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

-(BOOL)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == accountTypeTextField){
        [self.view endEditing:YES];
        [[OptionPickerViewSheet sharedPicker] showPickerSheetWithOptions:arrAccountType AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
            sharedInstance.bankAccountType = selectedText;
            [textField setText:sharedInstance.bankAccountType];
            
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == accountTypeTextField) {
        sharedInstance.bankAccountType = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if(textField == accountTypeTextField){
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addBankAccountClicked:(id)sender {
    
    if([accountTypeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select the account type." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([bankNameTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the bank name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([accountHolderTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the account holder name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }else if([routingNumberTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the routing number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([accountNumberTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the bank account number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        if (self.isFromNonSufficientScreen) {
            [self addBankAccountFromNonSufficientScreen];
            
        }
        else{
            [self addBankAccounMethode];
        }
    }
}

-(void)addBankAccountFromNonSufficientScreen{
    
    NSString *ipAddressStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"IPAddressValue"];
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:userIdStr forKey:@"UserID"];
    if ([accountTypeTextField.text isEqualToString:@"Personal Checking"])
    {
        [params setValue:@"1" forKey:@"AccountType"];
        
    }else if ([accountTypeTextField.text isEqualToString:@"Personal Savings"])
    {
        [params setValue:@"2" forKey:@"AccountType"];
        
    }
    else{
        [params setValue:@"2" forKey:@"AccountType"];
    }
    [params setValue:bankNameTextField.text forKey:@"BankName"];
    [params setValue:accountHolderTextField.text forKey:@"AccountHolderName"];
    [params setValue:routingNumberTextField.text forKey:@"RoutingNumber"];
    [params setValue:accountNumberTextField.text forKey:@"AccountNumber"];
    [params setValue:ipAddressStr forKey:@"IpAddress"];
    [params setValue:self.dateIDString forKey:@"DateID"];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:APIAddBankAccountDetailForNonSufficient withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"OK"]) {
                             [self tabBarCountApiCall];
                         }}];
                }
                else {
                    
                    if (![[responseObject objectForKey:@"Message"]isKindOfClass:[NSNull class]]) {
                        //[self.navigationController popViewControllerAnimated:YES];
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                    else{
                        // [self.navigationController popViewControllerAnimated:YES];
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"No Message" inController:self];
                    }
                }}
        }
    }];
}

-(void)addBankAccounMethode{
    
    NSString *ipAddressStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"IPAddressValue"];
    
    NSString *userIdStr = sharedInstance.userId;
    /*
     arrAccountType = [[NSArray alloc]initWithObjects:@"Personal Checking",@"Personal Savings", nil];
     
     */
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:userIdStr forKey:@"userID"];
    if ([accountTypeTextField.text isEqualToString:@"Personal Checking"])
    {
        [params setValue:@"1" forKey:@"AccountType"];
        
    }else if ([accountTypeTextField.text isEqualToString:@"Personal Savings"])
    {
        [params setValue:@"2" forKey:@"AccountType"];
        
    }
    else{
        [params setValue:@"2" forKey:@"AccountType"];
    }
    [params setValue:bankNameTextField.text forKey:@"BankName"];
    [params setValue:accountHolderTextField.text forKey:@"AccountHolderName"];
    [params setValue:routingNumberTextField.text forKey:@"RoutingNumber"];
    [params setValue:accountNumberTextField.text forKey:@"AccountNumber"];
    [params setValue:ipAddressStr forKey:@"IpAddress"];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForQA:APIAddBankAccountDetail withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"OK"]) {
                             AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                             accountView.isFromOrderProcess = NO;
                             accountView.isFromAddBankAccountProcess = YES;
                             [self.navigationController pushViewController:accountView animated:NO];
                         }}];
                }
                else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2){
                    
                    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                    [self.navigationController pushViewController:loginView animated:NO];
                    
                }
                else {
                    
                    if (![[responseObject objectForKey:@"Message"]isKindOfClass:[NSNull class]]) {
                        //[self.navigationController popViewControllerAnimated:YES];
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                    else{
                        // [self.navigationController popViewControllerAnimated:YES];
                        
                        [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        
                    }
                    
                }}
        }
    }];
}


- (void)tabBarCountApiCall {
    
    NSString *loginID = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:loginID,@"UserID",@"2" ,@"userType",nil];
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
                    messageCountString = nil;
                }
                else {
                    messageCountString = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
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
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.isFromDateDetails = NO;
    
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    messageView.tabBarItem.badgeValue = messageCountString;
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
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
}

@end
