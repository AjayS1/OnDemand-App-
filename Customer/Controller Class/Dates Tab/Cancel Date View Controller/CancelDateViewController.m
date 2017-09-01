
//  CancelDateViewController.m
//  Customer
//  Created by Jamshed Ali on 27/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.

#import "CancelDateViewController.h"

@interface CancelDateViewController () {
    
    NSArray *cancelData;
    NSMutableArray *cancelDataArray;
    NSString *issueIdStr;
    NSString *totalDistanceStrInMeter;
    NSString *totalDistanceStr;
    NSString *totalTimeStr;
    NSString *dateCountStr;
    NSString *messageCountStr;
    NSString *notificationsCountStr;
    SingletonClass *sharedInstance;
    NSString *bankDetailsURL;

}

@property (strong, nonatomic) IBOutlet UIButton *sublitButton;
@end

@implementation CancelDateViewController
@synthesize dateIdStr;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [cancelDateTableView.tableFooterView setHidden:YES];

    issueIdStr = @"";
    sharedInstance = [SingletonClass sharedInstance];
    cancelDataArray = [[NSMutableArray alloc]init];
    totalDistanceStr  = @"";
    totalTimeStr  = @"";
    [self getDateIssueListApiCall];
    [self googleDistanceTimeApiCall];
}

- (void)getDateIssueListApiCall {
    
    NSMutableDictionary *params;
    if ([self.buttonStatus isEqualToString:@"1"] || [self.dateTypeStr isEqualToString:@"3"]) {
        //  params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateCustomerAfterDateAccept",@"AttributeName",nil];
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateCustomerAfterDateOntheWay",@"AttributeName",nil];
    }
    
    else if ([self.buttonStatus isEqualToString:@"2"]|| [self.dateTypeStr isEqualToString:@"16"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateCustomerAfterDateOntheWay",@"AttributeName",nil];
    }
    
    else if ([self.buttonStatus isEqualToString:@"3"] || [self.dateTypeStr isEqualToString:@"7"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateCustomerAfterDateArrived",@"AttributeName",nil];
    }
    
    else if ([self.buttonStatus isEqualToString:@"4"]|| [self.dateTypeStr isEqualToString:@"8"]){
        params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"CancelDateCustomerAfterDateStart",@"AttributeName",nil];
    }
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIDateIssueList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                cancelData = [[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"];
                cancelDataArray = [SingletonClass parseCancelDateDetails:[[responseObject objectForKey:@"result"]objectForKey:@"MasterValues"]];
                if (cancelDataArray.count) {
                    [_sublitButton setEnabled:YES];
                    [cancelDateTableView.tableFooterView setHidden:NO];
                }
                else
                {
                    [_sublitButton setEnabled:NO];
                    [cancelDateTableView.tableFooterView setHidden:YES];
                }
                [cancelDateTableView reloadData];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (cancelDataArray.count) {
        return cancelDataArray.count;
    }
    return cancelData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    UIImageView *imageViewOther = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_arrow.png"]];
    [imageViewOther setFrame:CGRectMake(0, 0, 15, 15)];
    [cell.textLabel setFrame:CGRectMake(cell.imageView.frame.origin.x+cell.imageView.frame.size.width+10, 0,cell.contentView.frame.size.width- (cell.imageView.frame.origin.x+cell.imageView.frame.size.width)*2, 50)];
    //back_arrow
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[cancelData objectAtIndex:indexPath.row] objectForKey:@"Value"]];
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
            issueIdStr = customeObj.cancelDateID;
        }
        else{
            customeObj.isDateCancel = NO;
            issueIdStr = @"";
        }
    }
    [cancelDateTableView reloadData];
    // issueIdStr = [NSString stringWithFormat:@"%@",[[cancelData objectAtIndex:indexPath.row] objectForKey:@"ID"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButtonClicked:(id)sender {
    
    if (sharedInstance.isFromCancelDateRequest)
    {
        [self tabBarCountApiCall];
        sharedInstance.isFromCancelDateRequest = NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
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
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
    
    
}

#pragma mark Date Cancel Submit Method Call
- (IBAction)submitButtonClicked:(id)sender
{
    [self callAPiForCancel];
}

