
//  MessagesViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "MessagesViewController.h"

@interface MessagesViewController () {
    
    NSString *selectedUserIdStr;
    NSString *userImageUrlStr;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSString *userNameStr;
    NSString *dateId;
    NSDateFormatter *dateFormatter;
    NSInteger lastCount;
    
}
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property(nonatomic,strong)NSMutableArray *messageUserList;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dateId =@"";
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    dateFormatter = [[NSDateFormatter alloc]init];
    [self.dontHaveLabel setHidden:YES];
    [self.messageImageView setHidden:YES];
    userListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    sharedInstance.refreshApiCallOrNotStr = @"yes";
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(apiCallRefreshScreen:)
                                                 name:@"apiRefreshCall"
                                               object:nil];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    [_titleLabel setText:@"MESSAGES"];
    [self allUserMessageListApiCall];
    
}


- (void)apiCallRefreshScreen:(NSNotification*) noti {
    
    [self apiCallRefreshScreen];
    
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
                else
                {
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
    if ([_messageUserList count]) {
        return [_messageUserList count];
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserLIst"];
    NSString *imageData = [[_messageUserList objectAtIndex:indexPath.row]objectForKey:@"Url"];
    NSURL *imageUrl = [NSURL URLWithString:imageData];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSString *userNameMessageStr = [NSString stringWithFormat:@"%@",[[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"UserName"]];
    NSString *messageStr = [NSString stringWithFormat:@"%@",[[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"MessageText"]];
    NSString *postDateStr = [NSString stringWithFormat:@"%@",[[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"postDate"]];
    if ([userNameMessageStr isEqualToString:@"<null>"]) {
        userNameMessageStr = @"";
        
    }
    
    if ([messageStr isEqualToString:@"<null>"]) {
        messageStr = @"";
    }
    
    if ([postDateStr isEqualToString:@"<null>"]) {
        postDateStr = @"";
    }
    
    cell.nameLbl.text = userNameMessageStr;
    cell.messageLbl.text = messageStr;
    NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", postDateStr];
    NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
    NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
    NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    if (WIN_WIDTH == 320) {
        [cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
    }
    cell.dateLbl.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    NSString *readNotificationCount = [NSString stringWithFormat:@"%@",[[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"MessageCounter"]];
    cell.notificationLbl.backgroundColor = [UIColor redColor];
    if ([readNotificationCount isEqualToString:@"0"]) {
        cell.notificationLbl.hidden = YES;
    }
    else {
        
        cell.notificationLbl.textColor = [UIColor whiteColor];
        cell.notificationLbl.hidden = NO;
        cell.notificationLbl.layer.cornerRadius=cell.notificationLbl.frame.size.height/2;
        cell.notificationLbl.layer.masksToBounds = YES;
        cell.notificationLbl.text = readNotificationCount;
    }
    lastCount = _messageUserList.count - 1;
    if (indexPath.row == lastCount) {
       /// cell.sepeartorLabel.hidden = true;
    }
    else{
        //cell.sepeartorLabel.hidden = false;

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [NSUserDefaults saveIncomingAvatarSetting:YES];
    [NSUserDefaults saveOutgoingAvatarSetting:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    selectedUserIdStr = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"AnotherUserID"];
    userImageUrlStr  = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"Url"];
    userNameStr = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"UserName"];
    dateId = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"DateId"];
    [self getUserMessageApiCall];
    
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this message?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   
                                                   NSString *contractorIdStr = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"AnotherUserID"];
                                                   NSString *deleteDateId = [[_messageUserList objectAtIndex:indexPath.row] objectForKey:@"DateId"];
                                                   
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&UserType=%@&DateId=%@",APIDeleteMessage,userIdStr,contractorIdStr,@"1",deleteDateId];
                                                   NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object Get UserInfo List %@",responseObject);
                                                       [ProgressHUD dismiss];
                                                       if(!error){
                                                           NSLog(@"Response is --%@",responseObject);
                                                           if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                               NSMutableArray *tempArray = [_messageUserList mutableCopy];
                                                               [tempArray removeObjectAtIndex:indexPath.row];
                                                               _messageUserList = [tempArray mutableCopy];
                                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                               if (_messageUserList.count) {
                                                                   [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                                                                   [self.dontHaveLabel setHidden:YES];
                                                                   [self.messageImageView setHidden:YES];
                                                               }
                                                               else{
                                                                   [self.view setBackgroundColor:[UIColor whiteColor]];
                                                                   [self.dontHaveLabel setHidden:NO];
                                                                   [self.messageImageView setHidden:NO];
                                                               }
                                                               [userListTable reloadData];
                                                           }
                                                           else
                                                           {
                                                               [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                           }
                                                       }
                                                   }];
                                               }
                                               
                                           }
         ];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Get All User Message Listing API Call
- (void)allUserMessageListApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&UserType=%@",APIGetAllUserMessageList,userIdStr,@"1"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                _messageUserList = [[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"] isKindOfClass:[NSArray class]]) {
                    _messageUserList =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"];
                    
                    if (_messageUserList.count) {
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [userListTable setHidden:NO];

                        [self.dontHaveLabel setHidden:YES];
                        [self.messageImageView setHidden:YES];
                    }
                    else{
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [self.dontHaveLabel setHidden:NO];
                        [userListTable setHidden:YES];

                        [self.messageImageView setHidden:NO];
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;

                    }
                    
                    [userListTable reloadData];
                }
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                        
                    }
                    
                }
                
            }
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] == 0)){
                if (_messageUserList.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [userListTable setHidden:NO];

                    [self.dontHaveLabel setHidden:YES];
                    [self.messageImageView setHidden:YES];
                }
                else
                {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                    [self.dontHaveLabel setHidden:NO];
                    [userListTable setHidden:YES];

                    [self.messageImageView setHidden:NO];
                }
                
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

#pragma mark Get User Message API Call
- (void)getUserMessageApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&UserType=%@&DateId=%@",APIGetMessagebyUser,userIdStr,selectedUserIdStr,@"1",dateId];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *messageData =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"];
                    
                    [NSUserDefaults saveIncomingAvatarSetting:YES];
                    [NSUserDefaults saveOutgoingAvatarSetting:YES];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                    sharedInstance.messagessDataMArray = [messageData copy];
                    sharedInstance.recipientIdStr = selectedUserIdStr;
                    sharedInstance.isFromMessageDetails = YES;
                    sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                    sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                    sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                    sharedInstance.dateIdStr = [NSString stringWithFormat:@"%@",[[messageData objectAtIndex:0] objectForKey:@"DateID"]];
                    sharedInstance.recipientNameStr = [userNameStr capitalizedString];
                    vc.self.recipientIdStr = selectedUserIdStr;
                    vc.self.userImageUrlStr =  userImageUrlStr;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}


