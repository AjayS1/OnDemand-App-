//
//  ChooseLocationViewController.m
//  Customer
//
//  Created by Aaditya on 07/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ChooseLocationViewController.h"

#define GOOGLE_API_BASE_URLs @"https://maps.googleapis.com/maps/api/place/autocomplete/"
#define GOOGLE_API_BASE_URL_DETAIL @"https://maps.googleapis.com/maps/api/place/details/"
#define GOOGLE_API_KEY   @"AIzaSyA9vKbjaI34G78bF4wyNcKaD3k6zn4aNE0"


@interface ChooseLocationViewController () <UITableViewDelegate,UITableViewDataSource,AutoLocationDelegtae,UITextFieldDelegate,AutocompletionTableViewDelegate,CLLocationManagerDelegate>{
    
    float height;
    SingletonClass *sharedInsatnce;
    NSInteger selectedIndex;
    NSInteger selectedSection;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    BOOL isAlphbet;
    PlaceObj *sharedObject;
    NSMutableArray *arrDataSource;
    NSMutableArray *arrayZipCodeDate;
    NSMutableArray *arrayOfRowDate;
    NSMutableArray *arrayAllLocationData;
    NSMutableArray *arrayFilteredLocationData;
    NSMutableArray *arrayOfLocationID;
    NSArray *searchResults;
}

@property (strong, nonatomic) IBOutlet UITextField *textFieldSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableViewSearchBar;
@property (nonatomic, strong) CLGeocoder* geocoder;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    arrDataSource = [NSMutableArray array];
    arrayZipCodeDate = [NSMutableArray array];
    arrayAllLocationData = [NSMutableArray array];
    arrayOfRowDate = [NSMutableArray array];
    arrayFilteredLocationData = [NSMutableArray array];
    arrayOfLocationID = [NSMutableArray array];
    searchResults = [NSMutableArray array];
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0"];
    [self CustomizeTextField];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    sharedInsatnce = [SingletonClass sharedInstance];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    _tableViewSearchBar.estimatedRowHeight = 80;
    _tableViewSearchBar.rowHeight = UITableViewAutomaticDimension;

    sharedInsatnce.strChooseLocationName = @"";
    [self getCustomAddressApiCall];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) CustomizeTextField {
    
    UIColor *color = [UIColor lightGrayColor];
    UIView *padding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.textFieldSearchBar.leftView = padding;
    self.textFieldSearchBar.leftViewMode = UITextFieldViewModeAlways;
    self.textFieldSearchBar.attributedPlaceholder =[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: color}];
    self.textFieldSearchBar.returnKeyType = UIReturnKeySearch;
    self.textFieldSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textFieldSearchBar.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [_textFieldSearchBar addTarget:self
                            action:@selector(editingChanged:)
                  forControlEvents:UIControlEventEditingChanged];
}

#pragma  mark - UItextField Delegate Methods

-(void) editingChanged:(UITextField *)sender {
    [self searchLocationWithString:sender.text];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO; // return NO to not change text
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textFieldSearchBar.text = textField.text;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    AddressAutoCompleteViewController *gpsLocationView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressAutoCompleteView"];
    gpsLocationView.delegate = self;
    gpsLocationView.isFromRequestNow = YES;
    gpsLocationView.isFromGPSLocation = NO;
    [self presentViewController:gpsLocationView animated:YES completion:nil];
    return NO;
}

-(void)locationString :(NSString*)str {
    
   // [self.delegate locationString:str];
    if (str.length) {
        [self.delegate locationStringValue:str];
        sharedInsatnce.strChooseLocationName = str ;
        [self.textFieldSearchBar setText:str];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark:- Searching Method Implemented

-(void)searchLocationWithString:(NSString *)searchText {
    
    //  searchQuery.location = currentLocation.coordinate;
    searchQuery.input = searchText;
    sharedInsatnce.checkisSearchAllOverTheArea = YES;
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        NSLog(@"Error%@",error.localizedDescription);
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not fetch Places"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            
            _autoCompleter.suggestionsDictionary =  places;
            [self.autoCompleter textFieldValueChanged:_textFieldSearchBar];
        }
    }];
}

- (AutocompletionTableView *)autoCompleter {
    
    if (!_autoCompleter) {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:_textFieldSearchBar inViewController:self withOptions:options];
        _autoCompleter.backgroundColor =[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
        _autoCompleter.autoCompleteDelegate = self;
    }
    return _autoCompleter;
    
}

