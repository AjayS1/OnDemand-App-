
//  FilterViewController.m
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "FilterViewController.h"

#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface FilterViewController () {
    NSArray *dataArray;
    CLGeocoder * geoCoder;
    BOOL sepratorLine;
    NSString *strForAvailableNowValue;
    NSString *typeValueStr;
    NSInteger selectIndexPath;
    NSMutableArray *arrayOfSwitch;
    NSInteger chackSelectedIndex;
}

@end

@implementation FilterViewController
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //isEmpty = TRUE;
    //sharedInstance = [SingletonClass sharedInstance];
    sepratorLine = TRUE;
    selectIndexPath = -1;
    [self.tabBarController.tabBar setHidden:YES];
    self.userProfileDataArray = [[NSMutableArray alloc]init];
    arrAgePickerView = [[NSMutableArray alloc] initWithObjects:@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",@"63",@"64",@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84",@"85",@"86",@"87",@"88",@"89",@"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",@"99",nil];
    dataArray = [NSArray arrayWithObjects:@"Online Only",@"Location",@"Distance",@"Type",@"Body Type",@"Age",@"Ethincity",@"Height",@"Weight",@"Eye Color",@"Hair Color",@"Smoking",@"Drinking",@"Education",@"Language", nil];
    arrayOfSwitch  = [[NSMutableArray alloc]init];
    for (int i = 0; i< dataArray.count; i++) {
        SingletonClass * menuInfo = [[SingletonClass alloc] init];
        NSString *value =[dataArray objectAtIndex:i];
        if ([value isEqualToString:@"Online Only"]) {
            menuInfo.IsSwitchShow = YES;
        }
        else{
            menuInfo.IsSwitchShow = NO;
        }
        [arrayOfSwitch addObject:menuInfo];
    }
    [self setFilterVlaueData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [super viewWillAppear:animated];
    [_segmentButton setSelectedSegmentIndex:0];
    sharedInstance = [SingletonClass sharedInstance];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    NSString *strForSortByValuedata= [[NSUserDefaults standardUserDefaults]objectForKey:@"SortByValue"];
    NSString *strForSortByDirectiondata= [[NSUserDefaults standardUserDefaults]objectForKey:@"SortDirectionValue"];
    NSLog(@"strForSortByValuedata %@%@",strForSortByValuedata,strForSortByDirectiondata);
    
    NSUInteger sortBySelectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SortdirectionSelectedSegmentIndexValue"];
    switch (sortBySelectedIndex) {
        case 0:
            [segmentedControl1 setSelectedSegmentIndex:0];
            break;
        case 1:
            [segmentedControl1 setSelectedSegmentIndex:1];
            break;
        case 2:
            [segmentedControl1 setSelectedSegmentIndex:2];
            break;
            
        default:
            break;
    }
    
    NSString *strForAvailableNowData = [[NSUserDefaults standardUserDefaults]objectForKey:@"AvailableNowValueOnline"];
    if (!strForAvailableNowData) {
        strForAvailableNowData = @"";
    }
    
    if([strForAvailableNowData isEqualToString:@"2"]) {
        availableNowSegmentedControl.selectedSegmentIndex = 1;
        
    } else {
        
        availableNowSegmentedControl.selectedSegmentIndex = 0;
    }
    
    [sortTable reloadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    if (segmentedControl1.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults]setObject:@"Nearest" forKey:@"SortDirectionValue"];
    }
    NSLog(@"value of sory by %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"SortDirectionValue" ]);
}

#pragma Mark: Additinitional Methode

-(void)getAddressFromLatLong{
    
    NSString *latitudeStr = sharedInstance.latiValueStr;
    NSString *lonitudeStr = sharedInstance.longiValueStr;
    NSLog(@"Lattitude Value%@",latitudeStr);
    NSLog(@"Longtitude Value%@",lonitudeStr);
    sharedInstance.currentLocationStr = [SingletonClass getAddressFromLatLon:[latitudeStr doubleValue] withLongitude:[lonitudeStr doubleValue]];
    NSLog(@"Placemark Value  %@", sharedInstance.currentLocationStr );
    [sortTable reloadData];
}

