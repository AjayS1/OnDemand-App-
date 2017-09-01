
//  ProfileDateCommnetsViewController.m
//  Customer
//  Created by Jamshed on 7/13/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "ProfileDateCommnetsViewController.h"

@interface ProfileDateCommnetsViewController ()
{
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end

@implementation ProfileDateCommnetsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    commentTextView.layer.cornerRadius = 0;
    commentTextView.layer.borderWidth = 1;
    commentTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    commentTextView.backgroundColor = [UIColor whiteColor];
    
    if([self.titleStr isEqualToString:@"Comment"]) {
        titleLabel.text = @"ABOUT ME";
        commentTextView.text = self.dateLikeMessageStr;
        
    } else if([self.titleStr isEqualToString:@"Date Comment"]) {
        
        titleLabel.text = @"MY INTERESTS";
        commentTextView.text = self.dateLikeMessageStr;
        
    } else {
        
        titleLabel.text = self.titleStr;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
}

#pragma mark--  Change profileData API

- (void)changeCommentProfileDataApiCall {
    
    NSString *dataTypestr;
     NSString *titleValueStr;
    if([self.titleStr isEqualToString:@"Comment"])
    {
        dataTypestr= @"Description";
        titleValueStr = @"About Me";
    }
    else if ([self.titleStr isEqualToString:@"Date Comment"])
    {
        dataTypestr= @"MyDatePreferences";
        titleValueStr = @"My Interests";

    }
//    NSString *commentAlue = [commentTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    commentAlue = [commentAlue stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,dataTypestr,commentTextView.text];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                [[AlertView sharedManager] presentAlertWithTitle:titleValueStr message:@"Updated successfully."
                                             andButtonsWithTitle:@[@"Ok"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"Ok"]) {
                         [self.navigationController popViewControllerAnimated:YES];
                     }}];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self changeCommentProfileDataApiCall];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



@end