- (NSArray*) autoCompletion:(AutocompletionTableView*) completer suggestionsFor:(NSString*) string{
    
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
    NSLog(@"suggestions---%@",_autoCompleter.suggestionsDictionary);
    return _autoCompleter.suggestionsDictionary;
    
}

- (void) autoCompletion:(AutocompletionTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index withString:(NSString *)str{
    
    _textFieldSearchBar.text = str;
    [_textFieldSearchBar resignFirstResponder];
    [self checkThatTextIsNeumeric:_textFieldSearchBar.text];
    if (!self.geocoder) {
        
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    [self.geocoder geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            
            NSString  *streetStr = [CommonUtils checkStringForNULL:placemark.thoroughfare];
            NSLog(@"streetStr %@",streetStr);
            
            NSString  *  cityStr = [CommonUtils checkStringForNULL:placemark.locality];
            NSString  *    stateStr = [CommonUtils checkStringForNULL:placemark.administrativeArea];
            NSString  *countryStr = [CommonUtils checkStringForNULL:placemark.country];
            if (!countryStr.length) {
                countryStr = @"";
            }
            if (!cityStr.length) {
                cityStr = @"";
            }
            if (!stateStr.length) {
                stateStr = @"";
            }
            
            NSString  * zipCodeStr = [CommonUtils checkStringForNULL:placemark.postalCode];
            CLLocation *location = placemark.location;
            NSLog(@"location %@",location);
            float latitude=  location.coordinate.latitude;
            float longitude= location.coordinate.longitude;
            
            if (!zipCodeStr.length) {
                zipCodeStr = @"";
            }
            sharedInsatnce.strChooseLocationName = @"";
            sharedInsatnce.strChooseLocationName = locatedAt;
            NSLog(@"Location Address %@", sharedInsatnce.strChooseLocationName );
            if (sharedInsatnce.strChooseLocationName) {
                sharedInsatnce.meetUpLocationLattitude =[NSString stringWithFormat:@"%f",latitude];
                sharedInsatnce.meetUpLocationLongtitude = [NSString stringWithFormat:@"%f",longitude];
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate locationStringValue:sharedInsatnce.strChooseLocationName];
            }
        }
    }];
}