#pragma mark--  Age PopUp --******************************************************
- (void)createAgePopView {
    
    UIView *ageVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height -450)];
    ageVw.backgroundColor =[UIColor whiteColor];
    
    //--Haeder view
    UIView *headerVw =[[UIView alloc]initWithFrame:CGRectMake(-5, -5,ageVw.frame.size.width+10, 140)];
    [ageVw addSubview:headerVw];
    headerVw.backgroundColor = [UIColor whiteColor];
    UIBezierPath *headePath = [UIBezierPath bezierPathWithRoundedRect:headerVw.bounds
                                                    byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                          cornerRadii:CGSizeMake(6.0, 6.0)];
    headerVw.layer.masksToBounds = YES;
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    headerLayer.frame = headerVw.bounds;
    headerLayer.path = headePath.CGPath;
    headerVw.layer.mask = headerLayer;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerVw.frame.origin.x+80, headerVw.frame.origin.y+15,headerVw.frame.size.width-160, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = @"AGE";
    [headerVw addSubview:label];
    
    UIView *lineVw =[[UIView alloc]initWithFrame:CGRectMake(0, label.frame.origin.y+33, headerVw.frame.size.width, 1.0)];
    lineVw.backgroundColor =[UIColor blackColor];
    //[headerVw addSubview:lineVw];
    
    ageTextFiled =[CommonUtils createTextFieldWithRect:CGRectMake(20.0, 50.0, headerVw.frame.size.width-40, 30.0) andText:@"" andTextColor:[UIColor blackColor] withPlaceHolderText:@"Enter age: Age should e 18+" fontType:KMediumFontStyle fontSize:18];
    ageTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    ageTextFiled.delegate = self;
    ageTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    [headerVw addSubview:ageTextFiled];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(submitButtonForAgeClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"SUBMIT" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    
    button.frame = CGRectMake(headerVw.frame.origin.x+43, ageTextFiled.frame.origin.y+ageTextFiled.frame.size.height+15, 170.0, 30.0);
    [headerVw addSubview:button];
    
    [[KGModal sharedInstance]setModalBackgroundColor:[UIColor whiteColor]];
    [[KGModal sharedInstance]setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:ageVw andAnimated:YES];
    
}
#pragma mark--  Location PopUp --******************************************************
- (void)createLocationPopView {
    
    friendListVw =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.height -320)];
    friendListVw.backgroundColor =[UIColor whiteColor];
    
    //--Haeder view
    UIView *headerVw =[[UIView alloc]initWithFrame:CGRectMake(-5, -5,friendListVw.frame.size.width+10, 330)];
    [friendListVw addSubview:headerVw];
    UIBezierPath *headePath = [UIBezierPath bezierPathWithRoundedRect:headerVw.bounds
                                                    byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                          cornerRadii:CGSizeMake(6.0, 6.0)];
    headerVw.layer.masksToBounds = YES;
    CAShapeLayer *headerLayer = [CAShapeLayer layer];
    headerLayer.frame = headerVw.bounds;
    headerLayer.path = headePath.CGPath;
    headerVw.layer.mask = headerLayer;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerVw.frame.origin.x+80, headerVw.frame.origin.y+15,headerVw.frame.size.width-160, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.text = @"LOCATION";
    [headerVw addSubview:label];
    
    countryTextFiled =[CommonUtils createTextFieldWithRect:CGRectMake(20.0, 50.0, headerVw.frame.size.width-40, 30.0) andText:@"" andTextColor:[UIColor blackColor] withPlaceHolderText:@"Country" fontType:KMediumFontStyle fontSize:18];
    countryTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    countryTextFiled.delegate = self;
    [headerVw addSubview:countryTextFiled];
    
    stateTextFiled =[CommonUtils createTextFieldWithRect:CGRectMake(20.0,countryTextFiled.frame.origin.y+countryTextFiled.frame.size.height+10 , headerVw.frame.size.width-40, 30.0) andText:@"" andTextColor:[UIColor blackColor] withPlaceHolderText:@"State" fontType:KMediumFontStyle fontSize:18];
    stateTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    stateTextFiled.delegate = self;
    [headerVw addSubview:stateTextFiled];
    
    cityTextFiled =[CommonUtils createTextFieldWithRect:CGRectMake(20.0,stateTextFiled.frame.origin.y+stateTextFiled.frame.size.height+10 , headerVw.frame.size.width-40, 30.0) andText:@"" andTextColor:[UIColor blackColor] withPlaceHolderText:@"City" fontType:KMediumFontStyle fontSize:18];
    cityTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    cityTextFiled.delegate = self;
    [headerVw addSubview:cityTextFiled];
    
    zipCodeTextFiled =[CommonUtils createTextFieldWithRect:CGRectMake(20.0,cityTextFiled.frame.origin.y+cityTextFiled.frame.size.height+10 , headerVw.frame.size.width-40, 30.0) andText:@"" andTextColor:[UIColor blackColor] withPlaceHolderText:@"Zipcode" fontType:KMediumFontStyle fontSize:18];
    zipCodeTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    zipCodeTextFiled.delegate = self;
    [headerVw addSubview:zipCodeTextFiled];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [button addTarget:self
    //               action:@selector(submitButtonForLocationClicked:)
    //     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"SUBMIT" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor darkGrayColor];
    
    button.frame = CGRectMake(headerVw.frame.origin.x+80, zipCodeTextFiled.frame.origin.y+zipCodeTextFiled.frame.size.height+15, 100.0, 30.0);
    [headerVw addSubview:button];
    
    
    [[KGModal sharedInstance]setModalBackgroundColor:[UIColor whiteColor]];
    [[KGModal sharedInstance]setCloseButtonType:KGModalCloseButtonTypeNone];
    [[KGModal sharedInstance] showWithContentView:friendListVw andAnimated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"Noti";
    
    NotificationTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    } else
    {
        for (UIView *subview in [cell subviews])
        {
            [subview removeFromSuperview];
        }
    }
    if (WIN_WIDTH == 320) {
        if (indexPath.row == 0) {
            [cell.nameLbl setFrame:CGRectMake(8, 10,230, 21)];
        }
        else{
            [cell.nameLbl setFrame:CGRectMake(8, 10, 170, 21)];
            
        }
        [cell.dateLbl setFrame:CGRectMake(186, 10, 100, 21)];
        
    }
    else if (WIN_WIDTH == 414){
        [cell.dateLbl setFrame:CGRectMake(186, 10, 180
                                          , 21)];
    }
    //cell.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-90, 4, 100, 40)];
    [cell.mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:cell.mySwitch];
    [cell.mySwitch setHidden:YES];
    
    SingletonClass *customObj;
    if (arrayOfSwitch.count) {
        customObj = [arrayOfSwitch objectAtIndex:indexPath.row];
    }
    NSString *titleStr = [dataArray objectAtIndex:indexPath.row];
    selectIndexPath = indexPath.row;
    NSLog(@"indexPath %ld",(long)selectIndexPath);
    cell.nameLbl.text = titleStr;
    
    if(isEmpty) {
        
        cell.dateLbl.text = nil;
        
    } else {
        
        if ([titleStr isEqualToString:@"Online Only"] && (customObj.IsSwitchShow == YES) && (indexPath.row == 0)) {
            sharedInstance.switchSelctedForindexPath = NO;
            [cell.dateLbl setHidden:YES];
            [cell.mySwitch setHidden:NO];
            [cell.mySwitch setFrame:CGRectMake(self.view.frame.size.width-100, 4, 100, 40)];
            strForAvailableNowValue = sharedInstance.isOnlineFiltering;
            if([strForAvailableNowValue isEqualToString:@"1"]) {
                // Execute any code when the switch is ON
                NSLog(@"Switch is ON");
                [cell.mySwitch setOn:YES animated:YES];
                
            } else{
                // Execute any code when the switch is OFF
                NSLog(@"Switch is OFF");
                [cell.mySwitch setOn:NO animated:YES];
            }
            [cell.contentView addSubview:cell.mySwitch];
            cell.accessoryView = cell.mySwitch;
            //cell.accessoryType= UITableViewCellAccessoryNone;
        }
        else{
            [cell.mySwitch removeFromSuperview];
            [cell.contentView willRemoveSubview:cell.mySwitch];
            cell.accessoryView = NULL;
            
            //cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
        }
        
        if([titleStr isEqualToString:@"Location"] && (customObj.IsSwitchShow == NO)) {
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            cell.accessoryView = NULL;
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            
            [cell.mySwitch setHidden:YES];
            BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
            if (locationAllowed) {
                if (sharedInstance.checkLocationAutoOrGPS == NO) {
                    if (sharedInstance.latiValueStr.length) {
                        NSString *locationStrValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationDataValue"];
                        NSLog(@"Location%@",locationStrValue);
                        cell.dateLbl.text = @"Phone GPS";
                        // cell.dateLbl.text = locationStrValue;
                    }
                    else{
                        cell.dateLbl.text = @"Phone GPS";
                    }
                }
                else{
                    if ([sharedInstance.selectedAddressStr length]) {
                        NSString *locationStrValue = sharedInstance.selectedAddressStr;
                        cell.dateLbl.text = locationStrValue;
                    }
                    else{
                        NSString *locationStrValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"LocationDataValue"];
                        NSLog(@"Location%@",locationStrValue);
                        if ([locationStrValue length]) {
                            cell.dateLbl.text = locationStrValue;
                        }
                        else{
                            cell.dateLbl.text = @"Phone GPS";
                        }
                    }
                }
            }
            else {
                
                sharedInstance.latiValueStr = NULL;
                sharedInstance.longiValueStr = NULL;
                [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                             andButtonsWithTitle:@[@"OK"] onController:self
                                                   dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                       
                                                       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                       // [self performSelector:@selector(obj) withObject:self afterDelay:5];
                                                   }];
            }
        }
        
        else if([titleStr isEqualToString:@"Distance"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            
            if([sharedInstance.distanceStr length] == 0){
                cell.dateLbl.text =  @"0 - 100 mi";
            }
            else{
                cell.dateLbl.text =  sharedInstance.distanceStr;
            }
            
        }
        else if([titleStr isEqualToString:@"Type"] && (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            
            if([sharedInstance.strModelTypeName length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ModelTypeName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text =  sharedInstance.strModelTypeName;
            }
        }
        
        else if([titleStr isEqualToString:@"Body Type"] && (customObj.IsSwitchShow == NO) ) {
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictBodyType valueForKey:@"BodyTypeValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BodyTypeTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text =   [sharedInstance.dictBodyType valueForKey:@"BodyTypeValue"];
            }
        }
        else if([titleStr isEqualToString:@"Age"]&& (customObj.IsSwitchShow == NO)) {
            
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([sharedInstance.selectedStartAgeStr length] == 0){
                cell.dateLbl.text = @"18 - 99";
            }
            else{
                NSString *ageStrValue = [NSString stringWithFormat:@"%@ %@ %@",sharedInstance.selectedStartAgeStr,@"-",sharedInstance.selectedEndAgeStr] ;
                cell.dateLbl.text = ageStrValue;
            }
        }
        else if([titleStr isEqualToString:@"Ethincity"]&& (customObj.IsSwitchShow == NO)){
            
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForEthnicityValue valueForKey:@"EthnicityValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EthnicityTitle"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForEthnicityValue valueForKey:@"EthnicityValue"];
            }
        }
        
        else if([titleStr isEqualToString:@"Eye Color"]&& (customObj.IsSwitchShow == NO)) {
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            [cell.mySwitch setHidden:YES];
            cell.accessoryView = NULL;
            
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForEyeColorValue valueForKey:@"EyeColorValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EyeColorTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForEyeColorValue valueForKey:@"EyeColorValue"];
            }
        }
        
        else if([titleStr isEqualToString:@"Hair Color"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForHairValue valueForKey:@"HairColorValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HairColorTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForHairValue valueForKey:@"HairColorValue"];
            }
        }
        
        else if([titleStr isEqualToString:@"Smoking"]&& (customObj.IsSwitchShow == NO)) {
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForSmokingValue valueForKey:@"SmokingValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedSmokingDataValue"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForSmokingValue valueForKey:@"SmokingValue"];
            }
            
        }
        else if([titleStr isEqualToString:@"Drinking"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForDrinkingValue valueForKey:@"DrinkingValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectedDrinkingDataValue"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForDrinkingValue valueForKey:@"DrinkingValue"];
            }
            
            // cell.dateLbl.text = [dictForDrinkingValue valueForKey:@"DrinkingValue"];
            
        }
        else if([titleStr isEqualToString:@"Education"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([[sharedInstance.dictForEducationValue valueForKey:@"EducationValue"]length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EducationTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = [sharedInstance.dictForEducationValue valueForKey:@"EducationValue"];
            }
            
        }
        else if([titleStr isEqualToString:@"Language"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([sharedInstance.languageSelectedName length] == 0){
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LanguageSelectedTitle"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                cell.dateLbl.text =  @"Any";
            }
            else{
                cell.dateLbl.text = sharedInstance.languageSelectedName;
            }
        }
        
        else if([titleStr isEqualToString:@"Weight"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([sharedInstance.weightSliderStr length] == 0){
                cell.dateLbl.text = @"60 - 300 lbs.";
            }
            else{
                cell.dateLbl.text = sharedInstance.weightSliderStr;
            }
            
        }
        else if([titleStr isEqualToString:@"Height"]&& (customObj.IsSwitchShow == NO)) {
            
            [cell.contentView willRemoveSubview:cell.mySwitch];
            [cell.mySwitch setFrame:CGRectMake(0, 0, 0, 0)];
            [cell.mySwitch setHidden:YES];
            [cell.mySwitch removeFromSuperview];
            [cell.dateLbl setHidden:NO];
            cell.accessoryView = NULL;
            cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
            
            if([sharedInstance.heightSliderStr length] == 0){
                if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
                    cell.dateLbl.text = @"4'0'' - 8'0''";
                }
                else{
                    cell.dateLbl.text = @"122 cm - 244 cm";
                }
            }
            else
            {
                
                NSInteger startHeight =[sharedInstance.selectedStartHeightStr integerValue];
                NSInteger endHeight =[sharedInstance.selectedEndHeightStr integerValue];
                
                if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
                    
                    if (startHeight>=48 && endHeight <=96) {
                        
                        cell.dateLbl.text =[NSString stringWithFormat:@"%@ - %@",[CommonUtils ChangeIncheTofit:startHeight ],[CommonUtils ChangeIncheTofit:endHeight]];
                    }
                    else {
                        NSInteger minFoot =[CommonUtils ChangeCmToInche:[sharedInstance.selectedStartHeightStr integerValue]];
                        NSInteger maxFoot =[CommonUtils ChangeCmToInche:[sharedInstance.selectedEndHeightStr integerValue] ];
                        sharedInstance.selectedStartHeightStr = [NSString stringWithFormat:@"%ld",(long)minFoot];
                        sharedInstance.selectedEndHeightStr = [NSString stringWithFormat:@"%ld",(long)maxFoot];
                        cell.dateLbl.text =[NSString stringWithFormat:@"%@ - %@",[CommonUtils ChangeIncheTofit:minFoot ],[CommonUtils ChangeIncheTofit:maxFoot]];
                    }
                    
                }
                else {
                    if (startHeight>=48 && endHeight <=96) {
                        
                        cell.dateLbl.text =[NSString stringWithFormat:@"%ld cm - %ld cm",(long)[CommonUtils ChangeIncheToCm:[sharedInstance.selectedStartHeightStr integerValue] ],(long)[CommonUtils ChangeIncheToCm:[sharedInstance.selectedEndHeightStr integerValue]]];
                    }
                    else{
                        cell.dateLbl.text =[NSString stringWithFormat:@"%ld cm - %ld cm",(long)startHeight,endHeight];
                        
                    }
                    
                }
                
            }
        }
    }
    //    if ([titleStr isEqualToString:@"Online Only"] && (customObj.IsSwitchShow == YES)) {
    //        [cell.contentView addSubview:cell.mySwitch];
    //        cell.accessoryView = cell.mySwitch;
    //        cell.accessoryType= UITableViewCellAccessoryNone;
    //    }
    //    else{
    //        [cell.mySwitch removeFromSuperview];
    //        [cell.contentView willRemoveSubview:cell.mySwitch];
    //        cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    //
    //    }
    
    
    return cell;
}

