
//  EmailUpdateViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "EmailUpdateViewController.h"

@interface EmailUpdateViewController () {
    
    SingletonClass *sharedInstance;
    
    NSString *userIdStr;
}

@end

@implementation EmailUpdateViewController
@synthesize userFirstNameStr;
#pragma mark: UiviewController Life Cycle Method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    emailTextField.layer.borderColor =[CommonUtils colorWithHexString:@"CCCCCC"].CGColor;
    emailTextField.text = self.userEmailStr;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    if (sharedInstance.isEmailVerifiedAlreadyOrNot == true) {
        [self.verifyLinkButton setHidden:YES];
    }
    else{
        [self.verifyLinkButton setHidden:NO];
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
        [[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"This email address is invalid." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        
    }
    else {
        [self updateEmailApiCall];
    }
}

#pragma mark-- Update Email API Call

- (void)updateEmailApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&Email=%@&userName=%@",APIChangeEmail,userIdStr,emailTextField.text,self.userFirstNameStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                VerifyViewController *verifyView = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyEmail"];
                [self.navigationController pushViewController:verifyView animated:YES];
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


@end