-(void) checkThatTextIsNeumeric:(NSString *)neumericString{
    NSString *string=neumericString;
    NSString *firstChar=[string substringToIndex:1];
    const char *character=[firstChar UTF8String];
    
    int intValue=(int)*character;//converted to ascii, however you can directly compare to character to 'a' and 'z'
    
    if ((intValue >= 97 && intValue <=122) || (intValue >= 65 && intValue <=90)) {
        NSLog(@"Alphabet");
        isAlphbet = NO;
    }
    else {
        isAlphbet = YES;
        NSLog(@"Non alphabet");
    }
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    //count of section
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    
    switch (section) {
        case 0:
            return 40;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewSearchBar.frame.size.width, 40)];
    if (section == 0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, self.tableViewSearchBar.frame.size.width, 1)];
        lbl.backgroundColor = [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
        UIButton *BtnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
        BtnLocation.frame = CGRectMake(10.0,0,lbl.frame.size.width,39.0);
        BtnLocation.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [BtnLocation setTitle:@"+ Add a Custom Location" forState:UIControlStateNormal];
        BtnLocation.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        BtnLocation.backgroundColor = [UIColor whiteColor];
        [BtnLocation setTitleColor:[UIColor colorWithRed:191/255.0f green:151/255.0f blue:197/255.0f alpha:1.0] forState:UIControlStateNormal];
        [BtnLocation addTarget:self action:@selector(btnCustomLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:BtnLocation];
        [headerView addSubview:lbl];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:{
            if (arrayAllLocationData.count) {
                return [arrayAllLocationData count];
            }
        }
            break;
        case 1:{
            if (arrDataSource.count) {
                return [arrDataSource count];
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

/*
 
 */


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"ChooseLocationCell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-dark.png"]];
    [imageView setFrame:CGRectMake(0, 0, 15, 15)];
    if (_isSearchApply) {
        if (searchResults.count) {
            SingletonClass *customObj= [searchResults objectAtIndex:indexPath.row];
            cell.labelName.text = customObj.locationName;
            
            //            if (arrayZipCodeDate.count) {
            //                PlaceObj *custObj = [arrayZipCodeDate objectAtIndex:indexPath.row];
            //                [cell.labelAddress setText:[NSString stringWithFormat:@"%@, %@%@",customObj.locationAddress,custObj.placeStateAbbribiation,custObj.placeZipCode]];
            //            }
            //            else{
            cell.labelAddress.text = customObj.locationAddress;
            //}
            
            if(customObj.checkLocationStr == YES)
            {
                cell.accessoryView = imageView;
                customObj.checkLocationStr = NO;
            }
            else
            {
                cell.accessoryView = NULL;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else
    {
        switch (indexPath.section) {
                
            case 0:{
                if (arrayAllLocationData.count) {
                    SingletonClass *customObj= [arrayAllLocationData objectAtIndex:indexPath.row];
                    cell.labelName.text = customObj.locationName;
                    //[self callGetDetailForPlaceID:customObj.placeID withIndexPath:indexPath];
                    //                if (arrayZipCodeDate.count) {
                    //                    PlaceObj *custObj = [arrayZipCodeDate objectAtIndex:indexPath.row];
                    //                    [cell.labelAddress setText:[NSString stringWithFormat:@"%@, %@%@",customObj.locationAddress,custObj.placeStateAbbribiation,custObj.placeZipCode]];
                    //                }
                    //                else{
                    cell.labelAddress.text = customObj.locationAddress;
                    //  }
                    if(customObj.checkLocationStr == YES){
                        cell.accessoryView = imageView;
                        customObj.checkLocationStr = NO;
                    }
                    else    {
                        cell.accessoryView = NULL;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                }
            }
                break;
                
            case 1:{
                if (arrDataSource.count) {
                    SingletonClass *customObj= [arrDataSource objectAtIndex:indexPath.row];
                    cell.labelName.text = customObj.locationName;
                    //  [self callGetDetailForPlaceID:customObj.placeID withIndexPath:indexPath];
                    
                    //                if (arrayZipCodeDate.count) {
                    //                    PlaceObj *custObj = [arrayZipCodeDate objectAtIndex:indexPath.row];
                    //                    [cell.labelAddress setText:[NSString stringWithFormat:@"%@, %@%@",customObj.locationAddress,custObj.placeStateAbbribiation,custObj.placeZipCode]];
                    //                }
                    //                else{
                    cell.labelAddress.text = customObj.locationAddress;
                    //   }
                    if(customObj.checkLocationStr == YES){
                        cell.accessoryView = imageView;
                        customObj.checkLocationStr = NO;
                        
                    }
                    else {
                        cell.accessoryView = NULL;
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                }
            }
            default:
                break;
        }
    }
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    if (indexPath.section == 0)
        return YES;
    else
        return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            if (arrayAllLocationData.count) {
                //arrayOfLocationID = [SingletonClass parselocationData:arrayAllLocationData];
                SingletonClass *sharedInst = [arrayAllLocationData objectAtIndex:indexPath.row];
                [self deleteCustomLocationApiWithLocationID:sharedInst.locationID];
            }
            //add code here for when you hit delete
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndex = indexPath.row;
    selectedSection =indexPath.section;
    
    if (_isSearchApply) {
        
        SingletonClass *customObj= [searchResults objectAtIndex:indexPath.row];
        
        if (!customObj.checkLocationStr) {
            
            customObj.checkLocationStr = YES;
            sharedInsatnce.strChooseLocationName = [NSString stringWithFormat:@"%@,%@",customObj.locationName,customObj.locationAddress];
            [self getLatLongFromAddressWithString:sharedInsatnce.strChooseLocationName WithLocationName:customObj.locationName];
            NSLog(@"Location Address %@", sharedInsatnce.strChooseLocationName );
        }
        else {
            
            customObj.checkLocationStr = NO;
            customObj.strChooseLocationName = @"";
        }
    }
    
    else
    {
        switch (selectedSection) {
            case 0:{
                SingletonClass *customObj= [arrayAllLocationData objectAtIndex:indexPath.row];
                if (!customObj.checkLocationStr) {
                    customObj.checkLocationStr = YES;
                    sharedInsatnce.strChooseLocationName = [NSString stringWithFormat:@"%@",customObj.locationAddress];
                    [self getLatLongFromAddressWithString:sharedInsatnce.strChooseLocationName WithLocationName:@""];
                    NSLog(@"Location Address %@", sharedInsatnce.strChooseLocationName );
                }
                else {
                    customObj.checkLocationStr = NO;
                    customObj.strChooseLocationName = @"";
                }
            }
                break;
                
            case 1:{
                
                SingletonClass *customObj= [arrDataSource objectAtIndex:indexPath.row];
                if (!customObj.checkLocationStr) {
                    customObj.checkLocationStr = YES;
                    sharedInsatnce.strChooseLocationName = [NSString stringWithFormat:@"%@,%@",customObj.locationName,customObj.locationAddress];
                    [self getLatLongFromAddressWithString:sharedInsatnce.strChooseLocationName WithLocationName:customObj.locationName];
                    NSLog(@"Location Address %@", sharedInsatnce.strChooseLocationName );
                    
                }
                
                else {
                    customObj.checkLocationStr = NO;
                    customObj.strChooseLocationName = @"";
                }
            }
                break;
            default:
                break;
        }
    }
    [_tableViewSearchBar reloadData];
}

#pragma mark - Get Label Height

- (CGFloat)getLabelHeight:(UILabel*)label {
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height;
}

#pragma mark:- Button Action Methode

- (void)btnCustomLocationClicked:(UIButton *)sender{
    
    AddressValidateViewController *addressValidationView = [self.storyboard instantiateViewControllerWithIdentifier:@"addressValidateView"];
    [self.navigationController pushViewController:addressValidationView animated:YES];
}

- (IBAction)buttonBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate locationStringValue:sharedInsatnce.strChooseLocationName];
}

-(void)callOperationQueueMethode{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
}

#pragma mark:- Api For Google Place API
- (void)callApiToSearchGooglePlaces{
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    if (locationAllowed) {
        NSString *latitudeStr = sharedInsatnce.latiValueStr;
        NSString *lonitudeStr = sharedInsatnce.longiValueStr;
        if ([latitudeStr length] && [lonitudeStr length]) {
          // NSString *strLocation = [NSString stringWithFormat:@"%@,%@",@"34.11922076970851",@"-118.1347215302915"];
           NSString *strLocation = [NSString stringWithFormat:@"%@,%@",sharedInsatnce.latiValueStr,sharedInsatnce.longiValueStr];
            NSLog(@"Location is: %@",strLocation);
            
            NSString *urlstr=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=%@&radius=%@&type=%@&keyword=&key=%@",strLocation,@"6000",@"bar",@"AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0"];
            NSLog(@"Google Url is :%@",urlstr);
            
            
            NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForGooglePlace:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Post Contractor Search List %@",responseObject);
                [ProgressHUD dismiss];
                
                if(!error)
                {
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
                        [arrayFilteredLocationData removeAllObjects];
                        [arrDataSource removeAllObjects];
                        [arrayFilteredLocationData removeAllObjects];
                        NSArray *arrData = [responseObject objectForKey:@"results"];
                        arrDataSource = [SingletonClass parselocationFromGoogleData:arrData];
                        [arrayFilteredLocationData addObjectsFromArray:arrDataSource];
                        [arrayFilteredLocationData addObjectsFromArray:arrayAllLocationData];
                        NSLog(@"Filtering Array >>>>>%@",arrayFilteredLocationData);
                        [self.tableViewSearchBar reloadData];
                    }
                    
                    else {
                        [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"status"] inController:self];
                    }
                }
                else{
                    [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"status"] inController:self];
                }
            }];
        }
        
        else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LATITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LONGITUDEDATA"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[AlertView sharedManager] presentAlertWithTitle:@"Sorry!" message:@"We did not fetch your location.Do you want again to find the location?"
                                         andButtonsWithTitle:@[@"No",@"Yes"] onController:self
                                               dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                                   if ([buttonTitle isEqualToString:@"Yes"]) {
                                                       if ([APPDELEGATE locationManager] != nil) {
                                                           [[APPDELEGATE locationManager] startUpdatingLocation];
                                                       }
                                                       else {
                                                           APPDELEGATE.locationManager= [[CLLocationManager alloc] init];
                                                           APPDELEGATE.locationManager.delegate = self;
                                                           APPDELEGATE.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
                                                           [APPDELEGATE.locationManager requestWhenInUseAuthorization];
                                                           [APPDELEGATE.locationManager startUpdatingLocation];
                                                       }
                                                   }
                                               }];
        }
    }
    else
    {
        sharedInsatnce.latiValueStr = @"28.616789";
        sharedInsatnce.longiValueStr = @"77.74756";
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LocationDataValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           }];
    }
}



