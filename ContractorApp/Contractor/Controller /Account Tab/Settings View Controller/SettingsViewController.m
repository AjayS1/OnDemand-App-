
//  SettingsViewController.m
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "SettingsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "NotificationOptionViewController.h"
#import "PushNotificationTypeSelectViewController.h"
#import "EmailNotificationTypeSelectViewController.h"
#import "LanguageViewController.h"
#import "UnitsViewController.h"
#import "NotificationTableViewCell.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
#import "BlockViewController.h"

@interface SettingsViewController () {
    
    NSArray *titleArray;
    SingletonClass *sharedInstance;
    NSInteger lastCount;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    
    titleArray = @[@"Notifications",@"Units",@"Language",@"Block List"];
    _settingsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self dateIssueListApiCall];
    
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


- (void)dateIssueListApiCall {
    
    
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
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.nameLbl.text = [titleArray objectAtIndex:indexPath.row];
    lastCount = titleArray.count-1;

    cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == lastCount) {
       // [cell.seperatorLabelValue setHidden:YES];
    }
    else{
       // [cell.seperatorLabelValue setHidden:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        NotificationOptionViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationType"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    } else if (indexPath.row == 1) {
        
        UnitsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"units"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    } else if (indexPath.row == 2) {
        
        LanguageViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"language"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    }
    else if (indexPath.row == 3) {
        
        BlockViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlockViewController"];
        [self.navigationController pushViewController:notiView animated:YES];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
