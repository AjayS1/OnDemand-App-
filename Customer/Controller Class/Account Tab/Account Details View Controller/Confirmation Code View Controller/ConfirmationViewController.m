
//  ConfirmationViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ConfirmationViewController.h"

@interface ConfirmationViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([activationCodeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the verification code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else {
        
        [self updateMobileNumberApiCall];
    }
}


#pragma mark-- Update Mobile Number API Call
- (void)updateMobileNumberApiCall
{
    // NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&verificationCodeMobile=%@&MobileNumber=%@",APIVerifyMobileNumber,userIdStr,activationCodeTextField.text,self.mobileNumberString];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       AccountViewController *confirmCodeView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                       confirmCodeView.isFromUpdateMobileNumber = YES;
                                                       confirmCodeView.isFromOrderProcess = NO;
                                                       confirmCodeView.isFromCreditCardProcess = NO;
                                                       [self.navigationController pushViewController:confirmCodeView animated:NO];
                                                       
                                                   }];
            } else {
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       AccountViewController *confirmCodeView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                                                       confirmCodeView.isFromUpdateMobileNumber = YES;
                                                       confirmCodeView.isFromOrderProcess = NO;
                                                       confirmCodeView.isFromCreditCardProcess = NO;
                                                       confirmCodeView.isEmailVerifiedOrNotPage = NO;
                                                       [self.navigationController pushViewController:confirmCodeView animated:NO];
                                                   }];
            }
        }
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



@end
