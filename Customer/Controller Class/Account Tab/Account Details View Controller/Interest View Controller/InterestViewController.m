
//  InterestViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "InterestViewController.h"

@interface InterestViewController () {
    
    NSString *interstedStr;
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end

@implementation InterestViewController

@synthesize userInterestedInStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if ([userInterestedInStr isEqualToString:@"Female"]) {
        _femaleImage.image = [UIImage imageNamed:@"right-dark"];
    } else if ([userInterestedInStr isEqualToString:@"Male"]) {
        _maleImage.image = [UIImage imageNamed:@"right-dark"];
    } else {
        _bothImage.image = [UIImage imageNamed:@"right-dark"];
    }
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

- (IBAction)maleButtonClicked:(id)sender
{
    interstedStr = @"1";
    [self updateGenderInterestApiCall];
}

- (IBAction)femaleButtonClciked:(id)sender
{
    interstedStr = @"2";
    [self updateGenderInterestApiCall];
}

- (IBAction)bothButtonClicked:(id)sender
{
    interstedStr = @"3";
    [self updateGenderInterestApiCall];
}

- (void)updateGenderInterestApiCall {
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIUpdateGenderInterest,userIdStr,@"InterestedIn",interstedStr];
    
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([interstedStr isEqualToString:@"1"]) {
                    sharedInstance.interestedGender = @"Male";
                    _maleImage.image = [UIImage imageNamed:@"right-dark"];
                    _maleImage.hidden = NO;
                    _femaleImage.hidden = YES;
                    _bothImage.hidden= YES;
                }
                else if ([interstedStr isEqualToString:@"2"]) {
                    sharedInstance.interestedGender = @"Female";
                    _femaleImage.image = [UIImage imageNamed:@"right-dark"];
                    _maleImage.hidden = YES;
                    _femaleImage.hidden = NO;
                    _bothImage.hidden= YES;
                }
                else {
                    sharedInstance.interestedGender = @"Both";
                    _bothImage.image = [UIImage imageNamed:@"right-dark"];
                    _maleImage.hidden = YES;
                    _femaleImage.hidden = YES;
                    _bothImage.hidden= NO;
                }
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}



@end
