
//  DateCancelViewController.m
//  Contractor
//  Created by Jamshed Ali on 17/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DateCancelViewController.h"
#import "DatesViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "DateReportSubmitViewController.h"
#import "AlertView.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
#import "DashboardViewController.h"
#import "AccountViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "CreditCardDeclinedVC.h"

@interface DateCancelViewController () {
    
    NSArray *dateIssueArray;
    NSString *reasonIdStr;
    SingletonClass *sharedInstance;
    NSMutableArray *cancelDataArray;
    BOOL checkTab;
    BOOL checkTabSecond;
    NSString *bankDetailsURL;
}

@property(strong, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation DateCancelViewController
@synthesize dateIdStr,dateDiclineOrDateCancelStr,titleStr;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    titleLabel.text = titleStr;
    reasonIdStr = @"";
 
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    sharedInstance = [SingletonClass sharedInstance];
    cancelDataArray = [[NSMutableArray alloc]init];
    [_settingsTableView.tableFooterView setHidden:YES];
    if (checkTab) {
        
        DashboardViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
        checkTab = NO;
        [self.navigationController pushViewController:notiView animated:YES];
        return;
    }
    
    if (checkTabSecond) {
        
        for ( UINavigationController *controller in self.tabBarController.viewControllers ) {
            if ( [[controller.childViewControllers objectAtIndex:0] isKindOfClass:[DatesViewController class]]) {
                self.tabBarController.selectedIndex = 1;
                checkTab = YES;
                [self.tabBarController setSelectedViewController:controller];
                //  [self tabBarControllerClass];
                break;
            }
        }
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [self getDateIssueListApiCall];

}

- (void)checkSignalRReqest:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdString = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdString,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        [self.navigationController pushViewController:dateDetailsView animated:YES];
    }
    else {
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

- (void)getDateIssueListApiCall {
    
    NSMutableDictionary *params;
    
    if ([self.buttonSattus isEqualToString:@"1"] || [self.dateTypeStr isEqualToString:@"3"]) {
        // params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateContractorAfterDateAccept",@"AttributeName",nil];
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateContractorAfterDateOntheWay",@"AttributeName",nil];
    }
    
    else if ([self.buttonSattus isEqualToString:@"2"]|| [self.dateTypeStr isEqualToString:@"16"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateContractorAfterDateOntheWay",@"AttributeName",nil];
    }
    
    else if ([self.buttonSattus isEqualToString:@"3"]|| [self.dateTypeStr isEqualToString:@"7"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateContractorAfterDateArrived",@"AttributeName",nil];
    }
    
    else if ([self.buttonSattus isEqualToString:@"4"]|| [self.dateTypeStr isEqualToString:@"8"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateContractorAfterDateStart",@"AttributeName",nil];
    }
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIDateIssueList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    dateIssueArray = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                    cancelDataArray = [SingletonClass parseCancelDateDetails:[[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"]];
                    if (cancelDataArray.count) {
                        [_submitButton setEnabled:YES];
                        [_settingsTableView.tableFooterView setHidden:NO];

                    }
                    else {
                        [_submitButton setEnabled:NO];
                        [_settingsTableView.tableFooterView setHidden:YES];

                    }
                    [_settingsTableView reloadData];
                }
                else{
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (cancelDataArray.count) {
        return cancelDataArray.count;
    }
    else
    {
        return dateIssueArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    [cell setFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    //  [cell.nameLbl setFrame:CGRectMake(cell.imageView.frame.origin.x+cell.imageView.frame.size.width+10, 0,cell.contentView.frame.size.width- (cell.imageView.frame.origin.x+cell.imageView.frame.size.width)*2, 50)];
    //  cell.nameLbl.text = [[dateIssueArray objectAtIndex:indexPath.row] objectForKey:@"Value"];
    cell.imageView.image = NULL;
    [cell.nameLbl setHidden:YES];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    UIImageView *imageViewOther = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"]];
    [imageViewOther setFrame:CGRectMake(0, 0, 15, 15)];
    if (cancelDataArray.count) {
        SingletonClass *customeObj = [cancelDataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = customeObj.cancelDatevalue;
        if (customeObj.isDateCancel) {
            cell.imageView.image = imageView.image;
            customeObj.isDateCancel = NO;
        }
        else{
            cell.imageView.image = imageViewOther.image;
        }
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.textLabel sizeToFit];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (cancelDataArray.count) {
        SingletonClass *customeObj = [cancelDataArray objectAtIndex:indexPath.row];
        if (!customeObj.isDateCancel) {
            customeObj.isDateCancel = YES;
            reasonIdStr = customeObj.cancelDateID;
        }
        else
        {
            customeObj.isDateCancel = NO;
            reasonIdStr = @"";
        }
    }
    
    [_settingsTableView reloadData];
    // reasonIdStr  = [NSString stringWithFormat:@"%@",[[dateIssueArray objectAtIndex:indexPath.row] objectForKey:@"ID"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    if (sharedInstance.isFromCancelDateRequest)
    {
        [self tabBarControllerClass];
        sharedInstance.isFromCancelDateRequest = NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)dateCancelButtonClicked:(id)sender {
    
    if ([reasonIdStr isEqualToString:@"56"]) {
        sharedInstance.IsCancellationFeeAllowed = @"1";
    
        [self callSubmitMethodeForCancelDate];
    }
    else{
        [self callAPiForCancel];
    }
    
}

-(void)callSubmitMethodeForCancelDate
{
    if (cancelDataArray.count) {
        if ([reasonIdStr isEqualToString:@""]) {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select the issue." inController:self];
        }
        
        else {
            
            
            NSString *userIdStr = sharedInstance.userId;
            NSString *urlStr;
            //http://ondemandapinew.flexsin.in/API/Contractor/CanceleDate?userID=Cr007e28b&DateID=Date31427&ReasonID=2&isCancellationFeeApplied=0&cancellationFee
            urlStr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&ReasonID=%@&isCancellationFeeApplied=%@&cancellationFee=%@",APIDateCancel,userIdStr,self.dateIdStr,reasonIdStr,sharedInstance.IsCancellationFeeAllowed,sharedInstance.cancellationFee];
            NSString *encoded = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bankDetailsURL = encoded;
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                    // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                    
                }
                else{
                    if(!error){
                        NSLog(@"Response is --%@",responseObject);
                        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                            // [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
//                            [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
//                                                         andButtonsWithTitle:@[@"Ok"] onController:self
//                                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                                                   if ([buttonTitle isEqualToString:@"Ok"]) {
                            
                                                                       if (sharedInstance.isFromMessageCancelDetails ) {
                                                                           [self tabBarControllerClass];
                                                                           sharedInstance.isFromMessageCancelDetails  = NO;
                                                                       }
                                                                       else{
                                                                           DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                                           checkTab = YES;
                                                                           [self.navigationController pushViewController:datesView animated:NO];
                                                                       }
//                                                                   }
//                                                               }];
                        }
                        else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2){
                            CreditCardDeclinedVC *declinedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardDeclinedVC"];
                            declinedVC.creditCradDeclinedMsg = [responseObject objectForKey:@"Message"];
                            // declinedVC.dateDetailsDictionary = dataDictionary;
                            declinedVC.bankDetailsWithUrl = bankDetailsURL;
                            declinedVC.dateIDStr = self.dateIdStr;
                            declinedVC.totalAmountToBePaid = sharedInstance.cancellationFee;\
                            sharedInstance.isFromCaneclDateByContractor = YES;
                            declinedVC.isFromCaneclDateByContractor = YES;
                            //                        if (self.isFromLoginView) {
                            //                            declinedVC.isFromLoginCreditView = YES;
                            //                        }
                            //                        else{
                            declinedVC.isFromLoginCreditView = NO;
                            //}
                            [self.navigationController pushViewController:declinedVC animated:YES];
                        }
                        else
                        {
                            [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                        }
                    }
                }
            }];
        }
        
    }

}
-(void)callAPiForCancel{
    
    //http://ondemandapiqa.flexsin.in/API/Contractor/DeclineDate?userID=Cu0055c6f1&DateID=Date31427&ReasonID=0
    //http://ondemandapinew.flexsin.in/API/Account/GetCancellationFee?UserID=Cr0036e78&DateID=Date31491
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIGetCancelFee,sharedInstance.userId,self.dateIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                sharedInstance.IsCancellationFeeAllowed = [responseObject objectForKey:@"ISCancelFeeAplied"];
                sharedInstance.cancellationFee = [responseObject objectForKey:@"CancellationnFee"];
                
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle)
                 {
                     if ([buttonTitle isEqualToString:@"Yes"]) {
       
                         if ([_buttonSattus isEqualToString:@"0"]) {
                             NSString    * urlString = [NSString stringWithFormat:@"%@?userID=%@&DateID=%@&ReasonID=%@",APIDateDecline,sharedInstance.userId,self.dateIdStr,@"0"];
                             NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                             [ProgressHUD show:@"Please wait..." Interaction:NO];
                             [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                                 NSLog(@"response object Get UserInfo List %@",responseObject);
                                 [ProgressHUD dismiss];
                                 if(!error){
                                     
                                     NSLog(@"Response is --%@",responseObject);
                                     if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                         [[AlertView sharedManager] presentAlertWithTitle:@"Alert" message:[responseObject objectForKey:@"Message"]
                                                                      andButtonsWithTitle:@[@"OK"] onController:self
                                                                            dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                          {
                                              if ([buttonTitle isEqualToString:@"OK"]) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }}];
                                     }
                                     
                                     else {
                                         [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                     }
                                 }
                             }];
                             
                         }
                         else{
                             
                             [self callSubmitMethodeForCancelDate];
                             //  [self.navigationController popViewControllerAnimated:YES];
                         }
                     }
                 }];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2)
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                
            }
        }
    }];
}
- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashBoardScreenView = [storyboard instantiateViewControllerWithIdentifier:@"dashboard"];
    dashBoardScreenView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    dashBoardScreenView.title = @"Dashboard";
    dashBoardScreenView.tabBarItem.image = [UIImage imageNamed:@"dashboard"];
    dashBoardScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"dashboard_hover"];
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    // datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor whiteColor];
    //  messageView.tabBarItem.badgeValue = messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor whiteColor];
    // notiView.tabBarItem.badgeValue = notificationsCountStr;
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
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
}


@end



