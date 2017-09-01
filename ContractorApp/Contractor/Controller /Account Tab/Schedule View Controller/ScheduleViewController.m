
//  ScheduleViewController.m
//  Contractor
//  Created by Jamshed Ali on 27/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ScheduleViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "Define.h"
#import "ScheduleSessionViewController.h"
#import "AppDelegate.h"

@interface ScheduleViewController () {
    
    SingletonClass *sharedInstance;
    NSInteger lastCount;
    
}

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scheduleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [sceduleTableDataArray removeAllObjects];
    sceduleTableDataArray = [[NSMutableArray alloc]init];
    [self fetchContarctorScheduleAllDayApi];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return sceduleTableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationTableViewCell *cell;
    cell = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    if (cell == nil) {
        
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
        [imageView setFrame:CGRectMake(0, 0, 15, 15)];
        if(sceduleTableDataArray.count>0)
        {
            NSDictionary *dictionaryData = [sceduleTableDataArray objectAtIndex:indexPath.row];
            NSString *dayStr;
            NSString *dayIdStr = [dictionaryData valueForKey:@"DayID"];
            if([dayIdStr isEqualToString:@"1"])
            {
                dayStr = @"Monday";
            }
            else if ([dayIdStr isEqualToString:@"2"])
            {
                dayStr = @"Tuesday";
            }
            else if ([dayIdStr isEqualToString:@"3"])
            {
                dayStr = @"Wednesday";
            }
            else if ([dayIdStr isEqualToString:@"4"])
            {
                dayStr = @"Thursday";
            }
            else if ([dayIdStr isEqualToString:@"5"])
            {
                dayStr = @"Friday";
            }
            else if ([dayIdStr isEqualToString:@"6"])
            {
                dayStr = @"Saturday";
            }
            else if ([dayIdStr isEqualToString:@"7"])
            {
                dayStr = @"Sunday";
            }
            cell.nameLbl.text = dayStr;
            NSString *isWorkingDayStr = [dictionaryData valueForKey:@"isWorkingDay"];
            
            if([isWorkingDayStr isEqualToString:@"True"])
            {
                
                cell.accessoryView = imageView;
            }
            else
            {
                cell.accessoryView = NULL;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            lastCount = sceduleTableDataArray.count-1;
            if (lastCount == indexPath.row) {
                //cell.seperatorLabelValue.hidden = true;
            }
            else{
               // cell.seperatorLabelValue.hidden = false;
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScheduleSessionViewController *accountInfoView = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleSession"];
    NSDictionary *dictObj = [sceduleTableDataArray objectAtIndex:indexPath.row];
    accountInfoView.scheduleSessionDict = dictObj;
    [self.navigationController pushViewController:accountInfoView animated:YES];
    
}

-(void)fetchContarctorScheduleAllDayApi{
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrl:APIContarctorSchedulingallDay withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSArray *scheduleArray = [responseObject objectForKey:@"ContractorScheduling"];
                    for(NSDictionary *dict in scheduleArray)
                    {
                        [sceduleTableDataArray addObject:dict];
                        [scheduleTableView reloadData];
                    }
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            else
            {
                NSLog(@"Error is found");
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