-(void)callSubmitMethodeForCancelDate{
    if (cancelDataArray.count) {
        if ([issueIdStr isEqualToString:@""]) {
            [CommonUtils showAlertWithTitle:@"Alert!" withMsg:@"Please select the date issue." inController:self];
        }
        else {
            NSString *userIdStr = sharedInstance.userId;
            //   //http://ondemandapinew.flexsin.in/API/Contractor/CanceleDate?userID=Cr007e28b&DateID=Date31427&ReasonID=2&isCancellationFeeApplied=0&cancellationFee
            NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&DateID=%@&ReasonID=%@&isCancellationFeeApplied=%@&cancellationFee=%@",APICancelDate,userIdStr,self.dateIdStr,issueIdStr,sharedInstance.IsCancellationFeeAllowed,sharedInstance.cancellationFee];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bankDetailsURL = encodedUrl;
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                
                if(!error){
                    
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
//                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
//                                                     andButtonsWithTitle:@[@"Ok"] onController:self
//                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
//                                                               if ([buttonTitle isEqualToString:@"Ok"]) {
                                                                   if (self.isFromRequestNow) {
                                                                       [self tabBarControllerClass];
                                                                   }
                                                                   else{
                                                                       DatesViewController *datesView = [self.storyboard instantiateViewControllerWithIdentifier:@"dates"];
                                                                       datesView.isFromDateDetails = NO;
                                                                       [self.navigationController pushViewController:datesView animated:NO];
                                                                   }
//                                                               }
//                                                           }];
                    }
                    else if ([[responseObject objectForKey:@"StatusCode"] intValue] ==2){
                        CreditCardDeclinedVC *declinedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CreditCardDeclinedVC"];
                        declinedVC.creditCradDeclinedMsg = [responseObject objectForKey:@"Message"];
                        // declinedVC.dateDetailsDictionary = dataDictionary;
                        declinedVC.bankDetailsWithUrl = bankDetailsURL;
                        declinedVC.dateIDStr = self.dateIdStr;
                        declinedVC.totalAmountToBePaid = sharedInstance.cancellationFee;
                        declinedVC.isFromCaneclDateByCustomer = YES;
                        sharedInstance.isFromCaneclDateByCustomer = YES;
                        //                        if (self.isFromLoginView) {
                        //                            declinedVC.isFromLoginCreditView = YES;
                        //                        }
                        //                        else{
                        declinedVC.isFromLoginCreditView = NO;
                        //}
                        [self.navigationController pushViewController:declinedVC animated:YES];
                    }
                    else {
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                } else {
                    
                    NSLog(@"Error");
                }
            }
             ];
        }
    }

}
-(void)callAPiForCancel{
    
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
                if ( ([sharedInstance.cancellationFee integerValue] == 0)) {
                    if ([_buttonStatus isEqualToString:@"3"]) {
                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"Yes"]) {
                        if ([self.dateTypeStr isEqualToString:@"1"]) {
                            //[timer invalidate];
                            [self callSubmitMethodeForCancelDate];
                        }
                        else {
                            [self callSubmitMethodeForCancelDate];
                            
                        }
                             }}];
                        
                    }
                    else{
                        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                           dismissedWith:^(NSInteger index, NSString *buttonTitle)
                         {
                             if ([buttonTitle isEqualToString:@"Yes"]) {
                                 
                                 if ([_buttonStatus isEqualToString:@"0"]) {
                                     
                                     // http://ondemandapiqa.flexsin.in/API/Customer/DeclineDate
                                     NSString    * urlString = [NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDeclineDate,sharedInstance.userId,self.dateIdStr];
                                     
                                     NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                     [ProgressHUD show:@"Please wait..." Interaction:NO];
                                     [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                                         NSLog(@"response object Get UserInfo List %@",responseObject);
                                         [ProgressHUD dismiss];
                                         if(!error){
                                             
                                             NSLog(@"Response is --%@",responseObject);
                                             if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                 [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                                              andButtonsWithTitle:@[@"OK"] onController:self
                                                                                    dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                                  {
                                                      if ([buttonTitle isEqualToString:@"OK"]) {
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                          
                                                      }}];
                                             }
                                             else {
                                                 [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                             }
                                         }
                                     }];
                                     
                                 }
                                 else {
                                     if ([self.dateTypeStr isEqualToString:@"1"]) {
                                         
                                         //[timer invalidate];
                                         
                                         [self callSubmitMethodeForCancelDate];

                                     }
                                     
                                     else {
                                         
                                         [self callSubmitMethodeForCancelDate];

                                         
                                     }
                                     // [self.navigationController popViewControllerAnimated:YES];
                                     
                                 }}
                         }];
                    }
                }
                else{
                    [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"Yes"]) {
                             
                             if ([_buttonStatus isEqualToString:@"0"]) {
                                 
                                 // http://ondemandapiqa.flexsin.in/API/Customer/DeclineDate
                                 NSString    * urlString = [NSString stringWithFormat:@"%@?userID=%@&DateID=%@",APIDeclineDate,sharedInstance.userId,self.dateIdStr];
                                 
                                 NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                 [ProgressHUD show:@"Please wait..." Interaction:NO];
                                 [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
                                     NSLog(@"response object Get UserInfo List %@",responseObject);
                                     [ProgressHUD dismiss];
                                     if(!error){
                                         
                                         NSLog(@"Response is --%@",responseObject);
                                         if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                             [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:[responseObject objectForKey:@"Message"]
                                                                          andButtonsWithTitle:@[@"OK"] onController:self
                                                                                dismissedWith:^(NSInteger index, NSString *buttonTitle)
                                              {
                                                  if ([buttonTitle isEqualToString:@"OK"]) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                      
                                                  }}];
                                         }
                                         else {
                                             [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                         }
                                     }
                                 }];
                             }
                             else
                             {
                                 if ([self.dateTypeStr isEqualToString:@"1"]) {
                                     //[timer invalidate];
                                     [self callSubmitMethodeForCancelDate];
                                     
                                 }
                                 
                                 else {
                                     [self callSubmitMethodeForCancelDate];
                                     
                                 }
                                 // [self.navigationController popViewControllerAnimated:YES];
                                 
                             }}
                     }];
                }
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
    } ];
}