-(void)callGetDetailForPlaceID:(NSString*)placeID {
    
    NSString   *requestStr = [NSString stringWithFormat:@"%@json?placeid=%@&key=%@",GOOGLE_API_BASE_URL_DETAIL,placeID,GOOGLE_API_KEY];
    //requestStr = [requestStr stringByReplacingOccurrencesOfString:@"-" withString:@"%2D"];
    [ServerRequest AFNetworkPostRequestUrlForGooglePlace:requestStr withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error) {
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
                arrayZipCodeDate = [[NSMutableArray alloc]init];
                [arrayZipCodeDate removeAllObjects];
                sharedObject = [SingletonClass parsePlaceDetailResponse:responseObject andError:error];
                [arrayZipCodeDate addObject:sharedObject];
                NSLog(@"Object Array >>>>>%lu",(unsigned long)arrayZipCodeDate.count);
            }
        }
    }];
}

#pragma mark Add Custom Address Api Call

- (void)getCustomAddressApiCall {
    
    NSString *userIdStr = sharedInsatnce.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@",APIGetCustomLocationCall,userIdStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrlForGetCustomLocation:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        if(!error) {
            NSLog(@"Response is --%@",responseObject);
            [arrayAllLocationData removeAllObjects];
            
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                NSArray *customLocation = [responseObject objectForKey:@"Address"];
                arrayAllLocationData = [SingletonClass parselocationFromCustomData:customLocation];
                //NSLog(@"Array Of Custom Location %@",[arrayAllLocationData objectAtIndex:1]);
                [self callApiToSearchGooglePlaces];
            }
            else if ([[responseObject objectForKey:@"StatusCode"] intValue] == 0)
            {
                [self callApiToSearchGooglePlaces];
            }
            else {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

#pragma mark Delete Custom Address Api Call

- (void)deleteCustomLocationApiWithLocationID:(NSString *)loactionID{
    
    NSString *userIdStr = sharedInsatnce.userId;
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&locationID=%@",APIDeleteCustomLocationCall,userIdStr,loactionID];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error) {
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [arrayAllLocationData removeAllObjects];
                [arrDataSource removeAllObjects];
                [self getCustomAddressApiCall];
                [self.tableViewSearchBar reloadData];
            }
            else
            {
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
}

-(void)getLatLongFromAddress :(NSString *)address{
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSLog(@"Location %@",locatedAt);
            NSString  *streetStr = [CommonUtils checkStringForNULL:placemark.thoroughfare];
            NSLog(@"streetStr %@",streetStr);
            NSString  *  cityStr = [CommonUtils checkStringForNULL:placemark.locality];
            NSString  *    stateStr = [CommonUtils checkStringForNULL:placemark.administrativeArea];
            NSString  *countryStr = [CommonUtils checkStringForNULL:placemark.country];
            
            if (!countryStr.length) {
                countryStr = @"";
            }
            if (!cityStr.length) {
                cityStr = @"";
            }
            if (!stateStr.length) {
                stateStr = @"";
            }
            
            NSString  * zipCodeStr = [CommonUtils checkStringForNULL:placemark.postalCode];
            CLLocation *location = placemark.location;
            NSLog(@"location %@",location);
            float latitude=  location.coordinate.latitude;
            float longitude= location.coordinate.longitude;
            if (!zipCodeStr.length) {
                zipCodeStr = @"";
            }
            sharedInsatnce.meetUpLocationLattitude =[NSString stringWithFormat:@"%f",latitude];
            sharedInsatnce.meetUpLocationLongtitude = [NSString stringWithFormat:@"%f",longitude];
            if ([sharedInsatnce.meetUpLocationLattitude length]) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate locationStringValue:sharedInsatnce.strChooseLocationName];
            }
        }
    }];
}

