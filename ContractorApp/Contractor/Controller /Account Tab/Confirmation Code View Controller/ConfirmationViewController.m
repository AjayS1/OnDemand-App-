//
//  ConfirmationViewController.m
//  Customer
//
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ConfirmationViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "SingletonClass.h"
#import "Define.h"
#import "ServerRequest.h"
#import "ProgressHUD.h"
#import "AlertView.h"
#import "AccountViewController.h"
#import "AppDelegate.h"

@interface ConfirmationViewController () {
    
    SingletonClass *sharedInstance;
}


@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([_activationCodeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please insert the mobile verification code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        
        [self updateMobileNumberApiCall];
    }}

#pragma mark-- Update Mobile Number API Call
- (void)updateMobileNumberApiCall
{
    // NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&verificationCodeMobile=%@&MobileNumber=%@",APIVerifyMobileNumber,userIdStr,_activationCodeTextField.text,self.mobileNumberString];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
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
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                           accountView.isFromUpdateMobileNumber = YES;
                                                           accountView.isFromOrderProcess = NO;
                                                           accountView.isFromCreditCardProcess = NO;
                                                           [self.navigationController pushViewController:accountView animated:NO];
                                                       }];
                } else {
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                           AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                           accountView.isFromUpdateMobileNumber = YES;
                                                           accountView.isFromOrderProcess = NO;
                                                           accountView.isFromCreditCardProcess = NO;
                                                           accountView.isEmailVerifiedOrNotPage = NO;
                                                           [self.navigationController pushViewController:accountView animated:NO];
                                                           
                                                       }];
                }
            }
        }
    }];
}

@end
