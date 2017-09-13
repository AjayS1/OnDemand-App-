
//  ForgotPasswordViewController.m
//  Customer
//  Created by Jamshed Ali on 12/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ForgotPasswordViewController.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
@interface ForgotPasswordViewController () {
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //NSString *urlAddress = @"http://ondemandappv2.flexsin.in/ForgetPassword/Index";
      NSString *urlAddress = @"http://api.doumees.com/ForgetPassword/Index";
//    NSString *urlAddress = @"http://ondemandapinew.flexsin.in/ForgetPassword/Index";
    [webViewForgetPassword setBackgroundColor:[UIColor whiteColor]];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webViewForgetPassword loadRequest:requestObj];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}
- (void)forgotPasswordApiCall {
}

- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
