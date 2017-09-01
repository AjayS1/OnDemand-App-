//  DatesViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "DatesViewController.h"

@interface DatesViewController () {
    
    NSDictionary *animals;
    NSMutableArray *animalSectionTitles;
    NSArray *animalIndexTitles;
    NSMutableArray *upComingDateArray;
    NSMutableArray *pendingDateArray;
    NSMutableArray *inProgressDateArray;
    NSMutableArray *historyDateArray;
    NSMutableArray *upComingDateModalArray;
    NSMutableArray *pendingDateModalArray;
    NSMutableArray *inProgressDateModalArray;
    NSMutableArray *historyDateModalArray;
    LCTabBarController *tabBarC;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSDateFormatter *dateFormatter;
    int checkSegmentIndexValue;
    
}

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

- (NSString *)getImageFilename:(NSString *)animal {
    
    NSString *imageFilename = [[animal lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    imageFilename = [imageFilename stringByAppendingString:@".jpg"];
    return imageFilename;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.dateImageView setHidden:YES];
//    [self.dontHaveMessage setHidden:YES];
//    [self.segmentButton setHidden:YES];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    sharedInstance = [SingletonClass sharedInstance];
    upComingDateModalArray = [[NSMutableArray  alloc]init];
    pendingDateModalArray = [[NSMutableArray  alloc]init];
    inProgressDateModalArray = [[NSMutableArray  alloc]init];
    historyDateModalArray = [[NSMutableArray  alloc]init];
    _currentDatesView.layer.borderColor = [UIColor colorWithRed:166.0/255.0 green:108.0/255.0 blue:172.0/255.0 alpha:1].CGColor;
    _currentDatesView.layer.borderWidth = 1.1;
    _currentDatesView.layer.cornerRadius = 4.0;
    
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self.segmentButton setHidden:YES];
    datesTable.estimatedRowHeight = 110;
    datesTable.rowHeight = UITableViewAutomaticDimension;
    userIdStr = sharedInstance.userId;
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    datesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    sharedInstance.refreshApiCallOrNotStr = @"yes";
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiCallRefreshScreen:)
                                                 name:@"apiRefreshCall"
                                               object:nil];
    dateFormatter = [[NSDateFormatter alloc] init];
    
    if (_isFromDateDetails) {
        NSLog(@"Selected Index %u",self.tabBarController.selectedIndex);
        switch (self.tabBarController.selectedIndex) {
            case 0:
            {
                SearchViewController *searchScreenView = [self.storyboard  instantiateViewControllerWithIdentifier:@"search"];
                //searchScreenView.view.backgroundColor = [UIColor whiteColor];
                searchScreenView.title = @"Search";
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:searchScreenView animated:NO];
                return;
            }
                break;
            case 1:
            {
                DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:datesView animated:NO];
                return;
            }
                break;
            case 2:
            {
                MessagesViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"messages"];
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:notiView animated:NO];
                return;
            }
                break;
            case 3:
            {
                NotificationsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notifications"];
                _isFromDateDetails = NO;
                [self.navigationController pushViewController:notiView animated:NO];
                return;
            }
                break;
            case 4:
            {
                AccountViewController *accountView = [self.storyboard instantiateViewControllerWithIdentifier:@"account"];
                _isFromDateDetails = NO;
                accountView.isEmailVerifiedOrNotPage = NO;
                accountView.isFromUpdateMobileNumber = NO;
                accountView.isFromOrderProcess = NO;
                accountView.isFromCreditCardProcess = NO;
                [self.navigationController pushViewController:accountView animated:NO];
                return;
            }
                break;
            default:
                break;
        }
    }
    [self getAllDateAPiCall];
}

- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.isFromLoginView = NO;
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
}

- (void)apiCallRefreshScreen:(NSNotification*) noti {
    [self getAllDateAPiCall];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    sharedInstance.refreshApiCallOrNotStr = @"";
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"apiRefreshCall"
                                                  object:nil];
}

