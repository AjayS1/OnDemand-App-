
//  CloseAccountViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "CloseAccountViewController.h"

@interface CloseAccountViewController () {
    SingletonClass *sharedInstance;
}
@end

@implementation CloseAccountViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    commentsTextView.layer.cornerRadius = 0;
    commentsTextView.layer.borderWidth = 1.0;
    commentsTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    commentsTextView.backgroundColor = [UIColor whiteColor];
    sharedInstance = [SingletonClass sharedInstance];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection)
    {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
    //The event handling method
  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
  //  CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.view endEditing:YES];
    [commentsTextView resignFirstResponder];
    
    //Do stuff here...
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Close Account Method Call
- (IBAction)confirmCloseAccountButtonClicked:(id)sender {
    if([commentsTextView.text length]==0) {
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please insert the comments." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
    }
    else
    {
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
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
                [self.navigationController pushViewController:loginView animated:YES];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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
