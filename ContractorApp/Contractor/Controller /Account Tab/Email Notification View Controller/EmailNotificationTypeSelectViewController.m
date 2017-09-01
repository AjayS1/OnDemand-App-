
//  EmailNotificationTypeSelectViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "EmailNotificationTypeSelectViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "AppDelegate.h"

@interface EmailNotificationTypeSelectViewController () {
    
    NSArray *titleArray;
    NSString *settingsOnStr;
    SingletonClass *sharedInstance;
    BOOL settingOnValue;
}

@end

@implementation EmailNotificationTypeSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    titleArray = @[@"Announcements",@"New Messages",@"Date Accepted",@"Date Declined",@"Date Expired",@"Date Arrived",@"Date Started",@"Date Completed",@"Date Cancelled",@"Date Summary"];
    emailSettingsData = [[NSMutableArray alloc]init];
    [self fetchEmailNotificationSettingsApiCall];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //Creating View
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    //Creating Label
    UILabel *lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [headerView addSubview:lineView];
    //Creating Label
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (emailSettingsData.count) {
        return emailSettingsData.count;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationTableViewCell *cell;
    cell = nil;
    SingletonClass *customObject = [emailSettingsData objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
        settingOnValue =[NSString stringWithFormat:@"%@",customObject.strIsMobileNotification];
        if (settingOnValue == 1) {
            UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 15, 20, 20)];
            selectImageView.image = [UIImage imageNamed:@"select"];
            [cell.contentView addSubview:selectImageView];
        }
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    cell.nameLbl.text = customObject.strEventType;
    if(customObject.strIsSelectedNotification == YES){
        cell.accessoryView = imageView;
        //customObject.checkLocationStr = NO;
    }
    else {
        cell.accessoryView = NULL;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }     return cell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SingletonClass *customObj= [emailSettingsData objectAtIndex:indexPath.row];
    
    if (customObj.strIsSelectedNotification) {
        settingsOnStr = customObj.strEventType;
        [self updateEmailNotificationSettingsApiData:customObj.strEventType withStatus:@"0"];
    }
    else{
        [self updateEmailNotificationSettingsApiData:customObj.strEventType withStatus:@"1"];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-- Get Push Notificatioin API Call

-(void)fetchEmailNotificationSettingsApiCall
{
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",@"listEmailNotification",@"NotificationType",
                                 @"1",@"UserType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlQA:APIEmailNotificationSettings withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                    NSArray *arrData = [pushSettingsDictionary objectForKey:@"MasterValues"];
                    emailSettingsData = [SingletonClass parseDateForLocation:arrData];
                    for (SingletonClass *customerObject in emailSettingsData) {
                        NSString *string = [NSString stringWithFormat:@"%@", customerObject.IsEmailNotification];
                        if ([string  isEqualToString:@"1"]) {
                            customerObject.strIsSelectedNotification = YES;
                        }
                    }
                    [emailNotificationTableView reloadData];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark-- Update Email Notification API

- (void)updateEmailNotificationSettingsApiData:(NSString *)value withStatus:(NSString *)status
{
    NSString *userIdStr = sharedInstance.userId;
    //    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",@"listEmailNotification",@"NotificationType",nil];
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&eventName=%@&status=%@&UserType=%@",APIUpdateEmailNotificationSettings,userIdStr,value,status,@"1"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                NSArray *arrData = [pushSettingsDictionary objectForKey:@"MasterValues"];
                emailSettingsData = [SingletonClass parseDateForLocation:arrData];
                for (SingletonClass *customerObject in emailSettingsData) {
                    NSString *string = [NSString stringWithFormat:@"%@", customerObject.IsEmailNotification];
                    if( [string isEqualToString:@"1"]) {
                        customerObject.strIsSelectedNotification = YES;
                    }
                }
                [emailNotificationTableView reloadData];
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}
@end
