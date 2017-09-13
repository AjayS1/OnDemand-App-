
//  DatesViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DatesViewController.h"
#import "WallTableViewCell.h"
#import "DateDetailsViewController.h"
#import "PastDateDetailsViewController.h"
#import "PaymentDateCompletedViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "AppDelegate.h"
#import "ServerRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "DashboardViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "AccountViewController.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface DatesViewController ()
{
    SingletonClass *sharedInstance;
    NSDictionary *animals;
    NSArray *animalSectionTitles;
    NSArray *animalIndexTitles;
    int checkSegmentIndexValue;
    NSMutableArray *upComingDateArray;
    NSMutableArray *pendingDateArray;
    NSMutableArray *historyDateArray;
    NSMutableArray *inProgressDateArray;
    NSDateFormatter *dateFormatter;
    BOOL IsFromDateDetailsOnDemand;
}

@property (strong, nonatomic) IBOutlet UIImageView *dateImageView;
@property (strong, nonatomic) IBOutlet UILabel *dontHaveMessage;
@property (strong, nonatomic) IBOutlet UIView *datesView;
@property (strong, nonatomic) IBOutlet UIView *datesWithSegmentView;
@property (strong, nonatomic) IBOutlet UIView *currentDatesView;
@property (strong, nonatomic) IBOutlet UIView *historydatesView;
@property (strong, nonatomic) IBOutlet UIButton *currenttButton;
@property (strong, nonatomic) IBOutlet UIButton *historyButton;
@property (strong, nonatomic) IBOutlet UIView *currentDatesVAlueView;
@property (strong, nonatomic) IBOutlet UIView *datesVAlueView;

@end

@implementation DatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self.datesWithSegmentView setHidden:YES];
    [_datesView setHidden:NO];
    
    [self.segmentButton setHidden:YES];
    self.segmentButton.layer.borderColor = [UIColor colorWithRed:149.0/255.0 green:82.0/255.0 blue:158.0/255.0 alpha:1.0].CGColor;
    self.segmentButton.layer.masksToBounds = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    datesTable.estimatedRowHeight = 110;
    datesTable.rowHeight = UITableViewAutomaticDimension;
    [self.datesWithSegmentView setHidden:YES];
    [_datesView setHidden:NO];
    _currentDatesView.layer.borderColor = [UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1].CGColor;
    _currentDatesView.layer.borderWidth = 1.1;
    _currentDatesView.layer.cornerRadius = 4.0;
    self.automaticallyAdjustsScrollViewInsets = false;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    if (_isFromDateDetails) {
        NSLog(@"Selected Index %lu",self.tabBarController.selectedIndex);
        switch (self.tabBarController.selectedIndex) {
            case 0:
            {
                DashboardViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
                sharedInstance.IsFromDateDetailsOnDemand = NO;
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:notiView animated:NO];
                return;
            }
                break;
            case 1:
            {
                DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                sharedInstance.IsFromDateDetailsOnDemand = NO;
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:datesView animated:NO];
                return;
            }
                break;
            case 2:
            {
                MessagesViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"messages"];
                sharedInstance.IsFromDateDetailsOnDemand = NO;
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:notiView animated:NO];
                return;
            }
                break;
            case 3:
            {
                NotificationsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notifications"];
                sharedInstance.IsFromDateDetailsOnDemand = NO;
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:notiView animated:NO];
                return;
            }
                break;
            case 4:
            {
                AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                sharedInstance.IsFromDateDetailsOnDemand = NO;
                _isFromDateDetails = NO;
                accountView.isFromUpdateMobileNumber = NO;
                accountView.isFromOrderProcess = NO;
                accountView.isFromCreditCardProcess = NO;
                accountView.isEmailVerifiedOrNotPage = NO;
                [self.navigationController pushViewController:accountView animated:NO];
                return;
            }
                break;
            default:
                break;
        }
    }
    
    dateFormatter = [[NSDateFormatter alloc]init];
    //    checkSegmentIndexValue = 0;
    //    [_segmentButton setSelectedSegmentIndex:checkSegmentIndexValue];
    datesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sharedInstance.refreshApiCallOrNotStr = @"yes";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiCallRefreshScreen:)
                                                 name:@"apiRefreshCall"
                                               object:nil];
    
    
    [self.segmentButton setHidden:YES];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self getAllDateAPiCall];
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashBoardScreenView = [storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
    dashBoardScreenView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    dashBoardScreenView.title = @"Dashboard";
    dashBoardScreenView.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    dashBoardScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"dashboard_hover"];
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.isFromDateDetails = NO;
    
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    //datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    // messageView.tabBarItem.badgeValue = messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    //   notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    // accountView.view.backgroundColor = [UIColor whiteColor];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:dashBoardScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    [APPDELEGATE tabBarC].selectedItemTitleColor = [UIColor purpleColor];
    [APPDELEGATE tabBarC].viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    
    // self.window.rootViewController = tabBarC;
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:YES];
}
- (void)tabBarControllerClassForDateDetails {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashBoardScreenView = [storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
    dashBoardScreenView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    dashBoardScreenView.title = @"Dashboard";
    dashBoardScreenView.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    dashBoardScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"dashboard_hover"];
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.isFromDateDetails = NO;
    
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    //datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    // messageView.tabBarItem.badgeValue = messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    //   notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    // accountView.view.backgroundColor = [UIColor whiteColor];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:dashBoardScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    [APPDELEGATE tabBarC].selectedItemTitleColor = [UIColor purpleColor];
    [APPDELEGATE tabBarC].viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
}


