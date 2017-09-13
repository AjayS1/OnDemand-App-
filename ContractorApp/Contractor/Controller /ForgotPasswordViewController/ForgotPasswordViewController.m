
//  ForgotPasswordViewController.m
//  Customer
//  Created by Jamshed Ali on 12/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ForgotPasswordViewController.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
@interface ForgotPasswordViewController () 

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlAddress = @"http://www.doumees.com/ForgetPassword/Index";
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webViewForgetPassword setBackgroundColor:[UIColor whiteColor]];
    [webViewForgetPassword loadRequest:requestObj];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
