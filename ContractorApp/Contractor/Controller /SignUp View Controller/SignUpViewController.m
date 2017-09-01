
//  SignUpViewController.m
//  Customer
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SignUpViewController.h"
#import "AppDelegate.h"

@interface SignUpViewController () {
    UIView *navbar;
}
@end

@implementation SignUpViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    [self createWebviewCall];
}

- (void)createWebviewCall {
    
    UIWebView *webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 68, self.view.frame.size.width,self.view.frame.size.height-68)];

    NSString *url=@"http://doumees.flexsin.in/Contractor/signup";
    [webview setBackgroundColor:[UIColor whiteColor]];
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webview loadRequest:nsrequest];
    [self.view addSubview:webview];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (IBAction)back:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