-(void)obj{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loactionUpdate" object:nil userInfo:nil];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    isEmpty = FALSE;
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    typeValueStr = cell.dateLbl.text;
    NSLog(@"Value of %@",typeValueStr);
    if(indexPath.row==5) {
        //  [self pickerViewShow];
        AgeFilterViewController *ageView = [self.storyboard instantiateViewControllerWithIdentifier:@"ageFilterViewController"];
        [self.navigationController pushViewController:ageView animated:YES];
    } else {
        
        if((indexPath.row == 0) ||(indexPath.row == 1) ||(indexPath.row == 2) || (indexPath.row == 3) || (indexPath.row == 4) || (indexPath.row == 6) ||(indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 9) || (indexPath.row == 10) || (indexPath.row == 11) || (indexPath.row == 12)|| (indexPath.row == 13)|| (indexPath.row == 14)) {
            UpdateProfileSelectionViewController *profileView;
            
            LocationViewController *locationView;
            locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"locationView"];
            profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
            profileView.typeValueStr = typeValueStr;
            UseGPSLocationFilterViewController *gpsLocationView = [self.storyboard instantiateViewControllerWithIdentifier:@"locationGPSView"];
            DistanceFilterViewController *distanceFilterView = [self.storyboard instantiateViewControllerWithIdentifier:@"distanceFilterViewController"];
            WeightFilterViewController *weightFilterView = [self.storyboard instantiateViewControllerWithIdentifier:@"weightFilterViewController"];
            HeightFilterViewController *heightFilterView = [self.storyboard instantiateViewControllerWithIdentifier:@"heightFilterViewController"];
            
            NSString *locationGPSStr;
            NSString *distanceStr;
            NSString *heightStr;
            NSString *weightStr;
            
            switch (indexPath.row) {
                case 0:
                    locationGPSStr = @"";
                    break;
                case 1:
                    locationGPSStr = @"GPS";
                    break;
                case 2:
                    distanceStr = @"Distance";
                    break;
                case 3:
                    profileView.titleStr = @"Type";
                    break;
                case 4:
                    profileView.titleStr = @"Body Type";
                    break;
                case 5:
                    break;
                case 6:
                    profileView.titleStr = @"Ethnicity";
                    break;
                case 7:
                    heightStr = @"Height";
                    //                profileView.titleStr = @"Height";
                    break;
                case 8:
                    //                profileView.titleStr = @"Weight";
                    weightStr = @"Weight";
                    break;
                case 9:
                    profileView.titleStr = @"Eye Color";
                    break;
                case 10:
                    profileView.titleStr = @"Hair Color";
                    break;
                case 11:
                    profileView.titleStr = @"Smoking";
                    break;
                case 12:
                    profileView.titleStr = @"Drinking";
                    break;
                case 13:
                    profileView.titleStr = @"Education";
                    break;
                case 14:
                    profileView.titleStr = @"Language";
                    break;
                case 15:
                default:
                    break;
            }
            
            profileView.isCheckedFilterValue = YES;
            
            if([locationView.titleStr isEqualToString:@"Location"])
            {
                [self.navigationController pushViewController:locationView animated:YES];
                
            }
            else if([locationGPSStr isEqualToString:@"GPS"]){
                
                [self.navigationController pushViewController:gpsLocationView animated:YES];
                
            }
            else if([distanceStr isEqualToString:@"Distance"]){
                
                [self.navigationController pushViewController:distanceFilterView animated:YES];
                
            }
            else if([heightStr isEqualToString:@"Height"]){
                
                [self.navigationController pushViewController:heightFilterView animated:YES];
                
            }
            else if([weightStr isEqualToString:@"Weight"]){
                
                [self.navigationController pushViewController:weightFilterView animated:YES];
                
            }
            else if(!(indexPath.row == 0)){
                [self.navigationController pushViewController:profileView animated:YES];
            }
        }
    }
}

