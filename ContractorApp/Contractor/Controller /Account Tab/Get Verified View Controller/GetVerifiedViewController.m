
//  GetVerifiedViewController.m
//  Customer
//  Created by Jamshed Ali on 21/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "GetVerifiedViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "PhotoVerificationViewController.h"
#import "IDVerificationViewController.h"
#import "BackgroundCheckedViewController.h"
#import "ServerRequest.h"
#import "LCTabBarController.h"
#import "AppDelegate.h"

@interface GetVerifiedViewController () {
    
    LCTabBarController *tabBarC;
    SingletonClass *sharedInstance;
}

@end

@implementation GetVerifiedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
    [self fetchGetVerifiedUserApiData];
    
    
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



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)photoVerificationButtonClicked:(id)sender {
    
    PhotoVerificationViewController *photoVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"photoVerification"];
    [self.navigationController pushViewController:photoVerify animated:YES];
    
}

- (IBAction)idVerificationButtonCLicked:(id)sender {
    
    IDVerificationViewController *idVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"idVerification"];
    [self.navigationController pushViewController:idVerify animated:YES];
}

- (IBAction)backgorundChecked:(id)sender {
    
    BackgroundCheckedViewController *idVerify = [self.storyboard instantiateViewControllerWithIdentifier:@"backgroundChecked"];
    [self.navigationController pushViewController:idVerify animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark--Get Verified User  API Call
-(void)fetchGetVerifiedUserApiData
{
    
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:APIGetVerifyUserInfo withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
           
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    
                    NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                    
                    if ([[resultDict objectForKey:@"PhotoStatus"] isEqualToString:@"1"]) {
                        
                        photoVerificationButton.userInteractionEnabled = NO;
                        // photoVerifyImageView.image = [UIImage imageNamed:@"check_icon.png"];
                        photoVerifyImageView.image = [UIImage imageNamed:@"rgt"];
                        
                        //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is already verified." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"PhotoStatus"] isEqualToString:@"2"]) {
                        
                        //photoVerifyImageView.image = [UIImage imageNamed:@"block-icon.png"];
                        photoVerifyImageView.image = [UIImage imageNamed:@"arrow"];
                        
                        // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is rejected." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"PhotoStatus"] isEqualToString:@"0"]) {
                        
                        photoVerifyImageView.image = [UIImage imageNamed:@"warng"];
                        photoVerificationButton.userInteractionEnabled = NO;
                        
                        //   [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is waiting for a approval from Admin." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"PhotoStatus"] isEqualToString:@"10"]) {
                        
                        photoVerifyImageView.image = [UIImage imageNamed:@"arrow"];
                    }
                    
                    if ([[resultDict objectForKey:@"DocumentStatus"] isEqualToString:@"1"]) {
                        
                        idVerificationButton.userInteractionEnabled = NO;
                        idVerificationImageView.image = [UIImage imageNamed:@"rgt"];
                        
                        // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your id verification is already verified." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"DocumentStatus"] isEqualToString:@"2"]) {
                        
                        idVerificationImageView.image = [UIImage imageNamed:@"arrow"];
                        
                        //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your id verification is rejected." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"DocumentStatus"] isEqualToString:@"0"]) {
                        
                        idVerificationImageView.image = [UIImage imageNamed:@"warng"];
                        idVerificationButton.userInteractionEnabled = NO;
                        
                        //   [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your photo verification is waiting for a approval from Admin." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"DocumentStatus"] isEqualToString:@"10"]) {
                        
                        idVerificationImageView.image = [UIImage imageNamed:@"arrow"];
                    }
                    
                    if ([[resultDict objectForKey:@"BackGroundStatus"] isEqualToString:@"1"]) {
                        
                        backgroundCheckedButton.userInteractionEnabled = NO;
                        backgroundCheckImageView.image = [UIImage imageNamed:@"rgt"];
                        
                        //        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your background verification is already verified." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"BackGroundStatus"] isEqualToString:@"2"]) {
                        
                        backgroundCheckImageView.image = [UIImage imageNamed:@"arrow"];
                        // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your background verification is rejected." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"BackGroundStatus"] isEqualToString:@"0"]) {
                        
                        backgroundCheckImageView.image = [UIImage imageNamed:@"warng"];
                        backgroundCheckedButton.userInteractionEnabled = NO;
                        // [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your background verification is waiting for a approval from Admin." inController:self];
                        
                    } else if ([[resultDict objectForKey:@"BackGroundStatus"] isEqualToString:@"10"]) {
                        
                        backgroundCheckImageView.image = [UIImage imageNamed:@"arrow"];
                    }
                }
                else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}


@end
