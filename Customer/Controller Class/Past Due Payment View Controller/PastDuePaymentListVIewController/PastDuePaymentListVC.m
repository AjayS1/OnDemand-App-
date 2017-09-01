//
//  PastDuePaymentListVC.m
//  Customer
//
//  Created by Aditi on 22/05/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "PastDuePaymentListVC.h"

#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width
@interface PastDuePaymentListVC () {
    
    NSMutableArray *dataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSInteger selectedIndexPath;
    NSMutableDictionary *dataDic;
    NSString *ratingValueStr;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    
    
}
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountExpiryLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountPrimaryLabel;
@property (strong, nonatomic) IBOutlet UITableView *paymentTableView;


@end

@implementation PastDuePaymentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _paymentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    dataDic = [[NSMutableDictionary alloc]init];
    [self setViewOfLabel];
    [self fetchGetPaymentMethodListApiData];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
}


-(void)setViewOfLabel {
    
    if (WIN_WIDTH == 320) {
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 35, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(80, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(160, 11, 56, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(235, 11, 30, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(255, 11, 76, 21)];
        [self.accountTypeLabel setContentMode:UIViewContentModeLeft];
        [self.accountNumberLabel   setContentMode:UIViewContentModeLeft];
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel  setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (WIN_WIDTH == 414){
        
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 60, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(115, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(200, 11, 60, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(270, 11, 45, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(310, 11, 76, 21)];
        [self.accountStatusLabel setBackgroundColor:[UIColor whiteColor]];
        
    }
    else if (WIN_WIDTH == 375){
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButtonMethodClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bankAccountButtonClicked:(id)sender {
    
    /*AddBankAccountViewController *addBankAccountView = [self.storyboard instantiateViewControllerWithIdentifier:@"addBank"];
     [self.navigationController pushViewController:addBankAccountView animated:YES];*/
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count?dataArray.count:0;
    // return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaymentTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = (PaymentTableViewCell *)[self.paymentTableView dequeueReusableCellWithIdentifier:@"paymentCellID"];
    }
    if (WIN_WIDTH == 320) {
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
    }
    if (dataArray.count) {
        SingletonClass *customData = [dataArray objectAtIndex:indexPath.row];
        NSString *primaryAccount = [NSString stringWithFormat:@"%@",customData.accountPrimary];
        
        if ([primaryAccount isEqualToString:@"True"]) {
            
            [cell.accountPrimaryLabel setText:@"Primary"];
        }
        else {
            [cell.accountPrimaryLabel setText:@""];
        }
        
        NSString *primaryYesOrNo = customData.accountVerifyStatus;
        if ([primaryYesOrNo isEqualToString:@"0"]) {
            cell.selectedImageView.image = [UIImage imageNamed:@"not_verified"];
        }
        else {
            cell.selectedImageView.image = [UIImage imageNamed:@"verified"];
        }
        
        NSString *trimmedString=[customData.accountNumStr substringFromIndex:MAX((int)[customData.accountNumStr length]-4, 0)];
        cell.accountNumberLabel.text = [NSString stringWithFormat:@"****%@",trimmedString];
        [cell.accountStatusLabel setText: customData.accountStatus];
        [cell.accountTypeLabel setText: customData.bankName];
        cell.accountTypeLabel.minimumScaleFactor = 12;
        cell.accountTypeLabel.numberOfLines = 0;
        cell.accountTypeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.accountTypeLabel.textAlignment = NSTextAlignmentLeft;
        [cell.accountTypeLabel sizeToFit];
        [cell.accountExpiryLabel setText: customData.expiryDate];
        cell.accountNumberLabel.numberOfLines = 0;
        cell.accountNumberLabel.adjustsFontSizeToFitWidth = YES;
        [cell.accountNumberLabel sizeToFit];
    }
    
    
    return cell;
}


-(void )tableView:(UITableView * ) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [self.view endEditing:YES];
    selectedIndexPath = indexPath.row;
    [[AlertView sharedManager] presentAlertWithTitle:@"Pay Now" message:@"Are you sure, you want to use this card for the payment?"
                                 andButtonsWithTitle:@[@"Cancel",@"Proceed"] onController:self
                                       dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                           if ([buttonTitle isEqualToString:@"Proceed"]) {
                                               [self PayAmountByPaymentMethodListApiData];
                                           }
                                       }];
    
    
    NSLog(@"IndexPath %ld",(long)selectedIndexPath);
    //actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
}


#pragma mark--Get Payment Method List API Call
- (void)fetchGetPaymentMethodListApiData {
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForQA:APIGetPaymentMethodVerifiedList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            [dataArray removeAllObjects];
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                dataArray = [[NSMutableArray alloc]init];
                // dataDic = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                NSLog(@"DatDict %@",[responseObject objectForKey:@"result"]);
                //dataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                dataArray = [SingletonClass parseDateForPaymentVerified:[[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"]];
                [self.paymentTableView reloadData];
            }
            
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}

- (void)PayAmountByPaymentMethodListApiData {
    SingletonClass *customData = [dataArray objectAtIndex:selectedIndexPath];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&CreditId=%@&Amount=%@&CardNo=%@&Dateid=%@",APPayPaymentMethodVerified,userIdStr,customData.VerifyId,self.totalAmountStr,customData.accountNumStr,self.dateIDStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Param%@",urlstr);
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       if ([buttonTitle isEqualToString:@"OK"]) {
                                                           [self tabBarCountApiCall];
                                                       }
                                                   }];
            }
            
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}
- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
   // [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
       // [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"])
                {
                    dateCountStr  = nil;
                }
                else
                {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"])
                {
                    messageCountStr = nil;
                }
                else
                {
                    messageCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"])
                {
                    notificationsCountStr   = nil;
                }
                else
                {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
        }
        [self tabBarControllerClass];
    }];
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    //searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    //datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    messageView.tabBarItem.badgeValue =messageCountStr;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:searchScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    APPDELEGATE.tabBarC.selectedItemTitleColor = [UIColor purpleColor];
    APPDELEGATE.tabBarC.viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:YES];
}


@end