#pragma mark:- UISwitch Button Action Method
- (void)changeSwitch:(id)sender {
    
    if([sender isOn]) {
        // Execute any code when the switch is ON
        NSLog(@"Switch is ON");
        strForAvailableNowValue = @"1";
        //  [sortTable reloadData];
        
    } else{
        // Execute any code when the switch is OFF
        NSLog(@"Switch is OFF");
        strForAvailableNowValue = @"0";
        //   [sortTable reloadData];
    }
    sharedInstance.isOnlineFiltering = strForAvailableNowValue;
    [[NSUserDefaults standardUserDefaults] setObject:strForAvailableNowValue forKey:@"AvailableSwitchValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Online Value %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AvailableSwitchValue"]);
}

#pragma mark PickerView DataSource Delegate Method

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return arrAgePickerView.count;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    ageStr = [NSString stringWithFormat:@"%@", [arrAgePickerView objectAtIndex:row]];
    [[NSUserDefaults standardUserDefaults]setObject:ageStr forKey:@"AgeDataValue"];
    [sortTable reloadData];
    // [self.pickerView removeFromSuperview];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [arrAgePickerView objectAtIndex:row];
    
}

- (void)pickerViewShow {
    
    CGFloat viewHeight = [[self view] frame].size.height;
    CGFloat pickerHeight;
    viewForPicker = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight - pickerHeight-200, self.view.bounds.size.width, pickerHeight+200)];
    viewForPicker.backgroundColor = [UIColor whiteColor];
    
    self.pickerView = [[UIPickerView alloc] init];
    pickerHeight = [self.pickerView frame].size.height;
    //[self.pickerView setFrame:CGRectMake(0, viewHeight - pickerHeight, self.view.bounds.size.width, pickerHeight)];
    
    [self.pickerView setFrame:CGRectMake(0, 44, self.view.bounds.size.width, viewForPicker.frame.size.height-43)];
    self.pickerView.backgroundColor = [UIColor grayColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [[self view] addSubview:viewForPicker];
    [viewForPicker addSubview:self.pickerView];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.pickerView.frame.size.width,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(pickerViewDoneButtonClicked:)];
    toolBar.items = @[barButtonDone];
    barButtonDone.tintColor=[UIColor whiteColor];
    [viewForPicker addSubview:toolBar];
    
}

