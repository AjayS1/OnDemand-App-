
//  NotificationDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "NotificationDetailsViewController.h"

@interface NotificationDetailsViewController () {
    
    NSMutableArray *notificationDataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
}

@end

@implementation NotificationDetailsViewController
@synthesize maxIdStr,idStr,notificationMessageStr;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.tabBarController.tabBar setHidden:YES];
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    
    notificationDataArray = [[NSMutableArray alloc]init];
    
    notificationDetailsLbl.text = self.notificationMessageStr;
    notificationDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    notificationDetailsLbl.numberOfLines = 0;
    [notificationDetailsLbl sizeToFit];
    
    notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //   http://ondemandapi.flexsin.in/API/Account/ListNotificationDeletebyNotificationID?userID=Cu009fe53&TypeID=1&ID=23
    
    [self notificationDetailsApiCall];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
}

- (void)notificationDetailsApiCall {
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&TypeID=%@&MaxID=%@",APIReadNotificationApiCall,userIdStr,@"1",self.maxIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        else {
            NSLog(@"Error");
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
    // return 10;
    return  [notificationDataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chat"];
    NSMutableDictionary *dataDictionary = [notificationDataArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = [dataDictionary valueForKey:@"Name"];
    cell.dateLbl.text = [dataDictionary valueForKey:@"Time"];
    cell.messageLbl.text = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Description"]];
    NSURL *imageUrl = [NSURL URLWithString:[dataDictionary valueForKey:@"PicUrl"]];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableDictionary *dataDictionary = [notificationDataArray objectAtIndex:indexPath.row];
        NSString *toUserIdStr = [dataDictionary valueForKey:@"ID"];
        NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&TypeID=%@&ID=%@",APIDeleteNotificationApiCall,userIdStr,@"1",toUserIdStr];
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error)
            {
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    NSMutableArray *tempArray = [notificationDataArray mutableCopy];
                    [tempArray removeObjectAtIndex:indexPath.row];
                    notificationDataArray = [tempArray mutableCopy];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