- (void)tabBarCountApiCall {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        //    [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                    [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                }
                else
                {
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
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (checkSegmentIndexValue == 0) {
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
//            [self.view setBackgroundColor:[UIColor whiteColor]];
//            [self.dateImageView setHidden:NO];
//            self.dontHaveMessage.text = @"You don't have any current dates.";
//           [self.dontHaveMessage setHidden:NO];
//           [datesTable setHidden:YES];
//            [_datesView setHidden:YES];
//            [self.datesWithSegmentView setHidden:NO];
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
//            [self.view setBackgroundColor:[UIColor whiteColor]];
//            [self.dateImageView setHidden:NO];
//            [self.dontHaveMessage setHidden:NO];
//            self.dontHaveMessage.text = @"You don't have any history dates.";
//            [datesTable setHidden:YES];
//            [_datesView setHidden:YES];
//            [self.datesWithSegmentView setHidden:NO];
            return 0.0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WallTableViewCell *cell;
  //  cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall" forIndexPath:indexPath];
    if (checkSegmentIndexValue == 0) {
        cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall" forIndexPath:indexPath];
    datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    else
    {
        cell = (WallTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Wall" forIndexPath:indexPath];
        datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        ;
    }
    cell.backgroundColor = [UIColor clearColor];
    NSLog(@"Width of cell %f",cell.addressLbl.frame.size.width);
    NSLog(@"Height of cell %f",cell.addressLbl.frame.size.height);
    double cellAddressLabelWidth = cell.addressLbl.frame.size.width;
    double celldateLabelWidth = cell.dateLbl.frame.size.width;
    if (WIN_WIDTH == 320) {
        [cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
        [cell.addressLbl setFont:[UIFont systemFontOfSize:10]];
//
//        if (checkSegmentIndexValue == 0) {
//            [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+40, cell.addressLbl.frame.size.height)];
//            [cell.dateValueImageView setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x, cell.dateValueImageView.frame.origin.y+3, 13, 13)];
//            [cell.dateValueImageView setHidden:NO];
//            [cell.dateLbl setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x+cell.dateValueImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, 270, cell.dateLbl.frame.size.height)];
//        }
//        else
//        {
//            [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+45, cell.addressLbl.frame.size.height)];
//            [cell.dateValueImageView setHidden:NO];
//            [cell.dateValueImageView setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x, cell.dateLbl.frame.origin.y+3, 13, 13)];
//            [cell.dateLbl setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x+cell.dateValueImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, celldateLabelWidth+25, cell.dateLbl.frame.size.height)];
//            
//        }
    }
    else{
//        [cell.dateLbl setFont:[UIFont systemFontOfSize:12]];
//        [cell.addressLbl setFont:[UIFont systemFontOfSize:12]];
//
//        [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+30, cell.addressLbl.frame.size.height)];
//        [cell.dateValueImageView setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x, cell.dateLbl.frame.origin.y+3, 13, 13)];
//        [cell.dateLbl setFrame:CGRectMake(cell.dateValueImageView.frame.origin.x+cell.dateValueImageView.frame.size.width+4, cell.dateLbl.frame.origin.y, cell.dateLbl.frame.size.width+5, cell.dateLbl.frame.size.height)];
        
    }
    
    NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section] ;
    NSArray *sectionData = [animals objectForKey:sectionTitle];
    [cell.dontHaveMessageLbl setHidden:YES];
    cell.notificationCountLbl.hidden = NO;
    cell.statusAcceptedLbl.hidden = NO;
    /// [cell.dontHaveMessageLbl setHidden:NO];
    [cell.cancelMessageLbl setHidden:NO];
    [cell.nameLbl setHidden:NO];
    [cell.userImageView setHidden:NO];
    [cell.dateLbl setHidden:NO];
    [cell.statusAcceptedLbl setHidden:NO];
    [cell.addressLbl setHidden:NO];
    [cell.dateTimeLbl setHidden:YES];
    if (checkSegmentIndexValue == 0) {
        [cell.cancelFeeLbl setHidden:YES];
        
        if (pendingDateArray.count) {
            [cell.dontHaveMessageLbl setHidden:YES];
            [self.dateImageView setHidden:YES];
            //datesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (pendingDateArray.count == 1)
                [cell.seperatorLbl setHidden:NO];
            else
                [cell.seperatorLbl setHidden:NO];
            [cell.cancelFeeLbl setHidden:NO];
            cell.cancelMessageLbl.hidden = YES;
            if (indexPath.section == 0) {
                cell.statusAcceptedLbl.hidden = YES;
            }
            else {
            }
            NSString *dateStatusType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateStatusType"]];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            if ([dateValueType isEqualToString:@"1"]) {
                [cell.dateValueImageView setImage:[UIImage imageNamed:@"lightning"]];
            }
            else
            {
                [cell.dateValueImageView setImage:[UIImage imageNamed:@"calendar_Other"]];
            }
            NSLog(@"dateStatusType %@",dateStatusType);
            NSString *dateStatusTypeValue =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateStatusType"]];
            
            if ([dateStatusTypeValue isEqualToString:@"Pending"]) {
                cell.cancelFeeLbl.textColor = [UIColor colorWithRed:246.0/255.0 green:146.0/255.0 blue:30.0/255.0 alpha:1.0];
            }
            else{
                cell.cancelFeeLbl.textColor = [UIColor colorWithRed:20.0/255.0 green:147.0/255.0 blue:69.0/255.0 alpha:1.0];
            }
            NSString *dateReadType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"isCustomerRead"]];
            if ([sectionTitle isEqualToString:@"PENDING" ]) {
                cell.notificationCountLbl.hidden = YES;
            }
            else{
                if ([dateReadType isEqualToString:@"0"]) {
                    cell.notificationCountLbl.hidden = NO;
                    cell.notificationCountLbl.layer.cornerRadius=cell.notificationCountLbl.frame.size.height/2;
                    cell.notificationCountLbl.layer.masksToBounds = YES;
                }
                else {
                    cell.notificationCountLbl.hidden = YES;
                }
            }

            cell.nameLbl.text = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            cell.addressLbl.text = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"Location"];
//            [cell.addressLbl adjustsFontSizeToFitWidth];
//            cell.addressLbl.minimumScaleFactor = 12;
//            cell.addressLbl.numberOfLines = 0;
//            cell.addressLbl.lineBreakMode = NSLineBreakByWordWrapping;
//            cell.addressLbl.textAlignment = NSTextAlignmentLeft;
//            [cell.addressLbl sizeToFit];
//            cell.seperatorLbl.frame = CGRectMake(0, cell.addressLbl.frame.origin.y+cell.addressLbl.frame.size.height+18, self.view.frame.size.width, 1);
            // cell.dateLbl.text = [[sectionData objectAtIndex:indexPath.row] objectForKey:@"RequestTime"];
            [cell.cancelFeeLbl setText:dateStatusTypeValue];
            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"ReserveTime"]];
            NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSString *requestTimeStr = [NSString stringWithFormat:@"%@", [[sectionData objectAtIndex:indexPath.row] objectForKey:@"RequestTime"]];
            NSArray *nameRequestStr = [requestTimeStr componentsSeparatedByString:@"."];
            NSString *fileKeyRequest = [NSString stringWithFormat:@"%@",[nameRequestStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            NSString *requestDate = [CommonUtils convertUTCTimeToLocalTime:fileKeyRequest WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            //  [cell.dateTimeLbl setText:[NSString stringWithFormat:@"%@",requestDate]];
            [cell.dateTimeLbl setText:[CommonUtils setDateStatusWithDate:requestDate]];
            cell.dateLbl.text = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
            if ([requestTimeStr isEqual:@"<null>"]|| [requestTimeStr isEqual: [NSNull null]]) {
                //  cell.dateLbl.text = @"";
            }
            else {
                //  cell.dateLbl.text = [[sectionData objectAtIndex:indexPath.row] objectForKey:@"RequestTime"];
            }
            
            if (![[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"StatusType"] isKindOfClass:[NSNull class]]) {
                cell.statusAcceptedLbl.text = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"StatusType"];
            }
            NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"]];
            NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
            // [cell.userImageView setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height+10)];
            [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            return cell;
        }
        
        else
        {
            [cell.seperatorLbl setHidden:YES];
            [cell.dontHaveMessageLbl setHidden:NO];
            [cell.nameLbl setHidden:YES];
            [self.dateImageView setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any current dates.";
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [cell.notificationCountLbl setHidden:YES];
            [cell.userImageView setHidden:YES];
            [cell.dateLbl setHidden:YES];
            [cell.statusAcceptedLbl setHidden:YES ];
            [cell.addressLbl setHidden:YES];
            [cell.dateTimeLbl setHidden:YES];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [_datesView setHidden:YES];
            [self.datesWithSegmentView setHidden:NO];
            //            if ([sectionTitle isEqualToString:@"PENDING"])
            //            {
            //                [cell.dontHaveMessageLbl setText:@"No pending dates."];
            //            }
            //            else if ([sectionTitle isEqualToString:@"UPCOMING"])
            //            {
            //                [cell.dontHaveMessageLbl setText:@"No upcoming dates."];
            //
            //            }
            //            else if ([sectionTitle isEqualToString:@"IN PROGRESS"])
            //            {
            //                [cell.dontHaveMessageLbl setText:@"No in progress dates."];
            //            }
        }
        return cell;
    }
    else {
        
        if (historyDateArray.count) {
            [cell.dontHaveMessageLbl setHidden:YES];
            [self.dateImageView setHidden:YES];
            cell.cancelFeeLbl.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];

            //datesTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            if (historyDateArray.count ==1)
                [cell.seperatorLbl setHidden:NO];
            else
                [cell.seperatorLbl setHidden:NO];
            [cell.dateTimeLbl setHidden:YES];
            [cell.dateLbl setHidden:NO];
            [cell.cancelFeeLbl setHidden:NO];
            [cell.cancelMessageLbl setHidden:NO];
            cell.notificationCountLbl.hidden = YES;
            cell.statusAcceptedLbl.hidden = YES;
            [cell.dontHaveMessageLbl setHidden:YES];
            [cell.nameLbl setHidden:NO];
            [cell.userImageView setHidden:NO];
            [cell.dateLbl setHidden:NO];
            [cell.statusAcceptedLbl setHidden:YES ];
            [cell.addressLbl setHidden:NO];
            cell.nameLbl.text = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            cell.addressLbl.text = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Location"];
             [cell.addressLbl adjustsFontSizeToFitWidth];
            cell.addressLbl.minimumScaleFactor = 12;
            cell.addressLbl.numberOfLines = 0;
            cell.addressLbl.lineBreakMode = NSLineBreakByWordWrapping;
            cell.addressLbl.textAlignment = NSTextAlignmentLeft;
            [cell.addressLbl sizeToFit];
            //cell.dateLbl.text = [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestTime"];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            NSString *dateType =   [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            if ([dateType isEqualToString:@"6"]  || [dateType isEqualToString:@"10"] || [dateType isEqualToString:@"19"] || [dateType isEqualToString:@"20"]) {
                if ([dateValueType isEqualToString:@"1"]) {
                    [cell.dateValueImageView setImage:[UIImage imageNamed:@"lightning"]];
                }
                else
                {
                    [cell.dateValueImageView setImage:[UIImage imageNamed:@"calendar_Other"]];
                }
            }
            else
            {
                [cell.dateValueImageView setImage:[UIImage imageNamed:@"clock"]];
                
            }
                 // cell.seperatorLbl.frame = CGRectMake(0, cell.addressLbl.frame.origin.y+cell.addressLbl.frame.size.height + 18 , self.view.frame.size.width, 1);
           
            NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestTime"]];
            NSArray *nameStr = [reserveTimeStr componentsSeparatedByString:@"."];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSLog(@"%@",fileKey);
            
            NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
            cell.dateLbl.text = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateReadType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"isCustomerRead"]];
            
            if ([sectionTitle isEqualToString:@"PENDING" ])
            {
                cell.notificationCountLbl.hidden = YES;
            }
            else
            {
                if ( [dateReadType isEqualToString:@"0"]) {
                    cell.notificationCountLbl.hidden = NO;
                    cell.notificationCountLbl.layer.cornerRadius=cell.notificationCountLbl.frame.size.height/2;
                    cell.notificationCountLbl.layer.masksToBounds = YES;
                }
                else {
                    cell.notificationCountLbl.hidden = YES;
                }
            }
            
            NSString *setPrimaryImageUrlStr =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"]];
            NSURL *imageUrl = [NSURL URLWithString:setPrimaryImageUrlStr];
            [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            //Manging the status of the date
            /*
             CancelDateContractorEnd = 10,
             CustomerCancelled = 6,
             CancelDateContractorEndWithFee = 19,
             CustomerCancelledWithFee = 20,
             EndtDate = 9,
             PaymentReceived = 11,
             PaymentPending = 12,
             */
            NSInteger dateStatusType = [[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"] integerValue];
            switch (dateStatusType) {
                case 6:{
                    //                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]];
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 9: {
                    [cell.cancelFeeLbl setText:@"Processing..."];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 10:{
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    //                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 11:{
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 17:{
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 25:{
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]],@"ChargeBack"]];
                    //                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Total"]]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 12:{
                    [cell.cancelFeeLbl setText:@"Processing..."];
                    [cell.cancelMessageLbl setHidden:YES];
                }
                    break;
                    
                case 19:{
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                    
                case 20:{
                    //                    [cell.cancelFeeLbl setText:[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]]];
                    [cell.cancelFeeLbl setText:[NSString stringWithFormat:@"%@ / %@",[CommonUtils getFormateedNumberWithValue:[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"CancellationnFee"]],@"Cancelled"]];
                    [cell.cancelMessageLbl setText:@""];
                }
                    break;
                default:
                    break;
            }
            
            //            if (WIN_WIDTH == 320) {
            //                if (checkSegmentIndexValue == 0) {
            //                    [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, 240, cell.addressLbl.frame.size.height)];
            //                    [cell.dateLbl setFrame:CGRectMake(cell.dateLbl.frame.origin.x, cell.dateLbl.frame.origin.y, 235, cell.dateLbl.frame.size.height)];
            //                }
            //                else
            //                {
            //                    [cell.addressLbl setFrame:CGRectMake(cell.addressLbl.frame.origin.x, cell.addressLbl.frame.origin.y, cellAddressLabelWidth+30, cell.addressLbl.frame.size.height)];
            //                    [cell.dateLbl setFrame:CGRectMake(cell.dateLbl.frame.origin.x, cell.dateLbl.frame.origin.y, celldateLabelWidth+25, cell.dateLbl.frame.size.height)];
            //                }
            //
            //            }
            return cell;
        }
        else
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            datesTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            self.dontHaveMessage.text = @"You don't have any history dates.";
            [datesTable setHidden:YES];
            [_datesView setHidden:YES];
            [self.datesWithSegmentView setHidden:NO];
        }
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *sectionTitle = [animalSectionTitles objectAtIndex:indexPath.section] ;
    NSArray *sectionData = [animals objectForKey:sectionTitle];
   

    if (checkSegmentIndexValue == 0) {
        if (pendingDateArray.count) {
            
            NSString *dateStatusType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            sharedInstance.requestTypeStr = dateValueType;
            if ([dateStatusType isEqualToString:@"9"]|| [dateStatusType isEqualToString:@"12"])
            {
                PaymentDateCompletedViewController *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
                paymentView.isFromLoginView = NO;
                paymentView.self.dateIdStr =  [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
                paymentView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
                [self.navigationController pushViewController:paymentView animated:YES];
            }
            else
            {
                DateDetailsViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateDetail"];
                dateDetailsView.self.dateIdStr =  [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
                dateDetailsView.self.isFromRequestNow =  FALSE;;
                dateDetailsView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
                if (![[[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"StatusType"] isKindOfClass:[NSNull class]]) {
                    dateDetailsView.self.statusTypeStr = [[pendingDateArray objectAtIndex:indexPath.row] objectForKey:@"StatusType"];
                }
                [self.navigationController pushViewController:dateDetailsView animated:YES];
            }
        }
    }
    else {
        
        NSString *dateStatusType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
        NSString *dateValueType =  [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
        sharedInstance.requestTypeStr = dateValueType;
        if ([dateStatusType isEqualToString:@"9"]|| [dateStatusType isEqualToString:@"12"]) {
            PaymentDateCompletedViewController *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
            paymentView.isFromLoginView = NO;
            paymentView.self.dateIdStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
            paymentView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            [self.navigationController pushViewController:paymentView animated:YES];
        }
        else {
            PastDateDetailsViewController *pastDateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"pastDateDetails"];
            pastDateDetailsView.self.dateIdStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateID"];
            pastDateDetailsView.self.userNameStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            pastDateDetailsView.self.picUrlStr =  [[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"PicUrl"];
            pastDateDetailsView.self.dateRequestType = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"RequestType"]];
            pastDateDetailsView.self.dateTypeStr = [NSString stringWithFormat:@"%@",[[historyDateArray objectAtIndex:indexPath.row] objectForKey:@"DateType"]];
            //             pastDateDetailsView.self.dateTypeStr = @"9";
            //            //pastDateDetailsView.self.dateTypeStr = @"19";
            
            [self.navigationController pushViewController:pastDateDetailsView animated:YES];
        }
    }
}

#pragma mark Segment Control Action Call

- (IBAction)segmentAction:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
        case 0:{
            checkSegmentIndexValue = 0;
            
            [datesTable reloadData];
        }
            break;
        case 1:{
            checkSegmentIndexValue = 1;
            [datesTable reloadData];
        }
            break;
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
    [self.segmentButton setHidden:YES];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIDateList,userIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self.segmentButton setHidden:YES];

    [ServerRequest AFNetworkGetRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        [self.dateImageView setHidden:YES];
        [self.dontHaveMessage setHidden:YES];
        [self.segmentButton setHidden:YES];

        if (([responseObject isKindOfClass:[NSNull class]])) {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [datesTable setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
            [self.dontHaveMessage setHidden:NO];
            [self.dontHaveMessage setText:@"You don't have any dates."];
            // [self.segmentButton setHidden:YES];
        }
        else if(!error)
        {
            [datesTable setHidden:NO];
//            //   [self.segmentButton setHidden:NO];
//            [_datesView setHidden:YES];
//            [self.datesWithSegmentView setHidden:NO];
//            [self.dontHaveMessage setText:@"You don't have any current dates."];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] == 1) {
                
                upComingDateArray = [[NSMutableArray alloc]init];
                pendingDateArray = [[NSMutableArray alloc]init];
                historyDateArray = [[NSMutableArray alloc]init];
                inProgressDateArray =[[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"UserDList"] isKindOfClass:[NSArray class]]) {
                    
                    pendingDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"UserDList"]];
                    pendingDateArray = [[responseObject objectForKey:@"result"]objectForKey:@"UserDList"];
                    
                }
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"] isKindOfClass:[NSArray class]]) {
                    
                    historyDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"]];
                    historyDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"];
                    
                }
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    }
                    else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    }
                    else {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                    }
                }
                
                if ((!(pendingDateArray.count)) && (!(historyDateArray.count)))
                {
                    
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:NO];
                    [self.dontHaveMessage setHidden:NO];
                    [datesTable setHidden:YES];
                    [self.segmentButton setHidden:YES];
                    [_datesView setHidden:NO];
                    [self.dontHaveMessage setText:@"You don't have any dates."];
                    [self.datesWithSegmentView setHidden:YES];

                }
                else
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:YES];
                    [self.dontHaveMessage setHidden:YES];
                    [datesTable setHidden:NO];
                    [self.segmentButton setHidden:NO];
                    [_datesView setHidden:YES];
                    [self.dontHaveMessage setText:@"You don't have any dates."];
                    [self.datesWithSegmentView setHidden:NO];
                    [datesTable reloadData];
                }
            }
            
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 0){
                
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dateImageView setHidden:NO];
                [datesTable setHidden:YES];
                [self.dontHaveMessage setHidden:NO];
                [self.dontHaveMessage setText:@"You don't have any dates."];
                [self.segmentButton setHidden:YES];
                [_datesView setHidden:NO];
                //[self.datesWithSegmentView setHidden:YES];
            }
            else
            {
//                [self.view setBackgroundColor:[UIColor whiteColor]];
//                [self.dateImageView setHidden:NO];
//                [self.dontHaveMessage setHidden:NO];
//                //[self.segmentButton setHidden:YES];
//                [datesTable setHidden:YES];
//                [self.dontHaveMessage setText:@"You don't have any dates."];
//                
//                [_datesView setHidden:NO];
//                [self.datesWithSegmentView setHidden:YES];
                // [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
        else
        {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [self.segmentButton setHidden:YES];
            [_datesView setHidden:NO];
            [self.dontHaveMessage setText:@"You don't have any dates."];
            
            [self.datesWithSegmentView setHidden:YES];
            
        }
        
    }];
}

