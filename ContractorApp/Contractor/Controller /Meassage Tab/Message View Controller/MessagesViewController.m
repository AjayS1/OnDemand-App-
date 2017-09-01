
//  MessagesViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "MessagesViewController.h"
#import "OneToOneMessageViewController.h"
#import "OnDemandDatePushNotificationViewController.h"

#import "ChatUserTableViewCell.h"
#import "NSUserDefaults+DemoSettings.h"
#import "ServerRequest.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "WallTableViewCell.h"
#import "AppDelegate.h"
#import "SingletonClass.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AlertView.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface MessagesViewController () {
    
    NSMutableArray *messageUserList;
    NSString *selectedUserIdStr;
    NSString *userImageUrlStr;
    SingletonClass *sharedInstance;
    NSDateFormatter *dateFormatter;
    NSString *userNameStr;
    
    NSString *dateId;
}
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateId = @"";
    sharedInstance = [SingletonClass sharedInstance];
    [self.dontHaveLabel setHidden:YES];
    [self.messageImageView setHidden:YES];
    userListTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    sharedInstance.isFromMessageCancelDetails = YES;
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
       [_titleLabel setText:@"MESSAGES"];
    
    
    [self allUserMessageListApiCall];
    
    self.navigationController.navigationBar.hidden=YES;
    //    [UITabBarItem.appearance setTitleTextAttributes:
    //     @{NSForegroundColorAttributeName : [UIColor clearColor]}
    //                                           forState:UIControlStateSelected];
    [self.tabBarController.tabBar setHidden:NO];
    //    [self.tabBarController.tabBar.selectedItem setBadgeColor:[UIColor clearColor]];
    //    [self.tabBarController.tabBar.items objectAtIndex:2].selectedImage  = [UIImage imageNamed:@"wqwqw"] ;
    //    [[APPDELEGATE tabBarC].tabBar setHidden:NO];
    
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
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
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
    return [messageUserList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserLIst"];
    
    NSString *imageData = [[messageUserList objectAtIndex:indexPath.row]objectForKey:@"Url"];
    NSURL *imageUrl = [NSURL URLWithString:imageData];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [cell.userImageView sd_setImageWithURL:imageUrl
    //                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //[cell.backgroundView addSubview:recipeImageView];
    
    NSString *userNameMessageStr = [NSString stringWithFormat:@"%@",[[messageUserList objectAtIndex:indexPath.row] objectForKey:@"UserName"]];
    NSString *messageStr = [NSString stringWithFormat:@"%@",[[messageUserList objectAtIndex:indexPath.row] objectForKey:@"MessageText"]];
    NSString *postDateStr = [NSString stringWithFormat:@"%@",[[messageUserList objectAtIndex:indexPath.row] objectForKey:@"postDate"]];
    if ([userNameMessageStr isEqualToString:@"<null>"]) {
        userNameMessageStr = @"";
    }
    
    if ([messageStr isEqualToString:@"<null>"]) {
        messageStr = @"";
        
    }
    if ([postDateStr isEqualToString:@"<null>"]) {
        postDateStr = @"";
    }
    if (WIN_WIDTH == 320) {
        [cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
    }
    cell.nameLbl.text = userNameMessageStr;
    cell.messageLbl.text = messageStr;
    
    NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", postDateStr];
    NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
    NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
    NSString *reserveDate = [self convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    cell.dateLbl.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *readNotificationCount = [NSString stringWithFormat:@"%@",[[messageUserList objectAtIndex:indexPath.row] objectForKey:@"MessageCounter"]];
    
    cell.notificationLbl.backgroundColor = [UIColor redColor];
    
    if ([readNotificationCount isEqualToString:@"0"]) {
        
        cell.notificationLbl.hidden = YES;
        
    } else {
        
        cell.notificationLbl.textColor = [UIColor whiteColor];
        cell.notificationLbl.hidden = NO;
        cell.notificationLbl.layer.cornerRadius=cell.notificationLbl.frame.size.height/2;
        cell.notificationLbl.layer.masksToBounds = YES;
        cell.notificationLbl.text = readNotificationCount;
        
    }
    
    return cell;
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

#pragma mark:- Change UTC time Current Local Time
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [NSUserDefaults saveIncomingAvatarSetting:YES];
    [NSUserDefaults saveOutgoingAvatarSetting:YES];
    [[NSUserDefaults standardUserDefaults] synchronize];
    selectedUserIdStr = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"AnotherUserID"];
    userImageUrlStr  = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"Url"];
    userNameStr = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"UserName"];
    dateId = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"DateId"];
    [self getUserMessageApiCall];
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this message?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   
                                                   NSString *userIdStr = sharedInstance.userId;
                                                   
                                                   NSString *contractorIdStr = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"AnotherUserID"];
                                                   
                                                   NSString *deleteDateId = [[messageUserList objectAtIndex:indexPath.row] objectForKey:@"DateId"];
                                                   
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&UserType=%@&&DateId=%@",APIDeleteMessage,contractorIdStr,userIdStr,@"2",deleteDateId];
                                                   
                                                   NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object Get UserInfo List %@",responseObject);
                                                       
                                                       [ProgressHUD dismiss];
                                                       
                                                       if(!error){
                                                           NSLog(@"Response is --%@",responseObject);
                                                           if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                               NSMutableArray * tempArray = [messageUserList mutableCopy];
                                                               [tempArray removeObjectAtIndex:indexPath.row];
                                                               messageUserList = [tempArray mutableCopy];
                                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                               if (messageUserList.count) {
                                                                   [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                                                                   [self.dontHaveLabel setHidden:YES];
                                                                   [self.messageImageView setHidden:YES];
                                                                   [userListTable setHidden:NO];

                                                               }
                                                               else{
                                                                   [self.view setBackgroundColor:[UIColor whiteColor]];
                                                                   [self.dontHaveLabel setHidden:NO];
                                                                   [userListTable setHidden:YES];

                                                                   [self.messageImageView setHidden:NO];
                                                               }
                                                               [userListTable reloadData];
                                                               
                                                           }
                                                           else {
                                                               [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                           }
                                                       }
                                                   }];
                                               }
                                               
                                           }];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Get All User Message Listing API Call