- (void)pickerViewDoneButtonClicked:(id)sender {
    NSLog(@"Done Clicked.");
    viewForPicker.hidden = YES;
}

#pragma mark UIButto ACtion Method Call
- (void)submitButtonForAgeClicked:(UIButton*)button {
    
    ageStr = [NSString stringWithFormat:@"%@",ageTextFiled.text];
    [[NSUserDefaults standardUserDefaults]setObject:ageStr forKey:@"AgeDataValue"];
    
    [[KGModal sharedInstance]hideWithCompletionBlock:^{
        
    }];
    
    [sortTable reloadData];
}

- (IBAction)backBtnClicked:(id)sender {
    
    //[[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"ApplyFilter"];
    NSString *filterApplyStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"ApplyFilter"];
    
    if ([filterApplyStr isEqualToString:@"No"]) {
        [self clearUpdatedtableValue];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)resetBtnClicked:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AvailableNowValue"];
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"AvailableNowValueOnline"];
    [[NSUserDefaults standardUserDefaults]setObject:@"No" forKey:@"ApplyFilter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [self clearUpdatedtableValue];
    isEmpty = false;
    // [sortTable reloadData];
}

- (IBAction)searchBtnClicked:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"Yes" forKey:@"ApplyFilter"];
    [[NSUserDefaults standardUserDefaults]setInteger:segmentedControl1.selectedSegmentIndex forKey:@"SortdirectionSelectedSegmentIndexValue"];
    NSString *strForsortDirectionValue;
    
    switch (segmentedControl1.selectedSegmentIndex) {
        case 0:{
            strForsortDirectionValue =@"Nearest";
        }
            break;
        case 1:{
            strForsortDirectionValue =@"Farthest";
        }
            break;
        case 2:
        {
            strForsortDirectionValue =@"Newest";
        }
            break;
        case 3:
        {
            strForsortDirectionValue =@"Oldest";
        }
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]setObject:strForsortDirectionValue forKey:@"SortDirectionValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark :- Segment Method Call

