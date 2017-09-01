
//  CloseAccountViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "CloseAccountViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ViewController.h"
#import "ServerRequest.h"
#import "UIColor+Demo.h"
#import "AppDelegate.h"
@interface CloseAccountViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation CloseAccountViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    commentsTextView.layer.cornerRadius = 0;
    commentsTextView.layer.borderWidth = 1.0;
    commentsTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    commentsTextView.backgroundColor = [UIColor whiteColor];
    sharedInstance = [SingletonClass sharedInstance];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.view endEditing:YES];
    [commentsTextView resignFirstResponder];
    
    //Do stuff here...
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


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmCloseAccountButtonClicked:(id)sender {
    
    if([commentsTextView.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert the comments." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        
        [self closedUserAccountApiCall];
    }
}

#pragma mark-- Closed User Account API Call
- (void)closedUserAccountApiCall
{
    
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&UserBy=%@&userComment=%@",APIUserAccountClosed,userIdStr,userIdStr,commentsTextView.text];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                    [self.navigationController pushViewController:loginView animated:YES];
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    } ];
}



@end
