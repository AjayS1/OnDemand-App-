
//  PrivacyPolicyWebViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "PrivacyPolicyWebViewController.h"

@interface PrivacyPolicyWebViewController () {
    UIWebView *webView;
}
@end

@implementation PrivacyPolicyWebViewController
@synthesize termsPrivacyStr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.termsPrivacyStr isEqualToString: @"Privacy Policy"]) {
        titleLabel.text = @"PRIVACY POLICY";
    }
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 68, self.view.frame.size.width,self.view.frame.size.height-68)];
    [webView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [webView setOpaque:NO];
    [self termsServicesApiCall];
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

- (void)termsServicesApiCall
{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:termsPrivacyStr,@"PageName",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIGetPrivacyTermsCondition withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                NSString *dataStr = [resultDict objectForKey:@"PageContent"];
                [webView loadHTMLString:dataStr baseURL:nil];
                [self.view addSubview:webView];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        else
        {
            NSLog(@"Error is found");
            [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
