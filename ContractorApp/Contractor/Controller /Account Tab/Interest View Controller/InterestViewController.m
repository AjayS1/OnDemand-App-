
//  InterestViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "InterestViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "AppDelegate.h"

@interface InterestViewController () {
    
    NSString *interstedStr;
    
    SingletonClass *sharedInstance;
    
}

@end

@implementation InterestViewController

@synthesize userInterestedInStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    
    if ([userInterestedInStr isEqualToString:@"Female"]) {
        _femaleImage.image = [UIImage imageNamed:@"right-dark"];
    } else if ([userInterestedInStr isEqualToString:@"Male"]) {
        _maleImage.image = [UIImage imageNamed:@"right-dark"];
    } else {
        _bothImage.image = [UIImage imageNamed:@"right-dark"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        
        [self.navigationController pushViewController:dateDetailsView animated:YES];
        
    } else {
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
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
    
    
    NSString *userIdStr = sharedInstance.userId;
    
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIUpdateGenderInterest,userIdStr,@"InterestedIn",interstedStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    if ([interstedStr isEqualToString:@"1"]) {
                        
                        _maleImage.image = [UIImage imageNamed:@"right-dark"];
                        _maleImage.hidden = NO;
                        _femaleImage.hidden = YES;
                        _bothImage.hidden= YES;
                        
                        
                    } else if ([interstedStr isEqualToString:@"2"]) {
                        _femaleImage.image = [UIImage imageNamed:@"right-dark"];
                        _maleImage.hidden = YES;
                        _femaleImage.hidden = NO;
                        _bothImage.hidden= YES;
                    } else {
                        _bothImage.image = [UIImage imageNamed:@"right-dark"];
                        _maleImage.hidden = YES;
                        _femaleImage.hidden = YES;
                        _bothImage.hidden= NO;
                    }
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
    
    
}



@end
