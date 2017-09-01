//
//  UnitsViewController.m
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "UnitsViewController.h"

@interface UnitsViewController () {
    
    NSString *meterOrInchStr;
    
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    
}

@end

@implementation UnitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [self fetchUserheightMeasurementApiData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)feetButtonClicked:(id)sender {
    
    meterOrInchStr  =@"1";
    [self updateheightMeasurementApiData];
}


- (IBAction)centeMeterButtonClicked:(id)sender {
    
    meterOrInchStr  =@"2";
    [self updateheightMeasurementApiData];
}

#pragma mark-- Get User Height Measurement API
- (void)fetchUserheightMeasurementApiData {
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",@"Unit",@"AttributeName",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIUserAttribute withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([[responseObject objectForKey:@"AttibuteID"] isEqualToString:@"1"]) {
                    selectFirstImageView.image = [UIImage imageNamed:@"right-dark"];
                    sharedInstance.strUnityTypeValue = @"1";
                    selectSecondIMageView.image = [UIImage imageNamed:@""];
                    
                } else {
                    selectSecondIMageView.image = [UIImage imageNamed:@"right-dark"];
                    sharedInstance.strUnityTypeValue = @"2";
                    selectFirstImageView.image = [UIImage imageNamed:@""];
                    
                }
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}


#pragma mark-- Update User Height Measurement API
- (void)updateheightMeasurementApiData {
    
    //    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",@"UnitType",@"attributeType",meterOrInchStr,@"attributeValue",nil];
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,@"UnitType",meterOrInchStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [self fetchUserheightMeasurementApiData];
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}

@end
