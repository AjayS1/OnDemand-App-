//
//  UpdateProfileSelectionViewController.m
//  Customer
//
//  Created by Jamshed on 7/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "UpdateProfileSelectionViewController.h"

@interface UpdateProfileSelectionViewController () {
    
    NSInteger selectedIndex;
    SingletonClass *sharedInstance;
    NSString *userIdStr;
    NSMutableArray *getFilterDataArray;
    NSMutableArray *arrayOfLanguageData;
    NSMutableArray *arrayOfSmokingData;
    NSMutableArray *arrayOfDrinkingData;
    NSInteger lastCount;
}

@end

@implementation UpdateProfileSelectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    arOptions = [[NSMutableArray alloc] init];
    languageNameArray = [[NSMutableArray alloc] init];
    modelTypeNameArray = [[NSMutableArray alloc] init];
    modelTypeIdArray = [[NSMutableArray alloc] init];
    bodyTypeArray = [[NSMutableArray alloc] init];
    bodyTypeIdArray = [[NSMutableArray alloc] init];
    selectedMultipleRowDataArray = [[NSMutableArray alloc]init];
    updateProfileDataArray = [[NSMutableArray alloc]init];
    getFilterDataArray = [[NSMutableArray alloc]init];
    commonArray = [[NSMutableArray alloc]init];
    selectedIndex = -1;
    updateProfileTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    titleLabel.text = [self.titleStr uppercaseString];
    if([self.titleStr isEqualToString:@"Language"])
    {
        if(self.isCheckedFilterValue==YES)
        {
            doneButton.hidden = YES;
            
        } else {
            doneButton.hidden = NO;
        }
    }
    else
    {
        doneButton.hidden = YES;
    }
    cellSelected = [NSMutableArray array];
    self.languageIdArray = [[NSMutableArray alloc]init];
    arrayOfLanguageData = [[NSMutableArray alloc]init];
    arrayOfSmokingData = [[NSMutableArray alloc]init];
    arrayOfDrinkingData = [[NSMutableArray alloc]init];
    _smokingIdArray = [[NSMutableArray alloc]init];
    _drinkingIdArray = [[NSMutableArray alloc]init];
    _smokingNameArray = [[NSMutableArray alloc]init];
    _drinkingNameArray = [[NSMutableArray alloc]init];
    if([self.titleStr isEqualToString:@"Language"]) {
        [self setLanguageData];
    }
    else if([self.titleStr isEqualToString:@"Smoking"]) {
        [self setsmokingData];
    }
    else if([self.titleStr isEqualToString:@"Drinking"]) {
        [self setdrinkingData];
    }
    else {
        [self fetchGetProfileDataApiCall];
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
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
    
    
    arrayOfLanguageData =[SingletonClass parseDateForFilterType:languageDataArray];
    if (self.isCheckedFilterValue == YES) {
        NSUInteger countValue = 0;
        for(NSDictionary *dictt in languageDataArray)
        {
            
            NSString *strr = [dictt valueForKey:@"Value"];
            [selectedMultipleRowDataArray addObject:strr];
            NSString  *languageSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSelectedTitle"];
            NSArray *dataArray = [languageSelectedName componentsSeparatedByString:@","];
            for(NSString *langStr in dataArray) {
                NSString *formateedString = [langStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if([strr isEqualToString:formateedString])
                {
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                    for (SingletonClass *object in arrayOfLanguageData) {
                        if ([object.filterType isEqualToString:langStr]) {
                            object.checkFilterTypeValue = YES;
                        }
                    }
                    NSDictionary *dataDict = [languageDataArray objectAtIndex:countValue];
                    //bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                    NSString *strId = [dataDict valueForKey:@"ID"];
                    [self.languageIdArray addObject:strId];
                    [cellSelected addObject:path];
                    [languageNameArray addObject:languageSelectedName];
                }
            }
            
            countValue++;
        }
        [updateProfileTable reloadData];
    }
    else {
        NSUInteger countValue = 0;
        for(NSDictionary *dictt in languageDataArray)
        {
            
            NSArray *dataArray = [self.selectedIndexxStr componentsSeparatedByString:@","];
            NSString *strr = [dictt valueForKey:@"Value"];
            [commonArray addObject:strr];
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
                    // [languageNameArray addObject:languageSelectedName];
                    
                }
            }
            countValue++;
        }
        [updateProfileTable reloadData];
        
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
    //    NSMutableDictionary *anySmokerDict = [[NSMutableDictionary alloc]init];
    //
    //    [anySmokerDict setObject:@"Any" forKey:@"Value"];
    //    [anySmokerDict setObject:@"4" forKey:@"ID"];
    
    smokingDataArray = [[NSMutableArray alloc]initWithObjects:nonSmokerDict,lightSmokerDict,heavySmokerDict,nil];
    NSUInteger countValue = 0;
    arrayOfSmokingData =[SingletonClass parseDateForFilterType:smokingDataArray];
    if (self.isCheckedFilterValue  == NO) {
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
        
    }else{
        for(NSDictionary *dictt in smokingDataArray)
        {
            
            NSString *strr = [dictt valueForKey:@"Value"];
            [selectedMultipleRowDataArray addObject:strr];
            NSString  *languageSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedSmokingDataValue"];
            NSArray *dataArray = [languageSelectedName componentsSeparatedByString:@","];
            for(NSString *langStr in dataArray) {
                if([strr isEqualToString:langStr])
                {
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                    for (SingletonClass *object in arrayOfSmokingData) {
                        if ([object.filterType isEqualToString:langStr]) {
                            object.checkFilterTypeValue = YES;
                        }
                    }
                    NSDictionary *dataDict = [smokingDataArray objectAtIndex:countValue];
                    //bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                    NSString *strId = [dataDict valueForKey:@"ID"];
                    [self.smokingIdArray addObject:strId];
                    [cellSelected addObject:path];
                    [_smokingNameArray addObject:languageSelectedName];
                }
            }
            
            countValue++;
        }
    }
    [updateProfileTable reloadData];
    
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
    //    NSMutableDictionary *anyDrinkDict = [[NSMutableDictionary alloc]init];
    //
    //    [anyDrinkDict setObject:@"Any" forKey:@"Value"];
    //    [anyDrinkDict setObject:@"4" forKey:@"ID"];
    drinkingDataArray = [[NSMutableArray alloc]initWithObjects:nonDrinkDict,lightDrinkDict,heavyDrinkDict,nil];
    NSUInteger countValue = 0;
    arrayOfDrinkingData =[SingletonClass parseDateForFilterType:drinkingDataArray];
    if (self.isCheckedFilterValue == NO) {
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
    else{
        for(NSDictionary *dictt in drinkingDataArray)
        {
            
            NSString *strr = [dictt valueForKey:@"Value"];
            [selectedMultipleRowDataArray addObject:strr];
            NSString  *languageSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedDrinkingDataValue"];
            NSArray *dataArray = [languageSelectedName componentsSeparatedByString:@","];
            for(NSString *langStr in dataArray) {
                if([strr isEqualToString:langStr])
                {
                    
                    NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                    for (SingletonClass *object in arrayOfDrinkingData) {
                        if ([object.filterType isEqualToString:langStr]) {
                            object.checkFilterTypeValue = YES;
                        }
                    }
                    NSDictionary *dataDict = [drinkingDataArray objectAtIndex:countValue];
                    //bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                    NSString *strId = [dataDict valueForKey:@"ID"];
                    [self.drinkingIdArray addObject:strId];
                    [cellSelected addObject:path];
                    [_drinkingNameArray addObject:languageSelectedName];
                }
            }
            
            countValue++;
        }
    }
    [updateProfileTable reloadData];
    
    
}




-(NSArray *)getSelections {
    
    NSMutableArray *selections = [[NSMutableArray alloc] init];
    for(NSIndexPath *indexPath in arOptions) {
        [selections addObject:[languageDataArray objectAtIndex:indexPath.row]];
    }
    return selections;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NotificationTableViewCell *cell;
    
    cell = nil;
    if (cell == nil) {
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Noti"];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    NSDictionary *dataDictionary;
    SingletonClass *customObject;
   
    if (getFilterDataArray.count) {
        lastCount = getFilterDataArray.count-1;
        customObject = [getFilterDataArray objectAtIndex:indexPath.row];
    }
    if([self.titleStr isEqualToString:@"Language"])
    {
        lastCount = languageDataArray.count-1;


        dataDictionary = [languageDataArray objectAtIndex:indexPath.row];
        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else if([self.titleStr isEqualToString:@"Smoking"])
    {
        lastCount = smokingDataArray.count-1;
        dataDictionary = [smokingDataArray objectAtIndex:indexPath.row];
        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else if([self.titleStr isEqualToString:@"Drinking"])
    {
        lastCount = drinkingDataArray.count-1;
        dataDictionary = [drinkingDataArray objectAtIndex:indexPath.row];
        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    else
    {
        lastCount = updateProfileDataArray.count-1;
        if (indexPath.row == lastCount) {
          //  [cell.seperatorLabelValue setHidden:YES];
        }
        else{
           // [cell.seperatorLabelValue setHidden:NO];
        }
        NSDictionary *dataDictionary = [updateProfileDataArray objectAtIndex:indexPath.row];
        cell.nameLbl.text = [dataDictionary valueForKey:@"Value"];
    }
    
    if(self.isCheckedFilterValue==YES) {
        
        if( [self.titleStr isEqualToString:@"Type"] || [self.titleStr isEqualToString:@"Body Type"] || [self.titleStr isEqualToString:@"Ethnicity"] || [self.titleStr isEqualToString:@"Eye Color"] || [self.titleStr isEqualToString:@"Hair Color"] || [self.titleStr isEqualToString:@"Education"]) {
            
            if (customObject.checkFilterTypeValue) {
                cell.accessoryView = imageView;
                
            }
            else{
                cell.accessoryView = NULL;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        else if ([self.titleStr isEqualToString:@"Language"]){
            
            SingletonClass *custObj = [arrayOfLanguageData  objectAtIndex:indexPath.row];
            if (custObj.checkFilterTypeValue) {
                cell.accessoryView = imageView;
                
            }
            else{
                cell.accessoryView = NULL;
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
        else if ([self.titleStr isEqualToString:@"Smoking"] ){
            
            SingletonClass *custObj = [arrayOfSmokingData  objectAtIndex:indexPath.row];
            if (custObj.checkFilterTypeValue) {
                cell.accessoryView = imageView;
                custObj.checkFilterTypeValue = NO;
                
            }
            else {
                cell.accessoryView = NULL;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
            
        }
        else if ([self.titleStr isEqualToString:@"Drinking"]){
            
            SingletonClass *custObj = [arrayOfDrinkingData  objectAtIndex:indexPath.row];
            if (custObj.checkFilterTypeValue) {
                cell.accessoryView = imageView;
                custObj.checkFilterTypeValue = NO;
                
            }
            else{
                cell.accessoryView = NULL;
                cell.accessoryType = UITableViewCellAccessoryNone;
                
            }
        }
    }
    else {
        
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
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //   Type, Body Type, Ethnicity, Eye Color, Hair Color, Education, Language
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDict;
    SingletonClass *customObject;
    if (getFilterDataArray.count) {
        customObject = [getFilterDataArray objectAtIndex:indexPath.row];
        
    }
    selectedIndex = indexPath.row;
    
    if ([self.titleStr isEqualToString:@"Language"])
    {
        dataDict = [languageDataArray objectAtIndex: indexPath.row];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        NSString *strId = [dataDict valueForKey:@"ID"];
        customObject = [arrayOfLanguageData  objectAtIndex:indexPath.row];
        
        if(self.isCheckedFilterValue ==YES)
        {
            [cellSelected removeAllObjects];
            if (customObject.checkFilterTypeValue) {
                customObject.checkFilterTypeValue = NO;
                for (SingletonClass *custName in arrayOfLanguageData) {
                    if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                        [_languageIdArray removeObject:bodyTypeIdStr];
                        [languageNameArray removeObject:bodyTypeValueStr];
                        [ cellSelected removeObject:indexPath];
                    }
                }
            }
            else {
                customObject.checkFilterTypeValue = YES;
                [cellSelected addObject:indexPath];
                [_languageIdArray addObject:bodyTypeIdStr];
                [languageNameArray addObject:bodyTypeValueStr];
            }
            
            
            bodyTypeIdStr  = [self.languageIdArray componentsJoinedByString:@","];
            sharedInstance.strContractorLanguageTypeFilter = bodyTypeIdStr;
            bodyTypeValueStr  = [languageNameArray componentsJoinedByString:@","];
            
            if(self.isCheckedFilterValue==YES)
            {
                
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LanguageSelectedTitle"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedLanguageDataValue"];
                NSMutableDictionary *languageDict = [[NSMutableDictionary alloc]init];
                [languageDict setObject:bodyTypeValueStr forKey:@"LanguageValue"];
                [languageDict setObject:bodyTypeIdStr forKey:@"languageId"];
                [[NSUserDefaults standardUserDefaults]setObject:languageDict forKey:@"SelectedLanguageDataValue"];
                sharedInstance.languageSelectedName = bodyTypeValueStr;
                [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"LanguageSelectedTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            NSLog(@"%@",bodyTypeIdStr);
            sharedInstance.strContractorLanguageTypeFilter = bodyTypeIdStr;
            [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else {
            
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
            
            
        }
    }
    else if ([self.titleStr isEqualToString:@"Smoking"]) {
        
        dataDict = [smokingDataArray objectAtIndex:indexPath.row];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        //   NSString *strId = [dataDict valueForKey:@"ID"];
        customObject = [arrayOfSmokingData  objectAtIndex:indexPath.row];
        [cellSelected removeAllObjects];
        if (self.isCheckedFilterValue == NO) {
            
            dataDict = [smokingDataArray objectAtIndex:selectedIndex];
            bodyTypeValueStr = [dataDict valueForKey:@"Value"];
            bodyTypeIdStr = [dataDict valueForKey:@"ID"];
            [self fetchchangeProfileDataApiCall];
            
            
        }
        else {
            
            if (customObject.checkFilterTypeValue) {
                
                for (SingletonClass *custName in arrayOfSmokingData) {
                    if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                        [_smokingIdArray removeObject:bodyTypeIdStr];
                        [_smokingNameArray removeObject:bodyTypeValueStr];
                        custName.checkFilterTypeValue = NO;
                        [ cellSelected removeObject:indexPath];
                    }
                }
            }
            else {
                customObject.checkFilterTypeValue = YES;
                [cellSelected addObject:indexPath];
                [_smokingIdArray addObject:bodyTypeIdStr];
                [_smokingNameArray addObject:bodyTypeValueStr];
            }

            if(self.isCheckedFilterValue==YES)
            {
                NSMutableDictionary *smokingDict = [[NSMutableDictionary alloc]init];
                [smokingDict setObject:bodyTypeValueStr forKey:@"SmokingValue"];
                [smokingDict setObject:bodyTypeIdStr forKey:@"SmokingId"];
                sharedInstance.dictForSmokingValue = smokingDict;
                [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"SelectedSmokingDataValue"];
                [[NSUserDefaults standardUserDefaults]setObject:self.titleStr forKey:@"SmokingTitle"];
                
            }
            else
            {
                
                [self fetchchangeProfileDataApiCall];
            }
        }
        sharedInstance.strContractorSmokingTypeFilter = bodyTypeIdStr;
        
    }
    else if ([self.titleStr isEqualToString:@"Drinking"])
    {
        dataDict = [drinkingDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        // NSString *strId = [dataDict valueForKey:@"ID"];
        [cellSelected removeAllObjects];
        
        customObject = [arrayOfDrinkingData  objectAtIndex:indexPath.row];
        if (self.isCheckedFilterValue == NO) {
            
            dataDict = [drinkingDataArray objectAtIndex:selectedIndex];
            bodyTypeValueStr = [dataDict valueForKey:@"Value"];
            bodyTypeIdStr = [dataDict valueForKey:@"ID"];
            [self fetchchangeProfileDataApiCall];
            
        }
        else
        {
            if (customObject.checkFilterTypeValue) {
                customObject.checkFilterTypeValue = NO;
                for (SingletonClass *custName in arrayOfDrinkingData) {
                    if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                        [_drinkingIdArray removeObject:bodyTypeIdStr];
                        [_drinkingNameArray removeObject:bodyTypeValueStr];
                        [ cellSelected removeObject:indexPath];
                    }
                }
            }
            else {
                customObject.checkFilterTypeValue = YES;
                [cellSelected addObject:indexPath];
                [_drinkingIdArray addObject:bodyTypeIdStr];
                [_drinkingNameArray addObject:bodyTypeValueStr];
            }

            if(self.isCheckedFilterValue==YES)
            {
                NSMutableDictionary *drinkingDict = [[NSMutableDictionary alloc]init];
                [drinkingDict setObject:bodyTypeValueStr forKey:@"DrinkingValue"];
                [drinkingDict setObject:bodyTypeIdStr forKey:@"DrinkingId"];
                sharedInstance.dictForDrinkingValue = drinkingDict;
                sharedInstance.strContractorDrinkingTypeFilter = bodyTypeIdStr;
                
                [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"SelectedDrinkingDataValue"];
                [[NSUserDefaults standardUserDefaults]setObject:self.titleStr forKey:@"DrinkingTitle"];
            }
            else
            {
                [self fetchchangeProfileDataApiCall];
            }
        }
        
    }
    else
    {
        dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
        bodyTypeValueStr = [dataDict valueForKey:@"Value"];
        bodyTypeIdStr = [dataDict valueForKey:@"ID"];
        [cellSelected removeAllObjects];
        
        if(self.isCheckedFilterValue==YES)
        {
            if ([self.titleStr isEqualToString:@"Type"])
            {
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [modelTypeIdArray removeObject:bodyTypeIdStr];
                            [modelTypeNameArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [modelTypeIdArray addObject:bodyTypeIdStr];
                    [modelTypeNameArray addObject:bodyTypeValueStr];
                }
                

                
                bodyTypeIdStr  = [modelTypeIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [modelTypeNameArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ModelTypeName"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedTypeDataValue"];
                    
                    NSMutableDictionary *typeDict = [[NSMutableDictionary alloc]init];
                    [typeDict setObject:bodyTypeValueStr forKey:@"TypeValue"];
                    [typeDict setObject:bodyTypeIdStr forKey:@"TypeId"];
                    [[NSUserDefaults standardUserDefaults]setObject:typeDict forKey:@"SelectedTypeDataValue"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.titleStr forKey:@"TypeTitle"];
                    sharedInstance.strModelTypeName = bodyTypeValueStr;
                    [[NSUserDefaults standardUserDefaults] setObject:bodyTypeValueStr forKey:@"ModelTypeName"];
                    NSString  *modelTypeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ModelTypeName"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSLog(@"modelTypeName..........== %@",modelTypeName);
                }
                
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorTypeFilter = bodyTypeIdStr;
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
                
            }
            else if ([self.titleStr isEqualToString:@"Body Type"])
            {
                
                [cellSelected removeAllObjects];
                dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
                bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                bodyTypeIdStr = [dataDict valueForKey:@"ID"];
                
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [bodyTypeIdArray removeObject:bodyTypeIdStr];
                            [bodyTypeArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [bodyTypeIdArray addObject:bodyTypeIdStr];
                    [bodyTypeArray addObject:bodyTypeValueStr];
                }
                

                bodyTypeIdStr  = [bodyTypeIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorBodyTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [bodyTypeArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedBodyTypeDataValue"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"BodyTypeTitle"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableDictionary *bodyTypeDict = [[NSMutableDictionary alloc]init];
                    [bodyTypeDict setObject:bodyTypeValueStr forKey:@"BodyTypeValue"];
                    [bodyTypeDict setObject:bodyTypeIdStr forKey:@"BodyTypeId"];
                    sharedInstance.dictBodyType = bodyTypeDict;
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeDict forKey:@"SelectedBodyTypeDataValue"];
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"BodyTypeTitle"];
                    NSString  *BodyTypeTitleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"BodyTypeTitle"];
                    
                    NSLog(@"BodyTypeTitleStr..........== %@",BodyTypeTitleStr);
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorBodyTypeFilter = bodyTypeIdStr;
                
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if ([self.titleStr isEqualToString:@"Ethnicity"])
            {
                [cellSelected removeAllObjects];
                dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
                bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                bodyTypeIdStr = [dataDict valueForKey:@"ID"];
                
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [ethnicityTypeIdArray removeObject:bodyTypeIdStr];
                            [ethnicityTypeArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [ethnicityTypeIdArray addObject:bodyTypeIdStr];
                    [ethnicityTypeArray addObject:bodyTypeValueStr];
                }

                bodyTypeIdStr  = [ethnicityTypeIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorEthencityTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [ethnicityTypeArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEthnicityDataValue"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EthnicityTitle"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSMutableDictionary *bodyTypeDict = [[NSMutableDictionary alloc]init];
                    [bodyTypeDict setObject:bodyTypeValueStr forKey:@"EthnicityValue"];
                    [bodyTypeDict setObject:bodyTypeIdStr forKey:@"EthnicityId"];
                    sharedInstance.dictForEthnicityValue = bodyTypeDict;
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeDict forKey:@"SelectedEthnicityDataValue"];
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"EthnicityTitle"];
                    NSString  *EthnicityTitleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"EthnicityTitle"];
                    NSLog(@"EthnicityTitleStr..........== %@",EthnicityTitleStr);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorEthencityTypeFilter = bodyTypeIdStr;
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if ([self.titleStr isEqualToString:@"Eye Color"])
            {
                [cellSelected removeAllObjects];
                dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
                bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                bodyTypeIdStr = [dataDict valueForKey:@"ID"];
                
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [eyeIdArray removeObject:bodyTypeIdStr];
                            [eyeTypeArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [eyeIdArray addObject:bodyTypeIdStr];
                    [eyeTypeArray addObject:bodyTypeValueStr];
                }
                

                bodyTypeIdStr  = [eyeIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorEyeColorTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [eyeTypeArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEyeColorDataValue"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EyeColorTitle"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableDictionary *bodyTypeDict = [[NSMutableDictionary alloc]init];
                    [bodyTypeDict setObject:bodyTypeValueStr forKey:@"EyeColorValue"];
                    [bodyTypeDict setObject:bodyTypeIdStr forKey:@"EyeColorId"];
                    sharedInstance.dictForEyeColorValue = bodyTypeDict;
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeDict forKey:@"SelectedEyeColorDataValue"];
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"EyeColorTitle"];
                    NSString  *eyeTitleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"EyeColorTitle"];
                    NSLog(@"EyeColorTitleStr..........== %@",eyeTitleStr);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorEyeColorTypeFilter = bodyTypeIdStr;
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if ([self.titleStr isEqualToString:@"Hair Color"])
            {
                
                [cellSelected removeAllObjects];
                dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
                bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                bodyTypeIdStr = [dataDict valueForKey:@"ID"];
                
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [hairIdArray removeObject:bodyTypeIdStr];
                            [hairTypeArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [hairIdArray addObject:bodyTypeIdStr];
                    [hairTypeArray addObject:bodyTypeValueStr];
                }

                bodyTypeIdStr  = [hairIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorHairColorTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [hairTypeArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedHairColorDataValue"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"HairColorTitle"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSMutableDictionary *bodyTypeDict = [[NSMutableDictionary alloc]init];
                    [bodyTypeDict setObject:bodyTypeValueStr forKey:@"HairColorValue"];
                    [bodyTypeDict setObject:bodyTypeIdStr forKey:@"HairColorId"];
                    sharedInstance.dictForHairValue = bodyTypeDict;
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeDict forKey:@"SelectedHairColorDataValue"];
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"HairColorTitle"];
                    NSString  *hairTitleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"HairColorTitle"];
                    NSLog(@"hairTitleTitleStr..........== %@",hairTitleStr);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorHairColorTypeFilter = bodyTypeIdStr;
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if ([self.titleStr isEqualToString:@"Education"])
            {
                [cellSelected removeAllObjects];
                dataDict = [updateProfileDataArray objectAtIndex:selectedIndex];
                bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                bodyTypeIdStr = [dataDict valueForKey:@"ID"];
                
                customObject = [getFilterDataArray objectAtIndex:indexPath.row];
                
                if (customObject.checkFilterTypeValue) {
                    customObject.checkFilterTypeValue = NO;
                    for (SingletonClass *custName in getFilterDataArray) {
                        if ([custName.filterType isEqualToString:bodyTypeValueStr]) {
                            [educationIdArray removeObject:bodyTypeIdStr];
                            [educationTypeArray removeObject:bodyTypeValueStr];
                            [ cellSelected removeObject:indexPath];
                        }
                    }
                }
                else {
                    customObject.checkFilterTypeValue = YES;
                    [cellSelected addObject:indexPath];
                    [educationIdArray addObject:bodyTypeIdStr];
                    [educationTypeArray addObject:bodyTypeValueStr];
                }

                bodyTypeIdStr  = [educationIdArray componentsJoinedByString:@","];
                sharedInstance.strContractorEducationTypeFilter = bodyTypeIdStr;
                bodyTypeValueStr  = [educationTypeArray componentsJoinedByString:@","];
                
                if(self.isCheckedFilterValue==YES)
                {
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEducationDataValue"];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EducationTitle"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSMutableDictionary *bodyTypeDict = [[NSMutableDictionary alloc]init];
                    [bodyTypeDict setObject:bodyTypeValueStr forKey:@"EducationValue"];
                    [bodyTypeDict setObject:bodyTypeIdStr forKey:@"EducationId"];
                    sharedInstance.dictForEducationValue = bodyTypeDict;
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeDict forKey:@"SelectedEducationDataValue"];
                    [[NSUserDefaults standardUserDefaults]setObject:bodyTypeValueStr forKey:@"EducationTitle"];
                    NSString  *educationTitleStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"EducationTitle"];
                    NSLog(@"EducationTitleStr..........== %@",educationTitleStr);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                }
                NSLog(@"%@",bodyTypeIdStr);
                sharedInstance.strContractorEducationTypeFilter = bodyTypeIdStr;
                [updateProfileTable reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                
            }
            else if ([self.titleStr isEqualToString:@"Height"])
            {
                NSMutableDictionary *heightDict = [[NSMutableDictionary alloc]init];
                [heightDict setObject:bodyTypeValueStr forKey:@"HeightValue"];
                [heightDict setObject:bodyTypeIdStr forKey:@"HeightId"];
                //sharedInstance.strContractorHeightTypeFilter = bodyTypeIdStr;
                
                [[NSUserDefaults standardUserDefaults]setObject:heightDict forKey:@"SelectedHeightDataValue"];
                
                
            }
            else if ([self.titleStr isEqualToString:@"Weight"])
            {
                NSMutableDictionary *weightDict = [[NSMutableDictionary alloc]init];
                [weightDict setObject:bodyTypeValueStr forKey:@"WeightValue"];
                [weightDict setObject:bodyTypeIdStr forKey:@"WeightId"];
                [[NSUserDefaults standardUserDefaults]setObject:weightDict forKey:@"SelectedWeightDataValue"];
            }
        }
        else
        {
            [self fetchchangeProfileDataApiCall];
        }
    }
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [updateProfileTable reloadData];
}


#pragma mark-- Get ProfileData API Call

-(void)fetchGetProfileDataApiCall {
    
    NSString *dataTypestr;
    if([self.titleStr isEqualToString:@"Type"])
    {
        dataTypestr= @"ContractorTypes";
    }
    else if([self.titleStr isEqualToString:@"Body Type"])
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
    
    if ([self.titleStr isEqualToString:@"Height"] ) {
        urlString = APIUpdateProfileDataForSearch;
        NSLog(@"Api Url %@",urlString);
        NSString *userIdString = sharedInstance.userId;
        
        NSString *urlstrr=[NSString stringWithFormat:@"%@?UserID=%@",APIUpdateProfileDataForSearch,userIdString];
        [ServerRequest requestWithUrlForQA:urlstrr withParams:nil CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            
            [ProgressHUD dismiss];
            
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                    updateProfileDataArray = [pushSettingsDictionary objectForKey:@"MasterValues"];
                    getFilterDataArray = [SingletonClass parseDateForFilterType:[pushSettingsDictionary objectForKey:@"MasterValues"]];
                    NSMutableArray *commonArray1 = [[NSMutableArray alloc]init];
                    NSString *selecteString;
                    if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
                        selecteString = [NSString stringWithFormat:@"%@",self.selectedIndexxStr];
                    }
                    else{
                        selecteString = [NSString stringWithFormat:@"%@",self.selectedIndexxStr];
                    }
                    for(NSDictionary *dictt in updateProfileDataArray)
                    {
                        NSString *strr = [dictt valueForKey:@"Value"];
                        [commonArray1 addObject:strr];
                        if([commonArray1 containsObject:selecteString])
                        {
                            NSInteger index = [commonArray1 indexOfObject:selecteString];
                            selectedIndex = index;
                            break;
                        }
                    }
                    [updateProfileTable reloadData];
                    
                }
            }else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
         ];
        
    }
    else {
        urlString = APIUpdateProfileData;
        NSLog(@"Api Url %@",urlString);
        [ServerRequest requestWithUrlForQA:urlString withParams:params CallBack:^(id responseObject, NSError *error) {
            NSLog(@"response object Get UserInfo List %@",responseObject);
            
            [ProgressHUD dismiss];
            
            if(!error){
                NSLog(@"Response is --%@",responseObject);
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    NSDictionary *pushSettingsDictionary = [responseObject objectForKey:@"result"];
                    updateProfileDataArray = [pushSettingsDictionary objectForKey:@"MasterValues"];
                    getFilterDataArray = [SingletonClass parseDateForFilterType:[pushSettingsDictionary objectForKey:@"MasterValues"]];
                    
                    if(self.isCheckedFilterValue==YES)
                    {
                        
                        if ([self.titleStr isEqualToString:@"Type"])
                        {
                            
                            NSUInteger countValue = 0;
                            [cellSelected removeAllObjects];
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                
                                NSString  *modelTypeName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ModelTypeName"];
                                
                                NSArray *dataArray = [modelTypeName componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    if([strr isEqualToString:langStr])
                                    {
                                        
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        //bodyTypeValueStr = [dataDict valueForKey:@"Value"];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [modelTypeIdArray addObject:strId];
                                        NSString *modelName = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        [cellSelected addObject:path];
                                        [modelTypeNameArray addObject:modelName];
                                        
                                    }
                                }
                                
                                countValue++;
                                
                            }
                            
                        } else if([self.titleStr isEqualToString:@"Body Type"]) {
                            
                            bodyTypeArray = [[NSMutableArray alloc] init];
                            bodyTypeIdArray = [[NSMutableArray alloc] init];
                            [cellSelected removeAllObjects];
                            
                            NSUInteger countValue = 0;
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                
                                NSString *bodyType  = [[NSUserDefaults standardUserDefaults] objectForKey:@"BodyTypeTitle"];
                                
                                NSArray *dataArray = [bodyType componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    
                                    if([strr isEqualToString:langStr])
                                    {
                                        
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [bodyTypeIdArray addObject:strId];
                                        
                                        
                                        NSString *bodyDataStr = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        
                                        [cellSelected addObject:path];
                                        [bodyTypeArray addObject:bodyDataStr];
                                        
                                    }
                                }
                                
                                countValue++;
                                
                            }
                            
                        } else if ([self.titleStr isEqualToString:@"Ethnicity"]) {
                            
                            ethnicityTypeArray = [[NSMutableArray alloc] init];
                            ethnicityTypeIdArray = [[NSMutableArray alloc] init];
                            [cellSelected removeAllObjects];
                            
                            
                            NSUInteger countValue = 0;
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                
                                NSString *bodyType  = [[NSUserDefaults standardUserDefaults] objectForKey:@"EthnicityTitle"];
                                
                                NSArray *dataArray = [bodyType componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    
                                    if([strr isEqualToString:langStr])
                                    {
                                        
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [ethnicityTypeIdArray addObject:strId];
                                        
                                        
                                        NSString *bodyDataStr = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        
                                        [cellSelected addObject:path];
                                        [ethnicityTypeArray addObject:bodyDataStr];
                                        
                                    }
                                }
                                
                                countValue++;
                                
                            }
                        } else if ([self.titleStr isEqualToString:@"Eye Color"]) {
                            
                            
                            eyeTypeArray = [[NSMutableArray alloc] init];
                            eyeIdArray = [[NSMutableArray alloc] init];
                            NSUInteger countValue = 0;
                            [cellSelected removeAllObjects];
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                
                                NSString *bodyType  = [[NSUserDefaults standardUserDefaults] objectForKey:@"EyeColorTitle"];
                                
                                NSArray *dataArray = [bodyType componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    
                                    if([strr isEqualToString:langStr])
                                    {
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [eyeIdArray addObject:strId];
                                        
                                        
                                        NSString *bodyDataStr = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        
                                        [cellSelected addObject:path];
                                        [eyeTypeArray addObject:bodyDataStr];
                                        
                                    }
                                }
                                
                                countValue++;
                                
                            }
                        }
                        else if ([self.titleStr isEqualToString:@"Hair Color"]) {
                            
                            hairTypeArray = [[NSMutableArray alloc] init];
                            hairIdArray = [[NSMutableArray alloc] init];
                            
                            NSUInteger countValue = 0;
                            [cellSelected removeAllObjects];
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                NSString *bodyType  = [[NSUserDefaults standardUserDefaults] objectForKey:@"HairColorTitle"];
                                NSArray *dataArray = [bodyType componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    if([strr isEqualToString:langStr])
                                    {
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [hairIdArray addObject:strId];
                                        
                                        NSString *bodyDataStr = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        
                                        [cellSelected addObject:path];
                                        [hairTypeArray addObject:bodyDataStr];
                                    }
                                }
                                countValue++;
                            }
                            
                        }
                        else if ([self.titleStr isEqualToString:@"Education"]) {
                            
                            educationTypeArray = [[NSMutableArray alloc] init];
                            educationIdArray = [[NSMutableArray alloc] init];
                            [cellSelected removeAllObjects];
                            NSUInteger countValue = 0;
                            
                            for(NSDictionary *dictt in updateProfileDataArray)
                            {
                                
                                NSString *strr = [dictt valueForKey:@"Value"];
                                
                                NSString *bodyType  = [[NSUserDefaults standardUserDefaults] objectForKey:@"EducationTitle"];
                                
                                NSArray *dataArray = [bodyType componentsSeparatedByString:@","];
                                for(NSString *langStr in dataArray) {
                                    
                                    if([strr isEqualToString:langStr])
                                    {
                                        
                                        for (SingletonClass *obj in getFilterDataArray) {
                                            if ([obj.filterType isEqualToString:langStr]) {
                                                obj.checkFilterTypeValue = YES;
                                            }
                                        }
                                        NSIndexPath *path = [NSIndexPath indexPathForRow:countValue inSection:0];
                                        
                                        NSDictionary *dataDict = [updateProfileDataArray objectAtIndex:countValue];
                                        NSString *strId = [dataDict valueForKey:@"ID"];
                                        [educationIdArray addObject:strId];
                                        
                                        
                                        NSString *bodyDataStr = [NSString stringWithFormat:@"%@",[[updateProfileDataArray objectAtIndex:countValue] objectForKey:@"Value"] ];
                                        
                                        [cellSelected addObject:path];
                                        [educationTypeArray addObject:bodyDataStr];
                                    }
                                }
                                
                                countValue++;
                            }
                        }
                        [updateProfileTable reloadData];
                        
                    } else {
                        
                        NSMutableArray *commonArray1 = [[NSMutableArray alloc]init];
                        
                        for(NSDictionary *dictt in updateProfileDataArray)
                        {
                            NSString *strr = [dictt valueForKey:@"Value"];
                            [commonArray1 addObject:strr];
                            if([commonArray1 containsObject:self.selectedIndexxStr])
                            {
                                NSInteger index = [commonArray1 indexOfObject:self.selectedIndexxStr];
                                selectedIndex = index;
                                break;
                            }
                        }
                        
                        [updateProfileTable reloadData];
                        
                    }
                }else
                {
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }];
    }
}


#pragma mark--  Change profileData API

-(void)fetchchangeProfileDataApiCall {
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *dataTypestr;
    if([self.titleStr isEqualToString:@"Type"])
    {
        dataTypestr= @"ContractorType";
    }
    else if([self.titleStr isEqualToString:@"Body Type"])
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
        dataTypestr = @"Drinking";
    }
    else if ([self.titleStr isEqualToString:@"Height"])
    {
        dataTypestr = @"Height";
    }
    else if ([self.titleStr isEqualToString:@"Weight"])
    {
        dataTypestr = @"Weight";
    }
    else if ([self.titleStr isEqualToString:@"Education"])
    {
        dataTypestr = @"Education";
    }
    
    
    NSString *urlstr =[NSString stringWithFormat:@"%@?userID=%@&attributeType=%@&attributeValue=%@",APIChangeProfileData,userIdStr,dataTypestr,bodyTypeIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApiForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
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
                else
                {
                }
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
    
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([self.titleStr isEqualToString:@"Language"])
    {
        [self fetchchangeProfileDataApiCall];
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
