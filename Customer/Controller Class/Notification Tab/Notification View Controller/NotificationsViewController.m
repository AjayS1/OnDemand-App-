
//  NotificationsViewController.m
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "NotificationsViewController.h"

@interface NotificationsViewController () {
    
    NSMutableArray *notificationDataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSDateFormatter *dateFormatter;
    NSInteger lastCount;
   
}

@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImageView;
@end

@implementation NotificationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    dateFormatter = [[NSDateFormatter alloc]init];
    notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.dontHaveLabel setHidden:YES];
    [self.notificationImageView setHidden:YES];
    NSLog(@"Ddate Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue);
    NSLog(@"Message Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue);
    NSLog(@"Notification Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue);
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    sharedInstance.refreshApiCallOrNotStr = @"yes";
    NSLog(@"viewWillAppear Ddate Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue);
    NSLog(@"viewWillAppear Message Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue);
    NSLog(@"viewWillAppear Notification Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue);
    
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
    
    [self notificationDetailsApiCall];
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
    
    [self apiCallRefreshScreen];
    
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
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
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

- (void)notificationDetailsApiCall {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",@"1",@"TypeID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIListNotificationDetailByTypeCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            [notificationDataArray removeAllObjects];
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                notificationDataArray = [[NSMutableArray alloc]init];
                NSDictionary *dataDic = [[responseObject objectForKey:@"result"] mutableCopy];
                notificationDataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                if (notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [notificationTableView setHidden:NO];

                    [self.notificationImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [self.notificationImageView setHidden:NO];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;

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
                [notificationTableView reloadData];

            }
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] == 0))
            {
                if (notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [notificationTableView setHidden:NO];

                    [self.notificationImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [self.notificationImageView setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [notificationTableView reloadData];
                    [[APPDELEGATE.tabBarC.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;
                    [[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue = nil;

                }
            }
            else {
                
                notificationDataArray = [[NSMutableArray alloc]init];
                [notificationTableView reloadData];
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
            
        } else {
            
            NSLog(@"Error");
        }
    }];
    
}

#pragma mark API Call - Refresh Screen when Notification Recevied
- (void)apiCallRefreshScreen {
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"UserID",@"1",@"TypeID",nil];
    [ServerRequest requestWithUrl:APIListNotificationDetailByTypeCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                notificationDataArray = [[NSMutableArray alloc]init];
                
                NSDictionary *dataDic = [[responseObject objectForKey:@"result"] mutableCopy];
                notificationDataArray = [[dataDic objectForKey:@"MasterValues"] mutableCopy];
                
                if (notificationDataArray.count) {
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

                }
                
                
                [notificationTableView reloadData];
                
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
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==0)){
                if (notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [notificationTableView setHidden:NO];

                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [notificationTableView setHidden:YES];

                    [self.notificationImageView setHidden:NO];
                }
            }
            
            else {
                
                notificationDataArray = [[NSMutableArray alloc]init];
                if (notificationDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [notificationTableView setHidden:NO];

                    [self.dontHaveLabel setHidden:YES];
                    [self.notificationImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [notificationTableView setHidden:YES];

                    [self.dontHaveLabel setHidden:NO];
                    [self.notificationImageView setHidden:NO];
                }
                [notificationTableView reloadData];
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
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
    
    if (notificationDataArray.count) {
        return  [notificationDataArray count];
    }
    else
    {
        return  0;
    }
    return  0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chat"];
    
    NSMutableDictionary *dataDictionary = [notificationDataArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = [dataDictionary valueForKey:@"Name"];
    NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [dataDictionary objectForKey:@"Time"]];
    NSArray *arrayOfReservationTime = [reserveTimeStr componentsSeparatedByString:@"."];
    NSString *deletedString = [arrayOfReservationTime objectAtIndex:0];
    NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:deletedString WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    if (WIN_WIDTH == 320) {
        [cell.dateLbl setFont:[UIFont systemFontOfSize:10]];
    }
    cell.dateLbl.text = [self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
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
    lastCount = notificationDataArray.count - 1;
    if (indexPath.row == lastCount) {
       // cell.sepeartorLabel.hidden = true;
    }
    else{
       // cell.sepeartorLabel.hidden = false;
        
    }
    return cell;
}

-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM dd, YYYY hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dataDictionary = [notificationDataArray objectAtIndex:indexPath.row];
    NSString *notficationIdStr = [dataDictionary valueForKey:@"ID"];
    NotificationDetailsViewController *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationsDetails"];
    notiView.self.notificationMessageStr =  [NSString stringWithFormat:@"%@",[[notificationDataArray objectAtIndex:indexPath.row] objectForKey:@"Description"]];
    notiView.self.maxIdStr = notficationIdStr;
    [self.navigationController pushViewController:notiView animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this notification?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   
                                                   NSMutableDictionary *dataDictionary = [notificationDataArray objectAtIndex:indexPath.row];
                                                   NSString *readNotificationStatus = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"isRead"]];
                                                   NSString *toUserIdStr = [dataDictionary valueForKey:@"ID"];
                                                   NSString *typeIdStr = [dataDictionary valueForKey:@"Type"];
                                                   NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&TypeID=%@&ID=%@",APIDeleteNotificationApiCall,userIdStr,typeIdStr,toUserIdStr];
                                                   NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object Get UserInfo List %@",responseObject);
                                                       [ProgressHUD dismiss];
                                                       if(!error){
                                                           
                                                           NSLog(@"Response is --%@",responseObject);
                                                           
                                                           if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                               NSMutableArray *tempArray = [notificationDataArray mutableCopy];
                                                               [tempArray removeObjectAtIndex:indexPath.row];
                                                               notificationDataArray = [tempArray mutableCopy];
                                                               [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                               
                                                               if (notificationDataArray.count)
                                                               {
                                                                   [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                                                                   [self.dontHaveLabel setHidden:YES];
                                                                   [self.notificationImageView setHidden:YES];
                                                                   [notificationTableView setHidden:NO];

                                                                   if ([readNotificationStatus isEqualToString:@"0"]) {
                                                                       
                                                                       NSLog(@"delete Ddate Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue);
                                                                       
                                                                       NSLog(@"delete Message Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:2] tabBarItem].badgeValue);
                                                                       
                                                                       NSLog(@"delete Notification Count===   %@",[[super.tabBarController.viewControllers objectAtIndex:3] tabBarItem].badgeValue);
                                                                       
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
                                                               else
                                                               {
                                                                   //                                                                   [self.view setBackgroundColor:[UIColor whiteColor]];
                                                                   //                                                                   [self.dontHaveLabel setHidden:NO];
                                                                   //                                                                   [self.notificationImageView setHidden:NO];
                                                                   //                                                                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                   [notificationTableView setHidden:YES];

                                                                   [self notificationDetailsApiCall];
                                                               }
                                                               
                                                               
                                                           } else {
                                                               
                                                               //                                                               [self.view setBackgroundColor:[UIColor whiteColor]];
                                                               //                                                               [self.dontHaveLabel setHidden:NO];
                                                               //                                                               [self.notificationImageView setHidden:NO];
                                                               [self notificationDetailsApiCall];
                                                               
                                                               
                                                               //                                                               [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                           }
                                                       }
                                                   }];
                                                   
                                               }
                                               // NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
                                           }];
        
        
        
        //    NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
        
    }
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//        UIView *cellContentView  = [cell contentView];
//        CGFloat rotationAngleDegrees = -10;
//        CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/270);
//        CGPoint offsetPositioning = CGPointMake(500, -20.0);
//        CATransform3D transform = CATransform3DIdentity;
//        transform = CATransform3DRotate(transform, rotationAngleRadians, -50.0, 0.0, 1.0);
//        transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, -50.0);
//        cellContentView.layer.transform = transform;
//        cellContentView.layer.opacity = 0.3;
//        
//        [UIView animateWithDuration:.100 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:.8 options:0 animations:^{
//            cellContentView.layer.transform = CATransform3DIdentity;
//            cellContentView.layer.opacity = 1;
//        } completion:^(BOOL finished) {}];
//    }
//}
@end
