
//  NotificationsViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.



#import "NotificationsViewController.h"
#import "NotificationDetailsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "AppDelegate.h"
#import "NotificationTableViewCell.h"
#import "ChatUserTableViewCell.h"
#import "ServerRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AlertView.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface NotificationsViewController () {
    
    SingletonClass *sharedInstance;
    NSDateFormatter *dateFormatter;
}

@property(nonatomic,strong)NSMutableArray *notificationDataArray;
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sharedInstance = [SingletonClass sharedInstance];
    [self.dontHaveLabel setHidden:YES];
    [self.notificationImageView setHidden:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    dateFormatter = [[NSDateFormatter alloc]init];
    
    sharedInstance.refreshApiCallOrNotStr = @"yes";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiCallRefreshScreen:)
                                                 name:@"apiRefreshCall"
                                               object:nil];
    
    self.navigationController.navigationBar.hidden=YES;
    /// [UITabBarItem.appearance setTitleTextAttributes:
    //  @{NSForegroundColorAttributeName : [UIColor clearColor]}
    //      forState:UIControlStateSelected];
    [self.tabBarController.tabBar setHidden:NO];
    //  [self.tabBarController.tabBar.selectedItem setBadgeColor:[UIColor clearColor]];
    //  [self.tabBarController.tabBar.items objectAtIndex:3].selectedImage  = [UIImage imageNamed:@""] ;
    //  [[APPDELEGATE tabBarC].tabBar setHidden:NO];
    
    [self notificationDetailsApiCall];
}


- (void)apiCallRefreshScreen:(NSNotification*) noti {
    
    [self apiCallRefreshScreen];
    
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
    
    sharedInstance.refreshApiCallOrNotStr = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"apiRefreshCall"
                                                  object:nil];
    
}


- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"2" ,@"userType",nil];
    
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"Unread Tabbar Count List %@",responseObject);
        
        if(!error){
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    
                } else {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                    
                } else {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    
                } else {
                    
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
            else {
                
            }
        }
        else
        {
            
        }
    }];
}

#pragma mark Received Notification List
- (void)notificationDetailsApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",@"2",@"TypeID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIListNotificationDetailByTypeCall withParams:params CallBack:^(id responseObject, NSError *error) {
        
        NSLog(@"Notification List Get %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            [_notificationDataArray removeAllObjects];
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                _notificationDataArray = [[NSMutableArray alloc]init];
                NSDictionary *dataDic = [[responseObject objectForKey:@"result"] mutableCopy];
                _notificationDataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                
                if (_notificationDataArray.count) {
                    
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                    [notificationTableView setHidden:NO];
                }
                
                else {
                    
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [self.notificationImageView setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    

                }
                
                [notificationTableView reloadData];
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    }
                    else {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    } else {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                    }
                }
                
            }
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                
                if (_notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                    [notificationTableView setHidden:NO];

                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [self.notificationImageView setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [notificationTableView reloadData];
                }
            }
            else
            {
                _notificationDataArray = [[NSMutableArray alloc]init];
                if (_notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [notificationTableView setHidden:NO];

                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [self.dontHaveLabel setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [self.notificationImageView setHidden:NO];
                }
                
                [notificationTableView reloadData];
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}

#pragma Mark: Chaneg UTC Time to Local Time
- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //Log: dateString - 2016-03-08 06:00:00 // Time in UTC
    //dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    if (isDayLightSavingTime) {
        //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
        //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    
    return dateRepresentation;
}

-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MM/dd/YYYY hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}


