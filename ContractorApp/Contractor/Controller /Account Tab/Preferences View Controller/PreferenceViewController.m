//
//  PreferenceViewController.m
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "PreferenceViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "GenderPreferenceViewController.h"
#import "PreferencDistanceViewController.h"
#import "CurrentLocationsViewController.h"
#import "PaymentTypesViewController.h"
#import "AppDelegate.h"

@interface PreferenceViewController () {
    
    SingletonClass *sharedInstance;
}

@end

@implementation PreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    paymentModeArr= [[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    paymentModeArr= [[NSMutableArray alloc]init];
    [self fetchPreferencesApiData];
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
    
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"checkSignalRReqest"
    //                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}


#pragma mark-- Preferences API Call

- (void)fetchPreferencesApiData {
    
    NSString *userIdStr = sharedInstance.userId;
    
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?ContractorID=%@",APIPrefernceData,userIdStr];
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
                    
                    NSDictionary *itemDict = [responseObject valueForKey:@"Item"];
                    genderPreferneceLable.text = [itemDict valueForKey:@"GenderPrefrences"];
                    genderLl = genderPreferneceLable.text;
                    distanceLable.text = [itemDict valueForKey:@"Distance"];
                    currentLocationLable.text = [itemDict valueForKey:@"CurrrentLocation"];
                    //paymentTypeLable.text = [itemDict valueForKey:@"PaymentTypeAccepted"];
                    
                    NSDictionary *dictObj = [responseObject valueForKey:@"PaymentMethodItem"];
                    paymentDictData = [dictObj valueForKey:@"PaymentMethodItem"];
                    
                    
                    NSString *VemnoPament = [paymentDictData valueForKey:@"isVenmoPaymentReceiveMethod"];
                    NSString *squareCashPament = [paymentDictData valueForKey:@"isSquareCashPaymentReceiveMethod"];
                    NSString *payPalPament = [paymentDictData valueForKey:@"isPayPalPaymentReceiveMethod"];
                    NSString *cashPament = [paymentDictData valueForKey:@"isCashPaymentReceiveMethod"];
                    NSString *strObj;
                    
                    if([VemnoPament isEqualToString:@"True"]){
                        strObj = @"Venmo";
                        [paymentModeArr addObject:strObj];
                    } if ([squareCashPament isEqualToString:@"True"]){
                        strObj = @"SquareCash";
                        [paymentModeArr addObject:strObj];
                    } if ([payPalPament isEqualToString:@"True"]){
                        strObj = @"PayPal";
                        [paymentModeArr addObject:strObj];
                    } if ([cashPament isEqualToString:@"True"]){
                        strObj = @"Cash";
                        [paymentModeArr addObject:strObj];
                    }
                    NSString *str = [paymentModeArr componentsJoinedByString:@","];
                    paymentTypeLable.text = str;
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            } else {
                
                NSLog(@"Error");
            }
        }
        
    }];}


- (IBAction)backButtonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)genderPreferneceButtonClicked:(id)sender {
    
    GenderPreferenceViewController *preferenceInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"preferneceSession"];
    NSString *genderTypeStr = genderPreferneceLable.text;
    preferenceInfoView.genderStr = genderTypeStr;
    [self.navigationController pushViewController:preferenceInfoView animated:YES];
}
- (IBAction)distanceButtonClicked:(id)sender {
    
    PreferencDistanceViewController *preferenceDistanceView = [self.storyboard instantiateViewControllerWithIdentifier:@"preferneceDistance"];
    NSString *distanceTypeStr = distanceLable.text;
    preferenceDistanceView.selectedIndexxStr = distanceTypeStr;
    [self.navigationController pushViewController:preferenceDistanceView animated:YES];
}
- (IBAction)currentLocationButtonClicked:(id)sender {
    CurrentLocationsViewController *currentLocationView = [self.storyboard instantiateViewControllerWithIdentifier:@"currentLocation"];
    [self.navigationController pushViewController:currentLocationView animated:YES];
}
- (IBAction)paymentTypeButtonClicked:(id)sender {
    
    PaymentTypesViewController *paymentTypeView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentTypeView"];
    paymentTypeView.paymentTypeDict = paymentDictData;
    [self.navigationController pushViewController:paymentTypeView animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