#pragma mark Api Call RefreshScreen
- (void)apiCallRefreshScreen {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&UserType=%@",APIGetAllUserMessageList,userIdStr,@"1"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ServerRequest AFNetworkPostRequestUrl:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                _messageUserList = [[NSMutableArray alloc]init];
                
                if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"] isKindOfClass:[NSArray class]]) {
                    _messageUserList =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"];
                    if (_messageUserList.count) {
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [userListTable setHidden:NO];

                        [self.dontHaveLabel setHidden:YES];
                        [self.messageImageView setHidden:YES];
                    }
                    else{
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [userListTable setHidden:YES];

                        [self.dontHaveLabel setHidden:NO];
                        [self.messageImageView setHidden:NO];
                    }
                    
                    [userListTable reloadData];
                }
                
                if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:1] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"] isEqualToString:@"0"]) {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Mesages"];
                    }
                    
                    if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"] isEqualToString:@"0"]) {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                        
                    } else {
                        
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = [[responseObject objectForKey:@"CounterResult"] objectForKey:@"Notifications"];
                        
                    }
                }
                
            } else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                if (_messageUserList.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [userListTable setHidden:NO];

                    [self.dontHaveLabel setHidden:YES];
                    [self.messageImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [userListTable setHidden:YES];

                    [self.dontHaveLabel setHidden:NO];
                    [self.messageImageView setHidden:NO];
                }
                
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}



@end