- (void)apiCallRefreshScreen:(NSNotification*) noti {
    [self getAllDateAPiCall];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    sharedInstance.refreshApiCallOrNotStr = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"apiRefreshCall"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}


- (void)checkSignalRReqest:(NSNotification*) noti {
    
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"])
    {
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        [self.navigationController pushViewController:dateDetailsView animated:YES];
    }
    else {
        [self tabBarCountApiCall];
    }
}



- (void)tabBarCountApiCall {
    
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self.segmentButton setHidden:YES];
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"2" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                    [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    
                }
                else {
                    [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                    
                }
                else {
                    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    
                }
                else {
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
            else{
            }
        }
        else
        {
        }
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (checkSegmentIndexValue == 0) {
        
        //        NSString *sectionTitle = [animalSectionTitles objectAtIndex:section] ;
        //        NSArray *sectionData = [animals objectForKey:sectionTitle];
        if ([pendingDateArray count])
            return [pendingDateArray count];
        else
            return 1;
    }
    else {
        if (historyDateArray.count)
            return historyDateArray.count;
        else
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //Creating View
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    //Creating Label
    UILabel *lbl;
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width/2, 30)];
    if (checkSegmentIndexValue == 0) {
        //        switch (section) {
        //            case 0:{
        //                [lbl setText:@"IN PROGRESS"];
        //            }
        //                break;
        //            case 1:{
        //                [lbl setText:@"PENDING"];
        //            }
        //                break;
        //            case 2:{
        //                [lbl setText:@"UPCOMING"];
        //            }
        //                break;
        //            default:
        //                break;
        //        }
        [lbl setText:[animalSectionTitles objectAtIndex:section]];
    }
    
    else{
        [lbl setText:@"PAST DATES"];
    }
    lbl.font = [UIFont systemFontOfSize:14];
    [lbl setTextColor: [UIColor darkGrayColor]];
    [headerView addSubview:lbl];
    //Creating Label
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (checkSegmentIndexValue == 0) {
        
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (checkSegmentIndexValue == 0) {
        //NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section] ;
        //         switch (indexPath.section) {
        //             case 0:{
        //                 sectionTitle = @"IN PROGRESS";
        //             }
        //                 break;
        //             case 1:{
        //                 sectionTitle = @"PENDING";
        //             }
        //                 break;
        //             case 2:{
        //                 sectionTitle = @"UPCOMING";
        //             }
        //                 break;
        //             default:
        //                 break;
        //         }
        //NSArray *sectionData = [animals objectForKey:sectionTitle];
        if (pendingDateArray.count) {
            
            [self.dateImageView setHidden:YES];
            [self.dontHaveMessage setHidden:YES];
            [datesTable setHidden:NO];
            [_datesView setHidden:YES];
            
            [self.datesWithSegmentView setHidden:NO];
            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            return UITableViewAutomaticDimension;
        }
        else{
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any current dates.";
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [_datesView setHidden:YES];
            [self.datesWithSegmentView setHidden:NO];
            return 0.0;
            
        }
        
    }
    else {
        if (historyDateArray.count){
            
            [self.dateImageView setHidden:YES];
            [self.dontHaveMessage setHidden:YES];
            [datesTable setHidden:NO];
            [_datesView setHidden:YES];
            [self.datesWithSegmentView setHidden:NO];
            [self.view setBackgroundColor:[UIColor whiteColor]];
            return UITableViewAutomaticDimension;
        }
        else
        {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [_datesView setHidden:YES];
            self.dontHaveMessage.text = @"You don't have any history.";
            [self.datesWithSegmentView setHidden:NO];
            return 0.0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WallTableViewCell *cell;
    
    if (cell == nil) {
        cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall"];
    }
    if (checkSegmentIndexValue == 0) {
        cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall"];
        //datesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
    {
        cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall"];
        //datesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    NSLog(@"Width of cell %f",cell.addressLbl.frame.size.width);
    NSLog(@"Height of cell %f",cell.addressLbl.frame.size.height);
    double cellAddressLabelWidth = cell.addressLbl.frame.size.width;
    double celldateLabelWidth = cell.dateLbl.frame.size.width;
    
    if (WIN_WIDTH == 320) {
        [ cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
        [ cell.addressLbl setFont:[UIFont systemFontOfSize:10]];
        //        if (checkSegmentIndexValue == 0) {
        //            [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth-8, cell.addressLbl.frame.size.height)];
        //            [cell.datesImageView setFrame:CGRectMake(cell.nameLbl.frame.origin.x, cell.dateLbl.frame.origin.y+3, 13, 13)];
        //            [cell.dateLbl setFrame:CGRectMake(cell.datesImageView.frame.origin.x+cell.datesImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, 270, cell.dateLbl.frame.size.height)];
        //
        //
        //
        //
        //        }
        //        else
        //        {
        //            [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+45, cell.addressLbl.frame.size.height)];
        //            [cell.datesImageView setFrame:CGRectMake(cell.nameLbl.frame.origin.x, cell.dateLbl.frame.origin.y+3, 13, 13)];
        //            [cell.dateLbl setFrame:CGRectMake(cell.datesImageView.frame.origin.x+cell.datesImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, celldateLabelWidth+25, cell.dateLbl.frame.size.height)];
        //            [ cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
        //            [ cell.addressLbl setFont:[UIFont systemFontOfSize:10]];
        //
        //        }
    }
    else{
        //        [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+65, cell.addressLbl.frame.size.height)];
        //        [cell.datesImageView setFrame:CGRectMake(cell.nameLbl.frame.origin.x, cell.dateLbl.frame.origin.y+3, 13, 13)];
        //        [cell.dateLbl setFrame:CGRectMake(cell.datesImageView.frame.origin.x+cell.datesImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, cell.dateLbl.frame.size.width+5, cell.dateLbl.frame.size.height)];
        [ cell.dateLbl setFont:[UIFont systemFontOfSize:12]];
        [ cell.addressLbl setFont:[UIFont systemFontOfSize:12]];
        
    }
    
    
    [cell.dontHaveMessageLbl setHidden:YES];
    cell.notificationCountLbl.hidden = NO;
    cell.statusAcceptedLbl.hidden = NO;
    //[cell.dontHaveMessageLbl setHidden:NO];
    [cell.nameLbl setHidden:NO];
    [cell.userImageView setHidden:NO];
    [cell.dateLbl setHidden:NO];
    [cell.statusAcceptedLbl setHidden:NO];
    [cell.addressLbl setHidden:NO];
    [cell.dateTimeLbl setHidden:YES];
    [cell.notificationCountLbl setBackgroundColor:[UIColor redColor]];
    
    NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section] ;
    NSArray *sectionData = [animals objectForKey:sectionTitle];
    
    if (checkSegmentIndexValue == 0) {
        [cell.notificationCountLbl setBackgroundColor:[UIColor redColor]];
        [cell.cancelFeeLbl setHidden:YES];
        // [cell.cancelMessageLbl setHidden:YES];
        cell.notificationCountLbl.hidden = YES;
        if (indexPath.section == 0) {
            cell.statusAcceptedLbl.hidden = YES;
        }
        else {
        }
        if (pendingDateArray.count) {
            
            //cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
            //datesTable.separatorStyle = UITableViewCellSelectionStyleGray;
            
            if (pendingDateArray.count == 1)
                [cell.seperatorLbl setHidden:NO];
            else
                [cell.seperatorLbl setHidden:NO];
            
            cell.notificationCountLbl.hidden = NO;
            NSString *readNotificationStatus = [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"isContractorRead"]];
            [cell.cancelFeeLbl setHidden:NO];
            [cell.cancelMessageLbl setHidden:YES];
            cell.notificationCountLbl.hidden = NO;
            cell.statusAcceptedLbl.hidden = NO;
            
            if ( [readNotificationStatus isEqualToString:@"0"])
            {
                cell.notificationCountLbl.hidden = NO;
                cell.notificationCountLbl.layer.cornerRadius=cell.notificationCountLbl.frame.size.height/2;
                cell.notificationCountLbl.layer.masksToBounds = YES;
            }
            else
            {
                cell.notificationCountLbl.hidden = YES;
            }
            
            NSString *dateStatusTypeValue =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateStatusType"]];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            
            if ([dateValueType isEqualToString:@"1"]) {
                [cell.datesImageView setImage:[UIImage imageNamed:@"lightning"]];
            }
            else
            {
                [cell.datesImageView setImage:[UIImage imageNamed:@"calendar_Other"]];
            }
            if ([dateStatusTypeValue isEqualToString:@"Pending"]) {
                cell.cancelFeeLbl.textColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:30.0/255.0 alpha:1.0];
            }
            else{
                cell.cancelFeeLbl.textColor = [UIColor colorWithRed:20.0/255.0 green:147.0/255.0 blue:69.0/255.0 alpha:1.0];
            }
            cell.nameLbl.text = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            cell.addressLbl.text = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"Location"];
            [cell.cancelFeeLbl setText:dateStatusTypeValue];
            //cell.backgroundColor = [UIColor redColor];
            // cell.dateLbl.text = [[sectionData objectAtIndex:indexPath.row] objectForKey:@"RequestTime"];
            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"ReserveTime"]];
            NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            cell.dateLbl.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
            NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestTime"]];
            NSArray *nameRequestStr = [requestTimeStr componentsSeparatedByString:@"."];
            NSString *fileKeyRequest = [NSString stringWithFormat:@"%@",[nameRequestStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            NSString *requestDate = [self convertUTCTimeToLocalTime:fileKeyRequest WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            [cell.dateTimeLbl setText:[self setDateStatusWithDate:requestDate]];
            NSString *readNotificationStatus1 = [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"isContractorRead"]];
            
            if ( [readNotificationStatus1 isEqualToString:@"0"])
            {
                cell.notificationCountLbl.hidden = NO;
                cell.notificationCountLbl.layer.cornerRadius=cell.notificationCountLbl.frame.size.height/2;
                cell.notificationCountLbl.layer.masksToBounds = YES;
            }
            else
            {
                cell.notificationCountLbl.hidden = YES;
            }
            
            NSString *imageurlStr = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"];
            NSURL *imageUrl = [NSURL URLWithString:imageurlStr];
            [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            return cell;
        }
        else
        {
            [cell.seperatorLbl setHidden:YES];
            [cell.dontHaveMessageLbl setHidden:NO];
            [cell.nameLbl setHidden:YES];
            [cell.notificationCountLbl setHidden:YES];
            [cell.userImageView setHidden:YES];
            [cell.dateLbl setHidden:YES];
            [cell.statusAcceptedLbl setHidden:YES ];
            [cell.addressLbl setHidden:YES];
            [cell.dateTimeLbl setHidden:YES];
            //cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            // datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            //            if ([sectionTitle isEqualToString:@"PENDING"]) {
            //                [cell.dontHaveMessageLbl setText:@"No pending dates."];
            //            }
            //            else if ([sectionTitle isEqualToString:@"UPCOMING"]){
            //                [cell.dontHaveMessageLbl setText:@"No upcoming dates."];
            //
            //            }
            //            else if ([sectionTitle isEqualToString:@"IN PROGRESS"]){
            //                [cell.dontHaveMessageLbl setText:@"No in progress dates."];
            //            }
        }
    }
    else
    {
        if (historyDateArray.count) {
            
            // datesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            // cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.cancelFeeLbl.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
            
            if (historyDateArray.count ==1)
                [cell.seperatorLbl setHidden:YES];
            else
                [cell.seperatorLbl setHidden:NO];
            
            [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth, cell.addressLbl.frame.size.height)];
            [cell.dateTimeLbl setHidden:YES];
            
            [cell.cancelFeeLbl setHidden:NO];
            [cell.cancelMessageLbl setHidden:NO];
            cell.notificationCountLbl.hidden = YES;
            cell.statusAcceptedLbl.hidden = YES;
            [cell.dontHaveMessageLbl setHidden:YES];
            
            cell.nameLbl.text = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            cell.addressLbl.text = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Location"];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            NSString *dateType =   [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            if ([dateType isEqualToString:@"6"]  || [dateType isEqualToString:@"10"] || [dateType isEqualToString:@"19"] || [dateType isEqualToString:@"20"]) {
                if ([dateValueType isEqualToString:@"1"]) {
                    [cell.datesImageView setImage:[UIImage imageNamed:@"lightning"]];
                }
                else
                {
                    [cell.datesImageView setImage:[UIImage imageNamed:@"calendar_Other"]];
                }
            }
            else
            {
                [cell.datesImageView setImage:[UIImage imageNamed:@"clock"]];
            }
            
            
            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"ReserveTime"]];
            
            NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            
            NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            NSString *requestTimeStr = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestTime"];
            
            NSArray *nameRequestStr = [requestTimeStr componentsSeparatedByString:@"."];
            
            NSString *fileKeyArray = [NSString stringWithFormat:@"%@",[nameRequestStr objectAtIndex:0]];
            NSLog(@"%@",fileKeyArray);
            
            NSString *readNotificationStatus = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"isContractorRead"]];
            
            if ( [readNotificationStatus isEqualToString:@"0"]) {
                cell.notificationCountLbl.hidden = YES;
                cell.notificationCountLbl.layer.cornerRadius=cell.notificationCountLbl.frame.size.height/2;
                cell.notificationCountLbl.layer.masksToBounds = YES;
            }
            else {
                cell.notificationCountLbl.hidden = YES;
            }
            
            NSString *requestDate = [self convertUTCTimeToLocalTime:fileKeyArray WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            [cell.dateTimeLbl setText:[self setDateStatusWithDate:requestDate]];
            cell.dateLbl.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *imageurlStr = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"];
            NSURL *imageUrl = [NSURL URLWithString:imageurlStr];
            [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            //Manging the status of the date
            NSInteger dateStatusType = [[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"] integerValue];
            
            switch (dateStatusType) {
                case 6:
                {
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 9:
                {
                    [cell.cancelFeeLbl setText:@"Processing..."];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 10:
                {
                    //                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]];
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 11:
                {
                    
                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                case 17:
                {
                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                    
                case 12:
                {
                    [cell.cancelFeeLbl setText:@"Processing..."];
                    [cell.cancelMessageLbl setHidden:YES];
                }
                    break;
                    
                case 19:
                {
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    //                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"-%@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 20:
                {
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                default:
                    break;
            }
        }
        
        else
        {
            //cell.selectionStyle = UITableViewCellSelectionStyleNone;
            // datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [cell.cancelFeeLbl setHidden:YES];
            [cell.seperatorLbl setHidden:YES];
            [cell.cancelMessageLbl setHidden:YES];
            cell.notificationCountLbl.hidden = YES;
            cell.statusAcceptedLbl.hidden = YES;
            [cell.dontHaveMessageLbl setHidden:NO];
            [cell.nameLbl setHidden:YES];
            [cell.userImageView setHidden:YES];
            [cell.dateLbl setHidden:YES];
            [cell.statusAcceptedLbl setHidden:YES];
            [cell.addressLbl setHidden:YES];
            [cell.dateTimeLbl setHidden:YES];
            
            [cell.dontHaveMessageLbl setText:@"No past dates."];
        }
    }
    return cell;
    
}


#pragma mark: Change Date in Particular Formate
-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMMM d, YYYY @ hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}

#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    //formate = @"yyyy-MM-dd'T'HH:mm:ss"
    [dateFormatter setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    if (isDayLightSavingTime)
    {
        // NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
        //  dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}


-(NSString *)setDateStatusWithDate:(NSString *)date
{
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *dateFormatter3= [[NSDateFormatter alloc] init];
    [dateFormatter3 setDateFormat:@"MM/dd/yyyy"];
    
    NSDateFormatter *dateFormatter4= [[NSDateFormatter alloc] init];
    [dateFormatter4 setDateFormat:@"EEEE"];
    
    NSDate *dateConverted = [dateFormatter2 dateFromString:date];
    NSDateFormatter *dateFormatter5= [[NSDateFormatter alloc] init];
    [dateFormatter5 setDateFormat:@"hh:mm aaa"];
    
    NSInteger dayDiff = (int)[dateConverted timeIntervalSinceNow] / (60*60*24);
    NSDateComponents *componentsToday = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateConverted];
    NSInteger day = [componentsToday day] - [componentsDate day];
    NSString *dateStatus;
    NSLog(@"Day %ld",(long)day);
    
    if (dayDiff == 0) {
        NSLog(@"Today");
        dateStatus = [dateFormatter5 stringFromDate:dateConverted];
    }
    else if (dayDiff == -1) {
        NSLog(@"Yesterday");
        dateStatus = @"Yesterday";
    }
    else if(dayDiff > -7 && dayDiff < -1) {
        NSLog(@"This week");
        dateStatus = [dateFormatter4 stringFromDate:dateConverted];
    }
    else if(dayDiff > -14 && dayDiff <= -7) {
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
        NSLog(@"Last week");
    }
    else if(dayDiff >= -60 && dayDiff <= -30) {
        NSLog(@"Last month");
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
    }
    else {
        dateStatus = [dateFormatter3 stringFromDate:dateConverted];
        NSLog(@"A long time ago");
    }
    return dateStatus;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (checkSegmentIndexValue == 0) {
        if (pendingDateArray.count)
        {
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            
            sharedInstance.requestTypeStr = dateValueType;
            NSString *dateStatusType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            
            if ([dateStatusType isEqualToString:@"9"]|| [dateStatusType isEqualToString:@"12"]|| [dateStatusType isEqualToString:@"10"]|| [dateStatusType isEqualToString:@"13"]){
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Your date is being processed. Please check again later." inController:self];
            }
            
            else if ([dateStatusType isEqualToString:@"11"])
            {
                
                PastDateDetailsViewController *pastDateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"pastDateDetail"];
                pastDateDetailsView.self.dateRequestedType = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
                pastDateDetailsView.self.dateIdStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
                pastDateDetailsView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
                [self.navigationController pushViewController:pastDateDetailsView animated:YES];
            }
            else
            {
                DateDetailsViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateDetail"];
                dateDetailsView.self.dateIdStr =  [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
                //dateDetailsView.self.dateIdStr =  @"Date4";
                dateDetailsView.isFromOnDemandRequest = FALSE;
                dateDetailsView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
                dateDetailsView.self.dateRequestTypeStr = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"];
                [self.navigationController pushViewController:dateDetailsView animated:YES];
            }
        }
    }
    else {
        
        if (historyDateArray.count) {
            
            NSString *dateStatusType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            sharedInstance.requestTypeStr = dateValueType;
            
            if ( [dateStatusType isEqualToString:@"12"] || [dateStatusType isEqualToString:@"9"] )
            {
                [CommonUtils showAlertWithTitle:@"" withMsg:@"Your date is being processed. Please check again later." inController:self];
            }
            
            else
            {
                PastDateDetailsViewController *pastDateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"pastDateDetail"];
                pastDateDetailsView.self.dateIdStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
                pastDateDetailsView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
                pastDateDetailsView.self.userNameStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
                pastDateDetailsView.self.picUrlStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"];
                [self.navigationController pushViewController:pastDateDetailsView animated:YES];
            }
        }
    }
}

#pragma mark Segment Control Action Call
- (IBAction)segmentAction:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:
            checkSegmentIndexValue = 0;
            [datesTable reloadData];
            break;
        case 1:
        {
            checkSegmentIndexValue = 1;
            [datesTable reloadData];
        }
            break;
        case 2:
        default:
            break;
    }
}

-(IBAction)commonButtonAction:(UIButton *)sender{
    switch (sender.tag) {
            //CurrentTab
        case 564:
        {
            checkSegmentIndexValue = 0;
            [_currenttButton setTitleColor:[UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_historyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _currentDatesVAlueView.backgroundColor = [UIColor whiteColor];
            _historydatesView.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1];
            [_currentDatesView setBackgroundColor:[UIColor whiteColor]];
            [datesTable reloadData];
        }
            break;
            //HistoryTab
        case 565:
        {
            checkSegmentIndexValue = 1;
            [_historyButton setTitleColor:[UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_currenttButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _currentDatesVAlueView.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1];
            _historydatesView.backgroundColor = [UIColor whiteColor];
            [_currentDatesView setBackgroundColor:[UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1]];
            [datesTable reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get Date List API Call

- (void)getAllDateAPiCall {
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIDateList,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkGetRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if (([responseObject isKindOfClass:[NSNull class]])) {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [datesTable setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any dates.";
            [self.segmentButton setHidden:YES];
        }
        else if(!error)
        {
            [self.segmentButton setHidden:NO];
            [datesTable setHidden:NO];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] == 1) {
                
                upComingDateArray = [[NSMutableArray alloc]init];
                pendingDateArray = [[NSMutableArray alloc]init];
                historyDateArray = [[NSMutableArray alloc]init];
                inProgressDateArray = [[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"UserDList"] isKindOfClass:[NSArray class]]) {
                    pendingDateArray = [[responseObject objectForKey:@"result"]objectForKey:@"UserDList"];
                }
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"] isKindOfClass:[NSArray class]]) {
                    historyDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"];
                }
                
                if ( (!(pendingDateArray.count)) &&(!(historyDateArray.count)))
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:NO];
                    [self.dontHaveMessage setHidden:NO];
                    self.dontHaveMessage.text = @"You don't have any dates.";
                    
                    [datesTable setHidden:YES];
                    [self.segmentButton setHidden:YES];
                    [_datesView setHidden:NO];
                    [self.datesWithSegmentView setHidden:YES];
                }
                else
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:YES];
                    [self.dontHaveMessage setHidden:YES];
                    [datesTable setHidden:NO];
                    self.dontHaveMessage.text = @"You don't have any dates.";
                    
                    [self.segmentButton setHidden:NO];
                    [_datesView setHidden:YES];
                    [self.datesWithSegmentView setHidden:NO];
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [datesTable reloadData];
                }
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]])
                {
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    }
                    else
                    {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    }
                    else
                    {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"])
                    {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    }
                    else
                    {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                    }
                }
                
            }
            else {
                
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dateImageView setHidden:NO];
                [self.dontHaveMessage setHidden:NO];
                self.dontHaveMessage.text = @"You don't have any dates.";
                
                [datesTable setHidden:YES];
                [self.segmentButton setHidden:YES];
                [_datesView setHidden:NO];
                [self.datesWithSegmentView setHidden:YES];
            }
        }
        
        else
        {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            self.dontHaveMessage.text = @"You don't have any dates.";
            
            [self.segmentButton setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
        }
    }];
}

