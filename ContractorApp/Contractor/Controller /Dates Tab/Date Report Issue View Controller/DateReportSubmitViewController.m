
//  DateReportSubmitViewController.m
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DateReportSubmitViewController.h"
#import "DatesViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "SingletonClass.h"
#import "AlertView.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "DatesViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"
@interface DateReportSubmitViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation DateReportSubmitViewController

@synthesize requestTypeStr,dateIdStr,issueIdStr,requestType;

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    _messageTextView.layer.cornerRadius = 0;
    _messageTextView.layer.borderWidth = 1.0;
    _messageTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeString = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeString isEqualToString:@"1"]) {
        
        NSString *dateIdString = [responseObject objectForKey:@"dateId"];
        
        NSDictionary *dataDictionary = @{@"DateID":dateIdString,@"Type":requestTypeString};
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


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonClicked:(id)sender {
    
    if (_messageTextView.text) {
        
        if([self.requestType isEqualToString:@"pastDateDetails"]) {
            NSString *userIdStr = sharedInstance.userId;
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&IssueID=%@&Notes=%@&usertype=%@",APIDateCompletedSubmitIssueApiCall,userIdStr,self.dateIdStr,self.issueIdStr,_messageTextView.text,@"1"];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                
                [ProgressHUD dismiss];
                if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                    //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                    
                }
                else{
                    if(!error){
                        
                        NSLog(@"Response is --%@",responseObject);
                        
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
                             {
                                 if ([buttonTitle isEqualToString:@"OK"]) {
                                     
                                     [self.navigationController popViewControllerAnimated:NO];
                                     sharedInstance.isFromReportSubmit = YES;
                                 }}];
                        }
                        else {
                            
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        }
                    }
                    else {
                        
                        NSLog(@"Error");
                    }
                }
            }];
            
        }
        else if ([self.requestType isEqualToString:@"ProfileReport"]) {
            
            NSString *userIdStr = sharedInstance.userId;
            NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&DateID=%@&Description=%@&Type=%@",APIReportUser,self.customerIdStr,userIdStr,self.dateIdStr,_messageTextView.text,@"2"];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                    //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                    
                }
                else{
                    if(!error){
                        
                        NSLog(@"Response is --%@",responseObject);
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            
                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                         andButtonsWithTitle:@[@"OK"] onController:self
                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle)
                             {
                                 if ([buttonTitle isEqualToString:@"OK"])
                                 {
                                     [self tabBarControllerClass];
                                 }
                                }
                             ];
                        }
                        else {
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        }
                    }
                }
            }];
            
            
        }
        else if ([self.requestType isEqualToString:@"OnDemandProfileReport"]) {
            
            NSString *userIdStr = sharedInstance.userId;
            NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&DateID=%@&Description=%@&Type=%@",APIReportUser,self.customerIdStr,userIdStr,self.dateIdStr,_messageTextView.text,@"2"];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                    // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                    
                }
                else
                {
                    if(!error)
                    {
                        
                        NSLog(@"Response is --%@",responseObject);
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                            if (sharedInstance.onDemandPushNotificationArray.count >1) {
                                [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            else {
                                
                                sharedInstance.checkPushNotificationOnDemandStr = @"No";
                                [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                                [self tabBarControllerClass];
                                //                            DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                //                            [self.navigationController pushViewController:datesView animated:YES];
                                
                            }
                        }
                        else
                        {
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        }
                    }
                }
            }];
        }
    }
    else {
        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please enter the message." inController:self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
    // datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    //  messageView.tabBarItem.badgeValue = messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    // notiView.tabBarItem.badgeValue = notificationsCountStr;
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