-(void)getLatLongFromAddressWithString :(NSString *)address WithLocationName:(NSString *)locationName
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)address,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSString *jsonString = result;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"Formated String %@",json);
    
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
        if ((latitude == 0) || (longitude == 0)) {
            [self getLatLongFromAddress:address];
        }
        else
        {
            sharedInsatnce.meetUpLocationLattitude = [NSString stringWithFormat:@"%f",latitude];
            sharedInsatnce.meetUpLocationLongtitude = [NSString stringWithFormat:@"%f",longitude];
            if (sharedInsatnce.meetUpLocationLattitude) {
                NSArray *locationArray = [[json objectForKey:@"results"] valueForKey:@"formatted_address"];
                if ([locationName length]) {
                    sharedInsatnce.strChooseLocationName = [NSString stringWithFormat:@"%@, %@",locationName,[locationArray firstObject]] ;
                }
                else{
                    sharedInsatnce.strChooseLocationName = [NSString stringWithFormat:@"%@",[locationArray firstObject]] ;

                }
                if ([sharedInsatnce.meetUpLocationLattitude length] || [sharedInsatnce.meetUpLocationLongtitude length]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.delegate locationStringValue:sharedInsatnce.strChooseLocationName];
                }
                NSLog(@"Proper Address %@",sharedInsatnce.strChooseLocationName);
                      }
        }
    }
    else
    {
        [self getLatLongFromAddress:address];
    }
}


@end