#pragma mark Refresh Screen when notification received

- (void)apiCallRefreshScreen {
    
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIDateList,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkGetRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if (([responseObject isKindOfClass:[NSNull class]])) {
            
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [datesTable setHidden:YES];
            [_datesView setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any dates.";
            
            [self.datesWithSegmentView setHidden:YES];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            [self.segmentButton setHidden:YES];
        }
        else if(!error)
        {
            [self.segmentButton setHidden:NO];
            [datesTable setHidden:NO];
            [_datesView setHidden:YES];
            [self.datesWithSegmentView setHidden:NO];
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] == 1) {
                
                upComingDateArray = [[NSMutableArray alloc]init];
                pendingDateArray = [[NSMutableArray alloc]init];
                historyDateArray = [[NSMutableArray alloc]init];
                inProgressDateArray = [[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"PendingDate"] isKindOfClass:[NSArray class]]) {
                    pendingDateArray = [[responseObject objectForKey:@"result"]objectForKey:@"UserDList"];
                }
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"] isKindOfClass:[NSArray class]]) {
                    historyDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"];
                }
                
                if ( (!(pendingDateArray.count)) &&(!(historyDateArray.count)))
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:NO];
                    [self.dontHaveMessage setHidden:NO];
                    [datesTable setHidden:YES];
                    self.dontHaveMessage.text = @"You don't have any dates.";
                    
                    [self.segmentButton setHidden:YES];
                    [_datesView setHidden:NO];
                    [self.datesWithSegmentView setHidden:YES];
                }
                else
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:YES];
                    [self.dontHaveMessage setHidden:YES];
                    [datesTable setHidden:NO];
                    self.dontHaveMessage.text = @"You don't have any dates.";
                    
                    [self.segmentButton setHidden:NO];
                    [_datesView setHidden:YES];
                    [self.datesWithSegmentView setHidden:NO];
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [datesTable reloadData];
                }
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    }
                    else
                    {
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    }
                    else {
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    }
                    else {
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                    }
                }
            }
            else {
                
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dateImageView setHidden:NO];
                [self.dontHaveMessage setHidden:NO];
                [datesTable setHidden:YES];
                self.dontHaveMessage.text = @"You don't have any dates.";
                [self.segmentButton setHidden:YES];
                [_datesView setHidden:NO];
                [self.datesWithSegmentView setHidden:YES];
            }
        }
        
        else
        {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any dates.";
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [self.segmentButton setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
        }
    }];
}


@end