- (IBAction)secondSegmentControlBtnClicked:(UISegmentedControl *)sControl {
    
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"SortByValue"];
    //segmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    NSString *strForsortDirectionValue;
    
    switch (sControl.selectedSegmentIndex) {
        case 0:{
            strForsortDirectionValue =@"Nearest";
            segmentedControl1.selectedSegmentIndex = sControl.selectedSegmentIndex;
        }
            break;
        case 1:{
            strForsortDirectionValue =@"Farthest";
            segmentedControl1.selectedSegmentIndex = sControl.selectedSegmentIndex;
        }
            break;
        case 2:
        {
            strForsortDirectionValue =@"Newest";
            segmentedControl1.selectedSegmentIndex = sControl.selectedSegmentIndex;
        }
            break;
        case 3:
        {
            strForsortDirectionValue =@"Oldest";
            segmentedControl1.selectedSegmentIndex = sControl.selectedSegmentIndex;
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:strForsortDirectionValue forKey:@"SortDirectionValue"];
    [[NSUserDefaults standardUserDefaults]setInteger:segmentedControl1.selectedSegmentIndex forKey:@"SortdirectionSelectedSegmentIndexValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//- (IBAction)availableNowSecondSegmentControlBtnClicked:(UISegmentedControl *)sender
//{
//    NSString *strForAvailableValue;
//
//    switch (sender.selectedSegmentIndex) {
//        case 0:
//            strForAvailableValue =@"1";
//            availableNowSegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
//            break;
//        case 1:
//            strForAvailableValue =@"2";
//            availableNowSegmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex;
//            break;
//        default:
//            break;
//    }
//
//    [[NSUserDefaults standardUserDefaults] setObject:strForAvailableNowValue forKey:@"AvailableNowValue"];
//    [[NSUserDefaults standardUserDefaults]setInteger:availableNowSegmentedControl.selectedSegmentIndex forKey:@"AvailableNowSegmentIndexValue"];
//}

#pragma mark :- Set FIlterDate Vaye
- (void)setFilterVlaueData {
    
    dictForTypeDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedTypeDataValue"];
    dictForBodyTypeDataValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedBodyTypeDataValue"];
    dictForEthnicityValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEthnicityDataValue"];
    dictForEyeColorValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEyeColorDataValue"];
    dictForHairValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedHairColorDataValue"];
    dictForEducationValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedEducationDataValue"];
    dictForSmokingValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedSmokingDataValue"];
    dictForDrinkingValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedDrinkingDataValue"];
    dictForLanguageValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedLanguageDataValue"];
    dictForWeightValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedWeightDataValue"];
    dictForHeightValue= [[NSUserDefaults standardUserDefaults]objectForKey:@"SelectedHeightDataValue"];
    languageSelectedName = [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSelectedTitle"];
    
}


- (void)clearUpdatedtableValue {
    
    segmentedControl1.selectedSegmentIndex = 0;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SortByValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AvailableSwitchValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SortBySelectedSegmentIndexValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SortDirectionValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SortdirectionSelectedSegmentIndexValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CountryDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"StateDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CityDataValue"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EthnicityTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ZipCodeDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SliderValueDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedTypeDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedBodyTypeDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEthnicityDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEyeColorDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedEducationDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedHairColorDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedSmokingDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedDrinkingDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedLanguageDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AgeDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedWeightDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedHeightDataValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LanguageSelectedTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ModelTypeName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EyeColorTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"HairColorTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"EducationTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AvailableNowValue"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"BodyTypeTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"AvailableNowValueOnline"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ModelTypeName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DrinkingTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SmokingTitle"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LanguageSelectedTitle"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self resetValue];
}

-(void)resetValue {
    
    sharedInstance.checkLocationAutoOrGPS = NO;
    strForAvailableNowValue = @"0";
    sharedInstance.distanceStr = @"";
    sharedInstance.strModelTypeName =  @"Any";
    sharedInstance.strContractorEthencityTypeFilter =  @"-1";
    sharedInstance.strContractorSmokingTypeFilter =  @"-1";
    sharedInstance.strContractorTypeFilter =  @"-1";
    sharedInstance.strContractorEthencityTypeFilter =  @"-1";
    sharedInstance.strContractorDrinkingTypeFilter =  @"-1";
    sharedInstance.strContractorHairColorTypeFilter =  @"-1";
    sharedInstance.strContractorEyeColorTypeFilter =  @"-1";
    sharedInstance.strContractorEducationTypeFilter =  @"-1";
    sharedInstance.selectedAddressStr = @"";
    [sharedInstance.dictBodyType setValue:@"Any" forKey:@"BodyTypeValue"];
    [sharedInstance.dictForEthnicityValue setValue:@"Any" forKey:@"EthnicityValue"];
    [sharedInstance.dictForEyeColorValue  setValue:@"Any" forKey:@"EyeColorValue"];
    [sharedInstance.dictForHairValue setValue:@"Any" forKey:@"HairColorValue"];
    [sharedInstance.dictForSmokingValue setValue:@"Any" forKey:@"SmokingValue"];
    [sharedInstance.dictForDrinkingValue setValue:@"Any" forKey:@"DrinkingValue"];
    [sharedInstance.dictForEducationValue setValue:@"Any" forKey:@"EducationValue"];
    // [sharedInstance.dictForEducationValue setValue:@"0" forKey:@"AvailableSwitchValue"];
    sharedInstance.languageSelectedName =  @"Any";
    sharedInstance.selectedStartAgeStr = @"18";
    sharedInstance.selectedEndAgeStr = @"99";
    sharedInstance.weightSliderStr = @"60 - 300 lbs.";
    sharedInstance.selectedStartWeightStr = @"60";
    sharedInstance.selectedEndWeightStr= @"300";
    sharedInstance.strContractorLanguageTypeFilter = @"";
    if ([sharedInstance.strUnityTypeValue isEqualToString:@"1"]) {
        sharedInstance.selectedStartHeightStr = @"48";
        sharedInstance.selectedEndHeightStr = @"96";
        sharedInstance.heightSliderStr = @"4'0'' - 8'0''";
        
    }
    else{
        sharedInstance.selectedStartHeightStr = @"122";
        sharedInstance.selectedEndHeightStr = @"244";
        sharedInstance.heightSliderStr = @"122 cm - 244 cm";
    }
    sharedInstance.distanceIntegerStr = @"100";
    sharedInstance.isOnlineFiltering = @"0";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
        [sortTable reloadData];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