#pragma mark Refresh api when notification received
- (void)apiCallRefreshScreen {
    [self.dateImageView setHidden:YES];
    [self.dontHaveMessage setHidden:YES];
    [self.segmentButton setHidden:YES];

    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@",APIDateList,userIdStr];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkGetRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        if (([responseObject isKindOfClass:[NSNull class]])) {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [datesTable setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
            [self.dontHaveMessage setHidden:NO];
            [self.dontHaveMessage setText:@"You don't have any dates."];
            
            // [self.segmentButton setHidden:YES];
        }
        else if(!error)
        {
            [datesTable setHidden:NO];
        //   [self.segmentButton setHidden:NO];
//            [_datesView setHidden:YES];
//            [self.datesWithSegmentView setHidden:NO];
//            [self.dontHaveMessage setText:@"You don't have any current dates."];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] == 1) {
                
                upComingDateArray = [[NSMutableArray alloc]init];
                pendingDateArray = [[NSMutableArray alloc]init];
                historyDateArray = [[NSMutableArray alloc]init];
                inProgressDateArray =[[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"UserDList"] isKindOfClass:[NSArray class]]) {
                    
                    pendingDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"UserDList"]];
                    pendingDateArray = [[responseObject objectForKey:@"result"]objectForKey:@"UserDList"];
                    
                }
                //                if ([[[responseObject objectForKey:@"result"]objectForKey:@"UpcomingDate"] isKindOfClass:[NSArray class]]) {
                //                    upComingDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"UpcomingDate"]];
                //                    upComingDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"UpcomingDate"];
                //
                //                }
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"] isKindOfClass:[NSArray class]]) {
                    
                    historyDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"]];
                    historyDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"HistoryDate"];
                    
                }
                //                if ([[[responseObject objectForKey:@"result"]objectForKey:@"Progressdate"] isKindOfClass:[NSArray class]]) {
                //
                //                    inProgressDateModalArray = [SingletonClass parseDateForDateArray:[[responseObject objectForKey:@"result"]objectForKey:@"Progressdate"]];
                //                    inProgressDateArray =  [[responseObject objectForKey:@"result"]objectForKey:@"Progressdate"];
                //                }
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                    }
                    else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                        [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    }
                    else {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                        [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                    }
                }
                
                if ((!(pendingDateArray.count)) && (!(historyDateArray.count)))
                {
                    
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:NO];
                    [self.dontHaveMessage setHidden:NO];
                    [datesTable setHidden:YES];
                    [self.segmentButton setHidden:YES];
                    [_datesView setHidden:NO];
                    [self.dontHaveMessage setText:@"You don't have any dates."];
                    [self.datesWithSegmentView setHidden:YES];
                    
                }
                else
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dateImageView setHidden:YES];
                    [self.dontHaveMessage setHidden:YES];
                    [datesTable setHidden:NO];
                    [self.segmentButton setHidden:NO];
                    [_datesView setHidden:YES];
                    [self.dontHaveMessage setText:@"You don't have any dates."];
                    [self.datesWithSegmentView setHidden:NO];
                    [datesTable reloadData];
                }
            }
            
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 0){
                
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dateImageView setHidden:NO];
                [datesTable setHidden:YES];
                [self.dontHaveMessage setHidden:NO];
                [self.segmentButton setHidden:YES];
                [self.dontHaveMessage setText:@"You don't have any dates."];
                
                [_datesView setHidden:NO];
                //[self.datesWithSegmentView setHidden:YES];
            }
            else
            {
//                [self.view setBackgroundColor:[UIColor whiteColor]];
//                [self.dateImageView setHidden:NO];
//                [self.dontHaveMessage setHidden:NO];
//                //[self.segmentButton setHidden:YES];
//                [datesTable setHidden:YES];
//                [_datesView setHidden:NO];
//                [self.dontHaveMessage setText:@"You don't have any dates."];
//                [self.datesWithSegmentView setHidden:YES];
                // [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
        else
        {
            [self.view setBackgroundColor:[UIColor whiteColor]];
            [self.dateImageView setHidden:NO];
            [self.dontHaveMessage setHidden:NO];
            [datesTable setHidden:YES];
            [self.dontHaveMessage setText:@"You don't have any dates."];
            [self.segmentButton setHidden:YES];
            [_datesView setHidden:NO];
            [self.datesWithSegmentView setHidden:YES];
            
        }
        
    }];
}

@end
