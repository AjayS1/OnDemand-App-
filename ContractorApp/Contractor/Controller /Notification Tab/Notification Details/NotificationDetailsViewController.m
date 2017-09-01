
//  NotificationDetailsViewController.m
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "NotificationDetailsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "DateDetailsViewController.h"
#import "OnDemandDateRequestViewController.h"
#import "NotificationTableViewCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ServerRequest.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "AppDelegate.h"
@interface NotificationDetailsViewController () {
    NSMutableArray *notificationDatailsArray;
    SingletonClass *sharedInstance;
}

@end

@implementation NotificationDetailsViewController
@synthesize notificationType;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    sharedInstance = [SingletonClass sharedInstance];
    notificationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    notificationDetailsLbl.text = self.notificationMessageStr;
    notificationDetailsLbl.lineBreakMode = NSLineBreakByWordWrapping;
    notificationDetailsLbl.numberOfLines = 0;
    [notificationDetailsLbl sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [self getNotificationListDetailsApiCall];
    
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
    }
    //jhfjdghjkhjkhjkhjkhjkhjhjhjkhjkhjhjkhjkhjkhjkdfsafdfdfsdsdsfdfsjjhjhjjkjkhjkhjhjkdddffddfdfshjjjhjkhjhjhjkjhkdfsjkhjkhjkjdsfdfsdfsdfsjkjhjdfdfdfshjkjkhjhjkhjkjjhhjdfsjkhjkjhdfsjkhjhjdfsjkjkhjkdfshjhjkdfshjkhjdfshjkjkdshjkhjkdfsfhjkjkdfshjkjdsfhjkjkjdfshjkjkdfshjkhjkdfsfhjkjdfsfhjkjkhdfshjkhjkdfhjhjkdfshjkjhdsfhjkjdfshjkjdshjjkdsfhjkjdsfhjkjhdfshjkjhddfshjkds
    else {
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 10;
    return  [notificationDatailsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    
    NSString *imageData = [[notificationDatailsArray objectAtIndex:indexPath.row]objectForKey:@"PicUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageData];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    cell.nameLbl.text = [[notificationDatailsArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
    cell.nameLbl.lineBreakMode = NSLineBreakByWordWrapping;
    cell.nameLbl.numberOfLines = 0;
    [cell.nameLbl sizeToFit];
    cell.dateLbl.hidden = YES;
    cell.messageLbl.text = [[notificationDatailsArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getNotificationListDetailsApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&TypeID=%@&MaxID=%@",APIReadNotificationApiCall,userIdStr,@"1",self.maxIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                }
                else {
                    //  [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
    }];
}

@end
