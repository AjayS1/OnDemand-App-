
//  LegalViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "LegalViewController.h"

@interface LegalViewController ()
@end

@implementation LegalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)termsButtonClicked:(id)sender {
    
    PrivacyPolicyWebViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy"];
    accountInfoView.self.termsPrivacyStr = @"Customer Terms of Service";
    [self.navigationController pushViewController:accountInfoView animated:YES];
}

- (IBAction)privacyPolicyButtonClicked:(id)sender {
    
    PrivacyPolicyWebViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy"];
    accountInfoView.self.termsPrivacyStr = @"Privacy Policy";
    [self.navigationController pushViewController:accountInfoView animated:YES];
}
@end
