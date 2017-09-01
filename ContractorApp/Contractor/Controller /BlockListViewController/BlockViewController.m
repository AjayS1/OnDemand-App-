//
//  BlockViewController.m
//  Contractor
//
//  Created by Aditi on 31/07/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "BlockViewController.h"
#import "SingletonClass.h"
#import "AppDelegate.h"
#import "Define.h"
#import "NotificationTableViewCell.h"
#import "AlertView.h"
@interface BlockViewController ()<UITableViewDelegate,UITableViewDataSource>{
        NSMutableArray *dataArray;
        SingletonClass *sharedInstance;
        NSString *userIdStr;
    }
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;


@end

@implementation BlockViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.tableDataArray = [[NSMutableArray alloc]init];
    [self.dontHaveLabel setHidden:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.favoriteImageView setHidden:YES];
    blockTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self fetchFavoritesUserListApiData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //Creating View
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    //Creating Label
    UILabel *lineView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    [headerView addSubview:lineView];
    //Creating Label
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableDataArray.count) {
        return self.tableDataArray.count;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NotificationTableViewCell *cell;
    cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell"];
    NSMutableDictionary *dataDictionary = [self.tableDataArray objectAtIndex:indexPath.row];
    if ([[dataDictionary valueForKey:@"Name"] isKindOfClass:[NSString class]]) {
        cell.nameLbl.text = [dataDictionary valueForKey:@"Name"];
    }
    else
    {
        cell.nameLbl.text = @"";
    }
    
    NSURL *imageUrl = [NSURL URLWithString:[dataDictionary valueForKey:@"PicUrl"]];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    [cell.userImageView sd_setImageWithURL:imageUrl
    //                          placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to unblock this user?"
                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               if ([buttonTitle isEqualToString:@"Yes"]) {
                                                   
                                                   NSString *userIdStr = sharedInstance.userId;
                                                   NSMutableDictionary *dataDictionary = [self.tableDataArray  objectAtIndex:indexPath.row];
                                                   NSString *toUserIdStr = [dataDictionary valueForKey:@"ID"];
                                                   NSString *urlstring=[NSString stringWithFormat:@"%@?userIDTO=%@&userIDFrom=%@",APIUnBlockUser,toUserIdStr,userIdStr];
                                                   NSString *encodedUrl = [urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                   [ProgressHUD show:@"Please wait..." Interaction:NO];
                                                   //http://doumeesApi.flexsin.in/API/Account/UnBlockUser?userIDTO="customerId"&userIDFrom="Contractorid"
                                                   [ServerRequest AFNetworkPostRequestUrl:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                                                       NSLog(@"response object delete Notification List %@",encodedUrl);
                                                       [ProgressHUD dismiss];
                                                       if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
                                                           // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
                                                           
                                                       }
                                                       else{
                                                           if(!error){
                                                               
                                                               NSLog(@"Response is --%@",responseObject);
                                                               if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                                                                   [self.tableDataArray removeAllObjects];
                                                                   NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                                                                   self.tableDataArray =[[resultDict objectForKey:@"BlockList"] mutableCopy];
                                                                   
                                                                   if (self.tableDataArray.count) {
                                                                       [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                                                                       [self.dontHaveLabel setHidden:YES];
                                                                       [self.favoriteImageView setHidden:YES];
                                                                       [blockTableView setHidden:NO];

                                                                   }
                                                                   else {
                                                                       [self.view setBackgroundColor:[UIColor whiteColor]];
                                                                       [self.dontHaveLabel setHidden:NO];
                                                                       [self.favoriteImageView setHidden:NO];
                                                                       [blockTableView setHidden:YES];
                                                                   }
                                                                   [blockTableView reloadData];
                                                               }
                                                               else {
                                                                   [blockTableView reloadData];
                                                                   
                                                                   [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                                                               }
                                                           }
                                                           [blockTableView reloadData];

                                                       }
                                                   }];
                                               }
                                           }];
        
    }
}

#pragma mark-- Favorites API

- (void)fetchFavoritesUserListApiData {
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userIdStr,@"userID",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlQA:APIBlockUserList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get favorites User List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                self.tableDataArray =[[resultDict objectForKey:@"BlockList"] mutableCopy];
                
                if (self.tableDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.favoriteImageView setHidden:YES];
                    [blockTableView setHidden:NO];

                }
                else {
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [self.favoriteImageView setHidden:NO];
                    [blockTableView setHidden:YES];

                }
                [blockTableView reloadData];
            }
            
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] ==2))
            {
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dontHaveLabel setHidden:NO];
                [self.favoriteImageView setHidden:NO];
                [blockTableView setHidden:YES];
            }
            
            else {
                [self.view setBackgroundColor:[UIColor whiteColor]];
                [self.dontHaveLabel setHidden:NO];
                [self.favoriteImageView setHidden:NO];
                [blockTableView setHidden:YES];
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
