
//  UserProfileViewController.m
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "UserProfileViewController.h"

@interface UserProfileViewController () {
    
    NSArray *titleArray;
    NSArray *dataArray;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    BOOL isBoldText;
       NSInteger lastCount;
    
}

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    titleArray = @[@"Screen Name",@"Height",@"Weight",@"Body Type",@"Ethnicity",@"Hair Color",@"Eye Color",@"Language",@"Smoking",@"Drinking",@"Education",@"About Me",@"My Interests"];
    profileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    dataArray = @[@"Mary Jolly",@"6 ft/in",@"100lbs",@"SSS",@"White",@"Black",@"Blue",@"English",@"Light Smoker",@"Social Drinker",@"M Tech",@"",@""];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [self fetchUserProfileApiData];
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
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell;
    cell = nil;
    if (cell == nil) {
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    }
    
    cell.nameLbl.adjustsFontSizeToFitWidth = NO;
    cell.nameLbl.text = [titleArray objectAtIndex:indexPath.row];
    
    cell.dateLbl.text = [userProfileDataArray objectAtIndex:indexPath.row];
 
    lastCount = titleArray.count-1;
    if (indexPath.row == lastCount) {
       // [cell.seperatorLabelValue setHidden:YES];
    }
    else{
        //[cell.seperatorLabelValue setHidden:NO];
    }

    if (indexPath.row == 1 || indexPath.row == 2 ||indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12) {
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    // indexPath.row == 0? cell.userInteractionEnabled = NO : YES ;
    if ([cell.nameLbl.text isEqualToString:@"Screen Name"]) {
        cell.userInteractionEnabled = NO;
        cell.accessoryType= UITableViewCellAccessoryNone;
        
    }
    else{
        cell.userInteractionEnabled = YES;
        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    //if (indexPath.row == 11 || indexPath.row == 12) {
    //  [cell.nameLbl setFont:[UIFont boldSystemFontOfSize:14.0]];
    // }
    
    //    if ([cell.nameLbl.text isEqualToString:@"I like..."] && indexPath.row==11) {
    //        [cell.nameLbl setFont:[UIFont boldSystemFontOfSize:15.0]];
    //    }
    //    else{
    //        [cell.nameLbl setFont:[UIFont systemFontOfSize:14.0]];
    //
    //    }
    //    if ([cell.nameLbl.text isEqualToString:@"I like when my date is..."] && indexPath.row==12 ) {
    //        [cell.nameLbl setFont:[UIFont boldSystemFontOfSize:15.0]];
    //    }
    //    else{
    //        [cell.nameLbl setFont:[UIFont systemFontOfSize:14.0]];
    //
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if((indexPath.row == 1) || (indexPath.row == 2) ||(indexPath.row == 3) || (indexPath.row == 4) || (indexPath.row == 5) || (indexPath.row == 6) || (indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 9) || (indexPath.row == 10)) {
        
        UpdateProfileSelectionViewController *profileView;
        profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
        
        NSString *str = [userProfileDataArray objectAtIndex:indexPath.row];
        profileView.selectedIndexxStr = str;
        
        switch (indexPath.row) {
            case 1:
                profileView.titleStr = @"Height";
                break;
            case 2:
                profileView.titleStr = @"Weight";
                break;
            case 3:
                profileView.titleStr = @"Body Type";
                break;
            case 4:
                profileView.titleStr = @"Ethnicity";
                break;
            case 5:
                profileView.titleStr = @"Hair Color";
                break;
            case 6:
                profileView.titleStr = @"Eye Color";
                break;
            case 7:
                profileView.titleStr = @"Language";
                break;
            case 8:
                profileView.titleStr = @"Smoking";
                break;
            case 9:
                profileView.titleStr = @"Drinking";
                break;
            case 10:
                profileView.titleStr = @"Education";
                break;
            case 11:
            default:
                break;
        }
        
        [self.navigationController pushViewController:profileView animated:YES];
        
    }
    else if((indexPath.row == 11) || (indexPath.row == 12)) {
        
        ProfileDateCommnetsViewController *profileView;
        profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"dateCommnets"];
        profileView.self.dateLikeMessageStr = [userProfileDataArray objectAtIndex:indexPath.row];
        switch (indexPath.row) {
            case 11:
                profileView.titleStr = @"Comment";
                break;
            case 12:
                profileView.titleStr = @"Date Comment";
                break;
            case 13:
            default:
                break;
        }
        
        [self.navigationController pushViewController:profileView animated:YES];
        
    } else if(indexPath.row == 0) {
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Username" message:@"Enter your username" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert addButtonWithTitle:@"Update"];
        [alert show];
        
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 1) {  //Login
        UITextField *username = [alertView textFieldAtIndex:0];
        NSLog(@"username: %@", username.text);
        
        if([username.text length]==0) {
            
            UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please insert the username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alrtShow show];
            
        } else {
            
            
            NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,@"DisplayName",username.text];
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForQAPurpose:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Get UserInfo List %@",responseObject);
                [ProgressHUD dismiss];
                if(!error){
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
                    {
                        
                        [self fetchUserProfileApiData];
                    }
                    else
                    {
                        
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    }
                }
            }];
            
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-- User Profile API Call

- (void)fetchUserProfileApiData {
    
    //   NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *urlstrr=[NSString stringWithFormat:@"%@?UserID=%@",APIAccountProfileInfo,userIdStr];
    NSString *encodedUrl = [urlstrr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    
    [ServerRequest requestWithUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Alert List %@",responseObject);
        
        [ProgressHUD dismiss];
        
        if(!error){
            
            NSLog(@"Response is --%@",responseObject);
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSDictionary *userProfileDictionary = [responseObject objectForKey:@"result"];
                NSString *heightConvertedValue ;
                NSString *heightValue = [userProfileDictionary objectForKey:@"Height"];
                NSString *languageValue = [userProfileDictionary objectForKey:@"Language"];
                if ([languageValue length] > 0) {
                    languageValue = [languageValue substringToIndex:[languageValue length] - 1];
                } else {
                    //no characters to delete... attempting to do so will result in a crash
                }
//                NSArray *languageArray = [languageValue componentsSeparatedByString:@","];
//                if (languageArray.count == 2) {
//                    languageValue = [languageArray objectAtIndex:0];
//                }
//                else  if ( (languageArray.count == 0)){
//                    languageValue = [userProfileDictionary objectForKey:@"Language"];
//
//                }
                heightConvertedValue = [NSString stringWithFormat:@"%@",heightValue];
                userProfileDataArray = [NSArray arrayWithObjects:[userProfileDictionary objectForKey:@"UserName"],heightConvertedValue,[userProfileDictionary objectForKey:@"Weight"],[userProfileDictionary objectForKey:@"BodyType"],[userProfileDictionary objectForKey:@"Enthnicity"],[userProfileDictionary objectForKey:@"HairColor"],[userProfileDictionary objectForKey:@"EyeColor"],languageValue,[userProfileDictionary objectForKey:@"Smoking"],[userProfileDictionary objectForKey:@"Drinking"],[userProfileDictionary objectForKey:@"Education"],[userProfileDictionary objectForKey:@"Description"],[userProfileDictionary objectForKey:@"MyDatePreferences"], nil];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LanguageSelectedTitle"];
                [[NSUserDefaults standardUserDefaults] setValue:[userProfileDictionary objectForKey:@"Language"] forKey:@"LanguageSelectedTitle"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [profileTableView reloadData];
                
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
        
    }];
}


@end
