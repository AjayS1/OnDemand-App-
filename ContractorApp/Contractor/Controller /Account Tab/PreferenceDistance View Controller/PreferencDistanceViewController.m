//
//  PreferencDistanceViewController.m
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "PreferencDistanceViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "NotificationTableViewCell.h"
#import "AppDelegate.h"
@interface PreferencDistanceViewController () {
    
    NSInteger selectedIndex;
    SingletonClass *sharedInstance;
}


@end

@implementation PreferencDistanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
    distanceTableDataArray = [[NSMutableArray alloc]init];
    selectedIndexArr = [[NSMutableArray alloc]init];
    
    distanceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getPreferencesDistanceApiData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
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
    
    return distanceTableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
        NSDictionary *dict;
        if(distanceTableDataArray.count>0)
        {
            dict = [distanceTableDataArray objectAtIndex:indexPath.row];
            cell.nameLbl.text = [dict valueForKey:@"Value"];
            
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
        [imageView setFrame:CGRectMake(0, 0, 15, 15)];
        
        
        if(indexPath.row == selectedIndex)
        {
            cell.accessoryView = imageView;
            cell.selected = YES;
        }
        else
        {
            cell.accessoryView = NULL;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selected = NO;
        }
        NSInteger lastIndexpath = distanceTableDataArray.count-1;
        if (indexPath.row == lastIndexpath) {
            cell.seperatorLabelValue.hidden = true;
        }
        else{
            cell.seperatorLabelValue.hidden = false;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    NSDictionary *dictObj = [distanceTableDataArray objectAtIndex:selectedIndex];
    selectedDistanceId = [dictObj valueForKey:@"ID"];
    
    [distanceTableView reloadData];
}

#pragma mark-- GetPreferencesDistance API Call
-(void)getPreferencesDistanceApiData
{
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"MasterDistances",@"AttributeName",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:APIPrefernceGetDistance withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSDictionary *resultDict = [responseObject valueForKey:@"result"];
                    NSArray *masterValueArr = [resultDict valueForKey:@"MasterValues"];
                    for(NSDictionary *dictObj in masterValueArr)
                    {
                        [distanceTableDataArray addObject:dictObj];
                    }
                    
                    for(NSDictionary *dictt in distanceTableDataArray)
                    {
                        NSString *strr = [dictt valueForKey:@"Value"];
                        
                        [selectedIndexArr addObject:strr];
                        
                        if([selectedIndexArr containsObject:self.selectedIndexxStr])
                        {
                            NSInteger index = [selectedIndexArr indexOfObject:self.selectedIndexxStr];
                            selectedIndex = index;
                        }
                    }
                    
                    [distanceTableView reloadData];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
    
}


#pragma mark-- PreferencesDistance API Call
-(void)updatePreferencesDistanceApiData
{
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIPrefernceChangeProfileData,userIdStr,@"TravelDistancewithPrefences",selectedDistanceId];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [self performSelector:@selector(objectValue) withObject:self afterDelay:1];
                
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
        }
        
    }];
}

-(void)objectValue{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self updatePreferencesDistanceApiData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