#pragma mark-- Calculte Distance Time by Google api between Customer and Contractor

-(void)googleDistanceTimeApiCall {
    
    if([AFNetworkReachabilityManager sharedManager].reachable){
        
        NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        // get CLLocation fot both addresses
        CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:[latitudeStr doubleValue] longitude:[lonitudeStr doubleValue]];
        CLLocation *meetLocation = [[CLLocation alloc] initWithLatitude:[sharedInstance.latValueWhileCancelTheDate doubleValue] longitude:[sharedInstance.longValueWhileCancelTheDate doubleValue]];
        // calculate distance between them
        CLLocationDistance distance = [endLocation distanceFromLocation:meetLocation];
        NSLog(@"Distance %f",distance);
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/1609.344)]);
        
        if ([_addressCancelValue length]) {
            
            NSString *webServiceUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=false",sharedInstance.currentAddressStr,_addressCancelValue];
            NSString *encodedUrl = [webServiceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
            [requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
            requestSerializer.timeoutInterval = 300;
            manager.requestSerializer = requestSerializer;
            
            AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
            responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"charset=utf-8", @"application/json", nil];
            manager.responseSerializer = responseSerializer;
            [manager GET:encodedUrl parameters:nil
             
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     
                     NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     NSLog(@"Google Distance time == %@",jsonData);
                     
                     NSArray *routesArray = [jsonData objectForKey:@"routes"];
                     
                     if (routesArray.count>0) {
                         
                         NSArray *distanceTimeArray = [[routesArray objectAtIndex:0] objectForKey:@"legs"];
                         
                         totalDistanceStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"distance"]objectForKey:@"text"];
                         double distanceInMeter = (([totalDistanceStr doubleValue]*1000));
                         totalDistanceStrInMeter = [NSString stringWithFormat:@"%.1f",(distanceInMeter/1609.344)];
                         totalTimeStr = [[[distanceTimeArray objectAtIndex:0]objectForKey:@"duration"]objectForKey:@"text"];
                     }
                     else {
                         totalDistanceStrInMeter  = @"0";
                         totalTimeStr  = @"0";
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"network error:%@",error);
                     totalDistanceStrInMeter  = @"0";
                     totalTimeStr  = @"0";
                 }];
        }
        else {
            
            [ServerRequest networkConnectionLost];
        }
        
    }
}


@end