#pragma mark API Call - Refresh Screen when Notification Recevied
- (void)apiCallRefreshScreen {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",@"2",@"TypeID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIListNotificationDetailByTypeCall withParams:params CallBack:^(id responseObject, NSError *error) {
        
        NSLog(@"Notification List Get %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                _notificationDataArray = [[NSMutableArray alloc]init];
                
                NSDictionary *dataDic = [[responseObject objectForKey:@"result"] mutableCopy];
                _notificationDataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                if (_notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                    [notificationTableView setHidden:NO];

                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [self.notificationImageView setHidden:NO];
                    [notificationTableView setHidden:YES];

                }
                [notificationTableView reloadData];
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                        
                    }
                }
                
            }else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                if (_notificationDataArray.count) {
                    
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                    [notificationTableView setHidden:NO];

                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [self.dontHaveLabel setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [self.notificationImageView setHidden:NO];
                }
            }
            else {
                
                _notificationDataArray = [[NSMutableArray alloc]init];
                if (_notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                    [notificationTableView setHidden:NO];

                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [self.dontHaveLabel setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [self.notificationImageView setHidden:NO];
                }
                
                [notificationTableView reloadData];
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  [_notificationDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chat"];
    
    NSMutableDictionary *dataDictionary = [_notificationDataArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = [dataDictionary valueForKey:@"Name"];
    cell.dateLbl.text = [dataDictionary valueForKey:@"Time"];
    NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"Time"]];
    NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
    NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
    NSString *reserveDate = [self convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    if (WIN_WIDTH == 320) {
        [cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
    }
    cell.dateLbl.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    
    //  isRead
    
    NSString *readNotificationStatus = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"isRead"]];
    
    if ([readNotificationStatus isEqualToString:@"1"]) {
        
        cell.notificationLbl.hidden = YES;
        
    } else {
        
        cell.notificationLbl.hidden = NO;
        cell.notificationLbl.layer.cornerRadius=cell.notificationLbl.frame.size.height/2;
        cell.notificationLbl.layer.masksToBounds = YES;
    }
    
    cell.messageLbl.text = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Description"]];
    
    NSURL *imageUrl = [NSURL URLWithString:[dataDictionary valueForKey:@"PicUrl"]];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [cell.userImageView sd_setImageWithURL:imageUrl
    //                          placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dataDictionary = [_notificationDataArray objectAtIndex:indexPath.row];
    NSString *notficationIdStr = [dataDictionary valueForKey:@"ID"];
    
    NotificationDetailsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationsDetails"];
    notiView.self.notificationMessageStr =  [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Description"]];
    
    notiView.self.maxIdStr = notficationIdStr;
    
    [self.navigationController pushViewController:notiView animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this notification?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   
                                                   NSString *userIdStr = sharedInstance.userId;
                                                   NSMutableDictionary *dataDictionary = [_notificationDataArray objectAtIndex:indexPath.row];
                                                   NSString *readNotificationStatus = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"isRead"]];
                                                   NSString *toUserIdStr = [dataDictionary valueForKey:@"ID"];
                                                   NSString *typeIdStr = [dataDictionary valueForKey:@"Type"];
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&TypeID=%@&ID=%@",APIDeleteNotificationApiCall,userIdStr,typeIdStr,toUserIdStr];
                                                   NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   
                                                   [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object delete Notification List %@",encodedUrl);
                                                       [ProgressHUD dismiss];
                                                       if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                                                          // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                                                           
                                                       }
                                                       else{
                                                           if(!error){
                                                               
                                                               NSLog(@"Response is --%@",responseObject);
                                                               if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                                   
                                                                   NSMutableArray *tempArray = [_notificationDataArray mutableCopy];
                                                                   
                                                                   [tempArray removeObjectAtIndex:indexPath.row];
                                                                   _notificationDataArray = [tempArray mutableCopy];
                                                                   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

                                                                   if (_notificationDataArray.count) {
                                                                       [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                                                                       [self.dontHaveLabel setHidden:YES];
                                                                       [self.notificationImageView setHidden:YES];
                                                                       [notificationTableView setHidden:NO];

                                                                       if ([readNotificationStatus isEqualToString:@"0"]) {
                                                                           NSString *notificationCountValueStr = [NSString stringWithFormat:@"%@",[[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue];
                                                                           
                                                                           if ([notificationCountValueStr isEqualToString:@"0"] || [notificationCountValueStr isEqualToString:@"<null>"]|| [notificationCountValueStr isEqualToString:@"(null)"]|| [notificationCountValueStr isEqualToString:@"1"]) {
                                                                               [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                                                                           }
                                                                           else {
                                                                               
                                                                               NSInteger notifiCount = [notificationCountValueStr integerValue];
                                                                               notifiCount = notifiCount-1;
                                                                               [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [NSString stringWithFormat:@"%ld",(long)notifiCount];
                                                                               
                                                                           }
                                                                           
                                                                       }
                                                                       
                                                                   }
                                                                   else{
                                                                       //                   [self.view setBackgroundColor:[UIColor whiteColor]];
                                                                       //                   [self.dontHaveLabel setHidden:NO];
                                                                       //                   [self.notificationImageView setHidden:NO];
                                                                       [notificationTableView setHidden:YES];

                                                                       [self notificationDetailsApiCall];
                                                                       
                                                                   }
                                                                   
                                                                   // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                   
                                                               } else {
                                                                   [self notificationDetailsApiCall];
                                                                   
                                                                   //[CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                               }
                                                           }
                                                       }
                                                   }];                                               }
                                           }];
        
    }
}



@end
