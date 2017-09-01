
//  VerifyViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "VerifyViewController.h"
@interface VerifyViewController () {
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end
#pragma mark: UIview Controller Life Cycle

@implementation VerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  start];
    }
}

#pragma mark: UItextField Delegate methde
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark: Memory mangement Methode action

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark: UIButton Action methde

- (IBAction)backButtonClicked:(id)sender {
    
    AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.isFromOrderProcess = NO;
    accountView.isFromUpdateMobileNumber = NO;
    accountView.isFromCreditCardProcess = NO;
    accountView.isEmailVerifiedOrNotPage = YES;
    [self.navigationController pushViewController:accountView animated:NO];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([codeTextField.text length]==0) {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please insert the code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else {
        [self updateEmailApiCall];
    }
}

#pragma mark-- Update Email Code Verify API Call

- (void)updateEmailApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&VerificationCode=%@",APIEmailCodeVerify,userIdStr,codeTextField.text];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
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
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

@end
