//
//  OnDemandDateReasonForDeclineViewController.m
//  Contractor
//
//  Created by Jamshed Ali on 09/09/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "OnDemandDateReasonForDeclineViewController.h"
#import "DashboardViewController.h"
#import "OnDemandDatePushNotificationViewController.h"

#import "DatesViewController.h"
#import "DateReportSubmitViewController.h"

#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "SingletonClass.h"
#import "AppDelegate.h"

@interface OnDemandDateReasonForDeclineViewController () {
    
    SingletonClass *sharedInstance;
    NSArray *dateIssueArray;
    NSString *reasonIdStr;
    
}

@end

@implementation OnDemandDateReasonForDeclineViewController

@synthesize dateIdStr,dateDiclineOrDateCancelStr,titleStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    
    titleLabel.text = titleStr;
    reasonIdStr = @"";
    
    _settingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getDateIssueListApiCall];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    
    NSLog(@"checkSignalRReqest method Call");
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        
        NSString *dateIdString= [responseObject objectForKey:@"dateId"];
        
        NSDictionary *dataDictionary = @{@"DateID":dateIdString,@"Type":requestTypeStr};
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

- (void)getDateIssueListApiCall {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"MasterReasonForDeclinesContractorEnd",@"AttributeName",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlQA:APIDateIssueList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                dateIssueArray = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                [_settingsTableView reloadData];
                
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dateIssueArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    cell.nameLbl.text = [[dateIssueArray objectAtIndex:indexPath.row] objectForKey:@"Value"];
    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    reasonIdStr  = [NSString stringWithFormat:@"%@",[[dateIssueArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)dateCancelButtonClicked:(id)sender {
    
    if ([reasonIdStr isEqualToString:@""]) {
        [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select the issue." inController:self];
    }
    else {
        NSString *userIdStr = sharedInstance.userId;
        NSString *urlStr;
        urlStr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&ReasonID=%@&",APIDateDecline,userIdStr,self.dateIdStr,reasonIdStr];
        NSString *encodedUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    if (sharedInstance.onDemandPushNotificationArray.count >1) {
                        [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else {
                        sharedInstance.checkPushNotificationOnDemandStr = @"No";
                        [sharedInstance.onDemandPushNotificationArray removeObjectAtIndex:0];
                        DashboardViewController *dashBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
                        [self.navigationController pushViewController:dashBoard animated:YES];
                        
                    }
                    
                } else {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}


@end
