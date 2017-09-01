
//  VerifyViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "VerifyViewController.h"
#import "AccountViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
#import "ServerRequest.h"

@interface VerifyViewController ()<UITextFieldDelegate> {
    SingletonClass *sharedInstance;
}
@end

@implementation VerifyViewController

#pragma mark: UIview Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    
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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}

#pragma mark: SignalR Request Methode
- (void)checkSignalRReqest:(NSNotification*) noti {
    
    //  NSDictionary *dateData = @{@"userId":userIdStr,@"dateCount":dateCountStr,@"messageCount":mesagesCountStr,@"notificationCount":notificationsCountStr,@"dateType":typeIdStr,@"dateId":dateIdStr};
    
    NSLog(@"checkSignalRReqest method Call");
    
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



#pragma mark: Memory mangement Methode action
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark: UItextField Delegate methde
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark: UIButton Action methde
- (IBAction)backButtonClicked:(id)sender {
    AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.isFromOrderProcess = NO;
    accountView.isFromUpdateMobileNumber = NO;
    accountView.isFromCreditCardProcess = NO;
    accountView.isEmailVerifiedOrNotPage = YES;
     [self.navigationController pushViewController:accountView animated:NO];
   // [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    //[self.navigationController popViewControllerAnimated:YES];
    
    if([self.codeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        
        [self updateEmailApiCall];
        
    }
    
}

#pragma mark-- Update Email Code Verify API Call

- (void)updateEmailApiCall {
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    //   NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",codeTextField.text,@"VerificationCode",nil];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&VerificationCode=%@",APIEmailCodeVerify,userIdStr,self.codeTextField.text];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                accountView.isFromOrderProcess = NO;
                accountView.isFromUpdateMobileNumber = NO;
                accountView.isFromCreditCardProcess = NO;
                accountView.isEmailVerifiedOrNotPage = YES;
                 [self.navigationController pushViewController:accountView animated:NO];
                
            }
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}



@end
