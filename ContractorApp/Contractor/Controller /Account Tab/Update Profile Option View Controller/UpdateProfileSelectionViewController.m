
//  UpdateProfileSelectionViewController.m
//  Customer
//  Created by Deepak on 7/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "UpdateProfileSelectionViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "AppDelegate.h"

@interface UpdateProfileSelectionViewController ()
{
    NSInteger selectedIndex;
    SingletonClass *sharedInstance;
    NSInteger lastCount;
}

@end

@implementation UpdateProfileSelectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    sharedInstance = [SingletonClass sharedInstance];
    updateProfileTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    updateProfileDataArray = [[NSMutableArray alloc]init];
    commonArray = [[NSMutableArray alloc]init];
    titleLabel.text = [self.titleStr uppercaseString];
    if([self.titleStr isEqualToString:@"Language"])
    {
        doneButton.hidden = NO;
    }
    else
    {
        doneButton.hidden = YES;
    }
    cellSelected = [NSMutableArray array];
    self.languageIdArray = [[NSMutableArray alloc]init];
    
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
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:@"checkSignalRReqest"
    //                                                  object:nil];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
    
}


- (void)setLanguageData {
    
    NSMutableDictionary *englanguageDict = [[NSMutableDictionary alloc]init];
    [englanguageDict setObject:@"English" forKey:@"Value"];
    [englanguageDict setObject:@"1" forKey:@"ID"];
    NSMutableDictionary *spanlanguageDict = [[NSMutableDictionary alloc]init];
    [spanlanguageDict setObject:@"Spanish" forKey:@"Value"];
    [spanlanguageDict setObject:@"2" forKey:@"ID"];
    NSMutableDictionary *frenchlanguageDict = [[NSMutableDictionary alloc]init];
    [frenchlanguageDict setObject:@"French" forKey:@"Value"];
    [frenchlanguageDict setObject:@"3" forKey:@"ID"];
    NSMutableDictionary *dutchlanguageDict = [[NSMutableDictionary alloc]init];
    [dutchlanguageDict setObject:@"Dutch" forKey:@"Value"];
    [dutchlanguageDict setObject:@"4" forKey:@"ID"];
    NSMutableDictionary *chineselanguageDict = [[NSMutableDictionary alloc]init];
    [chineselanguageDict setObject:@"Chinese" forKey:@"Value"];
    [chineselanguageDict setObject:@"5" forKey:@"ID"];
    NSMutableDictionary *italianlanguageDict = [[NSMutableDictionary alloc]init];
    [italianlanguageDict setObject:@"Italian" forKey:@"Value"];
    [italianlanguageDict setObject:@"6" forKey:@"ID"];
    NSMutableDictionary *portugeselanguageDict = [[NSMutableDictionary alloc]init];
    [portugeselanguageDict setObject:@"Portugese" forKey:@"Value"];
    [portugeselanguageDict setObject:@"7" forKey:@"ID"];
    NSMutableDictionary *japaneselanguageDict = [[NSMutableDictionary alloc]init];
    [japaneselanguageDict setObject:@"Japanese" forKey:@"Value"];
    [japaneselanguageDict setObject:@"8" forKey:@"ID"];
    NSMutableDictionary *koreanlanguageDict = [[NSMutableDictionary alloc]init];
    [koreanlanguageDict setObject:@"Korean" forKey:@"Value"];
    [koreanlanguageDict setObject:@"9" forKey:@"ID"];
    NSMutableDictionary *russianlanguageDict = [[NSMutableDictionary alloc]init];
    [russianlanguageDict setObject:@"Russian" forKey:@"Value"];
    [russianlanguageDict setObject:@"10" forKey:@"ID"];
    NSMutableDictionary *nederlandslanguageDict = [[NSMutableDictionary alloc]init];
    [nederlandslanguageDict setObject:@"Nederlands" forKey:@"Value"];
    [nederlandslanguageDict setObject:@"11" forKey:@"ID"];
    
    languageDataArray = [[NSMutableArray alloc]initWithObjects:englanguageDict,spanlanguageDict,frenchlanguageDict,dutchlanguageDict,chineselanguageDict,italianlanguageDict,portugeselanguageDict,japaneselanguageDict,koreanlanguageDict,russianlanguageDict,nederlandslanguageDict, nil];
    
    
    //   [cellSelected addObject:indexPath];
    
    
    NSUInteger countValue = 0;
    
    for(NSDictionary *dictt in languageDataArray)
    {
        
        NSString *strr = [dictt valueForKey:@"Value"];
        
        [commonArray addObject:strr];
        
        
        NSArray *dataArray = [self.selectedIndexxStr componentsSeparatedByString:@","];
        for(NSString *langStr in dataArray) {
            NSString *formateedString = [langStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            
            if([strr isEqualToString:formateedString])
            {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                
                NSDictionary *dataDict = [languageDataArray objectAtIndex:countValue];
                //bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                NSString *strId = [dataDict valueForKey:@"ID"];
                [self.languageIdArray addObject:strId];
                
                [cellSelected addObject:path];
                
                
            }
        }
        
        countValue++;
        
    }
    
}


- (void)setsmokingData {
    
    NSMutableDictionary *nonSmokerDict = [[NSMutableDictionary alloc]init];
    [nonSmokerDict setObject:@"Non Smoker" forKey:@"Value"];
    [nonSmokerDict setObject:@"1" forKey:@"ID"];
    NSMutableDictionary *lightSmokerDict = [[NSMutableDictionary alloc]init];
    [lightSmokerDict setObject:@"Light Smoker" forKey:@"Value"];
    [lightSmokerDict setObject:@"2" forKey:@"ID"];
    NSMutableDictionary *heavySmokerDict = [[NSMutableDictionary alloc]init];
    [heavySmokerDict setObject:@"Heavy Smoker" forKey:@"Value"];
    [heavySmokerDict setObject:@"3" forKey:@"ID"];
    smokingDataArray = [[NSMutableArray alloc]initWithObjects:nonSmokerDict,lightSmokerDict,heavySmokerDict,nil];
    
    for(NSDictionary *dictt in smokingDataArray)
    {
        NSString *strr = [dictt valueForKey:@"Value"];
        [commonArray addObject:strr];
        if([commonArray containsObject:self.selectedIndexxStr])
        {
            NSInteger index = [commonArray indexOfObject:self.selectedIndexxStr];
            selectedIndex = index;
        }
    }
}

- (void)setdrinkingData {
    
    NSMutableDictionary *nonDrinkDict = [[NSMutableDictionary alloc]init];
    [nonDrinkDict setObject:@"Non Drinker" forKey:@"Value"];
    [nonDrinkDict setObject:@"1" forKey:@"ID"];
    NSMutableDictionary *lightDrinkDict = [[NSMutableDictionary alloc]init];
    [lightDrinkDict setObject:@"Social Drinker" forKey:@"Value"];
    [lightDrinkDict setObject:@"2" forKey:@"ID"];
    NSMutableDictionary *heavyDrinkDict = [[NSMutableDictionary alloc]init];
    [heavyDrinkDict setObject:@"Heavy Drinker" forKey:@"Value"];
    [heavyDrinkDict setObject:@"3" forKey:@"ID"];
    drinkingDataArray = [[NSMutableArray alloc]initWithObjects:nonDrinkDict,lightDrinkDict,heavyDrinkDict,nil];
    
    for(NSDictionary *dictt in drinkingDataArray)
    {
        NSString *strr = [dictt valueForKey:@"Value"];
        
        [commonArray addObject:strr];
        
        if([commonArray containsObject:self.selectedIndexxStr])
        {
            NSInteger index = [commonArray indexOfObject:self.selectedIndexxStr];
            selectedIndex = index;
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    if([self.titleStr isEqualToString:@"Language"])
    {
        [self setLanguageData];
        
    } else if([self.titleStr isEqualToString:@"Smoking"]) {
        [self setsmokingData];
    } else if([self.titleStr isEqualToString:@"Drinking"]) {
        [self setdrinkingData];
    } else {
        
        [self fetchGetProfileDataApiCall];
        
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
    
    if([self.titleStr isEqualToString:@"Language"])
    {
        return languageDataArray.count;
    }
    else if([self.titleStr isEqualToString:@"Smoking"])
    {
        return smokingDataArray.count;
    }
    else if([self.titleStr isEqualToString:@"Drinking"])
    {
        return drinkingDataArray.count;
    }
    else
    {
        return updateProfileDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell;
    
    cell = nil;
    
    if (cell == nil) {
        
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    NSDictionary *dataDictionary;
    if([self.titleStr isEqualToString:@"Language"])
    {
        lastCount = languageDataArray.count-1;
      
        dataDictionary = [languageDataArray objectAtIndex:indexPath.row];
        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else if([self.titleStr isEqualToString:@"Smoking"])
    {
        dataDictionary = [smokingDataArray objectAtIndex:indexPath.row];
        lastCount = smokingDataArray.count-1;

        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else if([self.titleStr isEqualToString:@"Drinking"])
    {
        dataDictionary = [drinkingDataArray objectAtIndex:indexPath.row];
        lastCount = drinkingDataArray.count-1;

        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else
    {
        NSDictionary *dataDictionary = [updateProfileDataArray objectAtIndex:indexPath.row];
        lastCount = updateProfileDataArray.count-1;

        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    
    
    if([self.titleStr isEqualToString:@"Language"]) {
        
        if ([cellSelected containsObject:indexPath])
        {
            cell.accessoryView = imageView;
        }
        else
        {
            cell.accessoryView = NULL;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
    }
    else {
        
        if(indexPath.row == selectedIndex) {
            
            cell.accessoryView = imageView;
        }
        else {
            
            cell.accessoryView = NULL;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.row == lastCount) {
     //   [cell.seperatorLabelValue setHidden:YES];
    }
    else{
       // [cell.seperatorLabelValue setHidden:NO];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dataDict;
    selectedIndex = indexPath.row;
    
    if ([self.titleStr isEqualToString:@"Language"]) {
        
        dataDict = [languageDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        NSString *strId = [dataDict valueForKey:@"ID"];
        
        if ([cellSelected containsObject:indexPath]) {
            
            [cellSelected removeObject:indexPath];
            
            NSUInteger countValue = 0;
            
            NSArray *compareArray = [self.languageIdArray copy];
            
            for(NSString *idStr in compareArray)
            {
                if([strId isEqualToString:idStr])
                {
                    [self.languageIdArray removeObjectAtIndex:countValue];
                }
                else{
                    countValue++;
                }
            }
        }
        else
        {
            [cellSelected addObject:indexPath];
            
            [self.languageIdArray addObject:strId];
        }
        
        bodyTypeIdStr  = [self.languageIdArray componentsJoinedByString:@","];
        NSLog(@"%@",bodyTypeIdStr);
        
        [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        
    } else if ([self.titleStr isEqualToString:@"Smoking"]) {
        
        dataDict = [smokingDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        [self fetchchangeProfileDataApiCall];
    }
    else if ([self.titleStr isEqualToString:@"Drinking"])
    {
        dataDict = [drinkingDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        [self fetchchangeProfileDataApiCall];
    }
    else
    {
        dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        [self fetchchangeProfileDataApiCall];
    }
    
    [updateProfileTable reloadData];
}


#pragma mark-- Get ProfileData API Call

-(void)fetchGetProfileDataApiCall
{
    
    NSString *dataTypestr;
    if([self.titleStr isEqualToString:@"Body Type"])
    {
        dataTypestr= @"MasterBodyTypes";
    }
    else if ([self.titleStr isEqualToString:@"Ethnicity"])
    {
        dataTypestr= @"MasterEthnicities";
    }
    else if ([self.titleStr isEqualToString:@"Hair Color"])
    {
        dataTypestr= @"MasterHairColors";
    }
    else if ([self.titleStr isEqualToString:@"Eye Color"])
    {
        dataTypestr= @"MasterEyeColors";
    }
    else if ([self.titleStr isEqualToString:@"Education"])
    {
        dataTypestr= @"MasterEducations";
    }
    else if ([self.titleStr isEqualToString:@"Height"])
    {
        dataTypestr= @"MasterHeights";
    }
    else if ([self.titleStr isEqualToString:@"Weight"])
    {
        dataTypestr= @"MasterWeights";
    }
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]initWithObjectsAndKeys:dataTypestr,@"AttributeName",nil];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    NSString *urlString ;
    
    if ([self.titleStr isEqualToString:@"Height"]  ) {
        NSString *userIdString = sharedInstance.userId;
        NSString *urlstrr=[NSString stringWithFormat:@"%@?UserID=%@",APIUpdateProfileDataForSearch,userIdString];
        
        [ServerRequest requestWithUrlQA:urlstrr withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            [ProgressHUD dismiss];
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                    updateProfileDataArray = [pushSettingsDictionary objectForKey:@"MasterValues"];
                    NSString *selecteString;
                    if ([sharedInstance.strUnitType isEqualToString:@"1"]) {
                        selecteString = [NSString stringWithFormat:@"%@",self.selectedIndexxStr];
                    }
                    else{
                        selecteString = [NSString stringWithFormat:@"%@",self.selectedIndexxStr];
                    }
                    for(NSDictionary *dictt in updateProfileDataArray)
                    {
                        NSString *strr = [dictt valueForKey:@"Value"];
                        [commonArray addObject:strr];
                        if([commonArray containsObject:selecteString])
                        {
                            NSInteger index = [commonArray indexOfObject:selecteString];
                            selectedIndex = index;
                        }
                    }
                    
                    [updateProfileTable reloadData];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
    else{
        urlString = APIUpdateProfileData;
        NSLog(@"Api Url %@",urlString);
        [ServerRequest requestWithUrlQA:urlString withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            
            [ProgressHUD dismiss];
            
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                    updateProfileDataArray = [pushSettingsDictionary objectForKey:@"MasterValues"];
                    
                    for(NSDictionary *dictt in updateProfileDataArray)
                    {
                        NSString *strr = [dictt valueForKey:@"Value"];
                        
                        [commonArray addObject:strr];
                        
                        if([commonArray containsObject:self.selectedIndexxStr])
                        {
                            NSInteger index = [commonArray indexOfObject:self.selectedIndexxStr];
                            selectedIndex = index;
                        }
                    }
                    
                    [updateProfileTable reloadData];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
    
}



#pragma mark--  Change profileData API

-(void)fetchchangeProfileDataApiCall
{
    // NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    
    NSString *userIdStr = sharedInstance.userId;
    
    NSString *dataTypestr;
    if([self.titleStr isEqualToString:@"Body Type"])
    {
        dataTypestr= @"BodyType";
    }
    else if ([self.titleStr isEqualToString:@"Ethnicity"])
    {
        dataTypestr= @"Enthnicity";
    }
    else if ([self.titleStr isEqualToString:@"Hair Color"])
    {
        dataTypestr= @"HairColor";
    }
    else if ([self.titleStr isEqualToString:@"Eye Color"])
    {
        dataTypestr= @"EyeColor";
    }
    else if ([self.titleStr isEqualToString:@"Language"])
    {
        dataTypestr= @"Language";
    }
    else if ([self.titleStr isEqualToString:@"Smoking"])
    {
        dataTypestr= @"Smoking";
    }
    else if ([self.titleStr isEqualToString:@"Drinking"])
    {
        dataTypestr= @"Drinking";
    }
    else if ([self.titleStr isEqualToString:@"Education"])
    {
        dataTypestr= @"Education";
    }
    else if ([self.titleStr isEqualToString:@"Height"])
    {
        dataTypestr = @"Height";
    }
    else if ([self.titleStr isEqualToString:@"Weight"])
    {
        dataTypestr = @"Weight";
    }
    
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,dataTypestr,bodyTypeIdStr];
    
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
            {
                
                if ([self.titleStr isEqualToString:@"Language"])
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
    
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([self.titleStr isEqualToString:@"Language"])
    {
        [self fetchchangeProfileDataApiCall];
        //  [updateProfileTable reloadData];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
