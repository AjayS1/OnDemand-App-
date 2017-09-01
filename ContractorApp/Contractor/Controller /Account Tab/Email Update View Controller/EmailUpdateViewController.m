
//  EmailUpdateViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "EmailUpdateViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "VerifyViewController.h"
#import "ServerRequest.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
@interface EmailUpdateViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation EmailUpdateViewController
@synthesize userFirstNameStr;

#pragma mark: UiviewController Life Cycle Method
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    emailTextField.text = self.userEmailStr;
    
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
    if (sharedInstance.isEmailVerifiedAlreadyOrNot == true) {
        [self.verifyLinkButton setHidden:YES];
    }
    else{
        [self.verifyLinkButton setHidden:NO];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}

#pragma mark: Check sIgnalR Recieved Request
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


#pragma mark:TextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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

-(IBAction)VerifyButtonClicked:(id)sender
{
    VerifyViewController *verifyView = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyEmail"];
    [self.navigationController pushViewController:verifyView animated:YES];

}

- (IBAction)nextButtonClicked:(id)sender {
    
    if (![CommonUtils isValidEmailId:emailTextField.text]){
        
        [[[UIAlertView alloc]initWithTitle:@"Alert" message:@"This email address is invalid." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];

    }
    else {
//        VerifyViewController *verifyView = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyEmail"];
//        [self.navigationController pushViewController:verifyView animated:YES];
        [self updateEmailApiCall];
    }
    
}

#pragma mark-- Update Email API Call
- (void)updateEmailApiCall
{
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Email=%@&userName=%@",APIChangeEmail,userIdStr,emailTextField.text,self.userFirstNameStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //[CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    VerifyViewController *verifyView = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyEmail"];
                    [self.navigationController pushViewController:verifyView animated:YES];
                    
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}


@end
