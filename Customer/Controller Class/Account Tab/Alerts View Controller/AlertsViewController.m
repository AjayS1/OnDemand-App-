
//  AlertsViewController.m
//  Customer
//  Created by Jamshed Ali on 14/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AlertsViewController.h"

@interface AlertsViewController () {
    
    NSMutableArray *dataArray;
    SingletonClass *sharedInstance;
}
@property (weak, nonatomic) IBOutlet UILabel *dontHaveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;

@end

@implementation AlertsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    userAlertDataArray = [[NSMutableArray alloc]init];
    dataArray = [[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    alertTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.dontHaveLabel setHidden:YES];
    [self.alertImageView setHidden:YES];
    [self fetchAlertListApiData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
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
    if (userAlertDataArray.count) {
        return  userAlertDataArray.count;
        
    }
    return 0;
    // return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatUserTableViewCell *cell;
    cell = (ChatUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chat"];
    
    NSMutableDictionary *dataDictionary = [userAlertDataArray objectAtIndex:indexPath.row];
    cell.nameLbl.text = [dataDictionary valueForKey:@"Name"];
    cell.dateLbl.text = @"";
    
    cell.messageLbl.text = [NSString stringWithFormat:@"%@ | %@ | %@ ",[dataDictionary valueForKey:@"Ethnicity"],[dataDictionary valueForKey:@"Age"],[dataDictionary valueForKey:@"Height"]];
    
    NSURL *imageUrl = [NSURL URLWithString:[dataDictionary valueForKey:@"PicUrl"]];
    [cell.userImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"user_default"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //    [cell.userImageView sd_setImageWithURL:imageUrl
    //                          placeholderImage:[UIImage imageNamed:@"user_default"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dataDictionary = [userAlertDataArray objectAtIndex:indexPath.row];

    NSString *contractorId = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"ID"]];
  //  NSString *isOfflinevlaue = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"isOnline"]];
    ProfileDetailsViewController *profileDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"contractorProfile"];
    profileDetailsView.self.contractorIdStr = contractorId;
//    if ([isOfflinevlaue isEqualToString:@"False"]) {
//        profileDetailsView.self.isOnlineStr = @"0";
//    }
//    else
//    {
//        profileDetailsView.self.isOnlineStr = @"1";
//    }
    //profileDetailsView.isOnlineStr = isOfflinevlaue;
    [self.navigationController pushViewController:profileDetailsView animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        //        [[AlertView sharedManager] presentAlertWithTitle:@"Alert!" message:@"Are you sure you want to delete this user from alert list."
        //                                     andButtonsWithTitle:@[@"No",@"Yes"] onController:self
        //                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
        //                                               if ([buttonTitle isEqualToString:@"Yes"]) {
        
        NSString *userIdStr = sharedInstance.userId;
        
        NSMutableDictionary *dataDictionary = [userAlertDataArray objectAtIndex:indexPath.row];
        
        NSString *toUserIdStr = [dataDictionary valueForKey:@"ID"];
        
        NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@",APIContractorDeleteFormAlertList,userIdStr,toUserIdStr];
        
        NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            
            [ProgressHUD dismiss];
            
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSMutableArray *tempArray = [userAlertDataArray mutableCopy];
                    
                    [tempArray removeObjectAtIndex:indexPath.row];
                    
                    userAlertDataArray = [tempArray mutableCopy];
                    
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    if (userAlertDataArray.count) {
                        [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                        [alertTableView setHidden:NO];

                        [self.dontHaveLabel setHidden:YES];
                        [self.alertImageView setHidden:YES];
                    }
                    else{
                        [self.view setBackgroundColor:[UIColor whiteColor]];
                        [alertTableView setHidden:YES];

                        [self.dontHaveLabel setHidden:NO];
                        [self.alertImageView setHidden:NO];
                    }
                    
                    [alertTableView reloadData];
                    
                    
                } else {
                    
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
            //                                                   }];
            //                                               }
            // NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
        }];
        
    }
}



#pragma mark-- AlertList API

- (void)fetchAlertListApiData {
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@",APIContractorAlertList,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *resultDict = [responseObject objectForKey:@"result"];
                
                userAlertDataArray =[[resultDict objectForKey:@"UserAlertList"] mutableCopy];
                if (userAlertDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [self.alertImageView setHidden:YES];
                    [alertTableView setHidden:NO];

                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [self.alertImageView setHidden:NO];
                    [alertTableView setHidden:YES];

                }                [alertTableView reloadData];
                
            }
            
            else if (([[responseObject objectForKey:@"StatusCode"] intValue] == 2)){
                if (userAlertDataArray.count) {
                    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
                    [self.dontHaveLabel setHidden:YES];
                    [alertTableView setHidden:NO];
                    [self.alertImageView setHidden:YES];
                }
                else{
                    [self.view setBackgroundColor:[UIColor whiteColor]];
                    [self.dontHaveLabel setHidden:NO];
                    [alertTableView setHidden:YES];
                    [self.alertImageView setHidden:NO];
                }
                
            }
            else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        } else {
            
            NSLog(@"Error");
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