- (void)allUserMessageListApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&UserType=%@",APIGetAllUserMessageList,userIdStr,@"2"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            //[CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    messageUserList = [[NSMutableArray alloc]init];
                    
                    if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"] isKindOfClass:[NSArray class]]) {
                        messageUserList =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"];
                        if (messageUserList.count) {
                            [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                            [self.dontHaveLabel setHidden:YES];
                            [self.messageImageView setHidden:YES];
                            [userListTable setHidden:NO];

                        }
                        else{
                            [self.view setBackgroundColor:[UIColor whiteColor]];
                            [self.dontHaveLabel setHidden:NO];
                            [self.messageImageView setHidden:NO];
                            [userListTable setHidden:YES];

                            [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                            [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;

                        }
                        [userListTable reloadData];
                        
                        if ([[responseObject objectForKey:@"CounterResult"] isKindOfClass:[NSDictionary class]]) {
                            if ([[[responseObject objectForKey:@"CounterResult"] objectForKey:@"Dates"] isEqualToString:@"0"]) {
                                [[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = nil;
                            }
                            else {
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
                }
                else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                    if (messageUserList.count) {
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [self.dontHaveLabel setHidden:YES];
                        [self.messageImageView setHidden:YES];
                        [userListTable setHidden:NO];

                    }
                    else
                    {
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [self.dontHaveLabel setHidden:NO];
                        [self.messageImageView setHidden:NO];
                        [userListTable setHidden:YES];
                        [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;
                        [[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue = nil;

                    }
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

#pragma mark Get User Message API Call
- (void)getUserMessageApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&UserType=%@&DateId=%@",APIGetMessagebyUser,selectedUserIdStr,userIdStr,@"2",dateId];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"] isKindOfClass:[NSArray class]]) {
                        
                        NSArray *messageData =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"];
                        [NSUserDefaults saveIncomingAvatarSetting:YES];
                        [NSUserDefaults saveOutgoingAvatarSetting:YES];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        sharedInstance.messagessDataMArray = [messageData copy];
                        sharedInstance.userNameStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"AppLoginUserName"]];
                        sharedInstance.userImageUrlStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"ApploginPicName"]];
                        sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                        sharedInstance.dateIdStr = [NSString stringWithFormat:@"%@",[[messageData objectAtIndex:0] objectForKey:@"DateID"]];
                        sharedInstance.recipientNameStr = [userNameStr capitalizedString];
                        OneToOneMessageViewController *vc = [OneToOneMessageViewController messagesViewController];
                        //  sharedInstance.messagessDataMArray = [messageData copy];
                        sharedInstance.recipientIdStr = selectedUserIdStr;
                        sharedInstance.isFromMessageDetails = YES;
                        
                        //vc.self.messagessDataMArray = [messageData mutableCopy];
                        vc.self.recipientIdStr = selectedUserIdStr;
                        sharedInstance.recipientIdStr = selectedUserIdStr;
                        vc.self.userImageUrlStr =  userImageUrlStr;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}


#pragma mark Refresh Screen when notification received
- (void)apiCallRefreshScreen {
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&UserType=%@",APIGetAllUserMessageList,userIdStr,@"2"];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    messageUserList = [[NSMutableArray alloc]init];
                    
                    if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"] isKindOfClass:[NSArray class]]) {
                        messageUserList =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageALL"];
                        if (messageUserList.count) {
                            [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                            
                            [self.dontHaveLabel setHidden:YES];
                            [self.messageImageView setHidden:YES];
                            [userListTable setHidden:NO];

                        }
                        else{
                            [self.view setBackgroundColor:[UIColor whiteColor]];
                            
                            [self.dontHaveLabel setHidden:NO];
                            [self.messageImageView setHidden:NO];
                            [userListTable setHidden:YES];

                        }
                        
                        [userListTable reloadData];
                        
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
                    }
                    
                }
                else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                    if (messageUserList.count) {
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [self.dontHaveLabel setHidden:YES];
                        [self.messageImageView setHidden:YES];
                        [userListTable setHidden:NO];
                    }
                    else{
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [self.dontHaveLabel setHidden:NO];
                        [self.messageImageView setHidden:NO];
                        [userListTable setHidden:YES];

                    }
                }
                else {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

@end
