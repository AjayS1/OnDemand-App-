
//  AddressValidateViewController.m
//  Customer
//  Created by Jamshed Ali on 25/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "AddressValidateViewController.h"
#define GOOGLE_GEOLOCATION_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/"
#define GOOGLE_API_BASE_URL_DETAIL @"https://maps.googleapis.com/maps/api/place/details/"
#define GOOGLE_API_KEY   @"AIzaSyA9vKbjaI34G78bF4wyNcKaD3k6zn4aNE0"
#define PARAM_PRIDICTION    @"predictions"
#define GOOGLE_API_BASE_URL_DETAIL @"https://maps.googleapis.com/maps/api/place/details/"

@interface AddressValidateViewController ()<kDropDownListViewDelegate,VSDropdownDelegate> {
    
    DropDownListView * Dropobj;
    NSInteger selectedIndex;
    NSString *countryNameStr;
    NSString *cityNameStr;
    NSString *stateNameStr;
    NSString *countryIDStr;
    NSString *cityIDStr;
    NSString *stateIDStr;
    SingletonClass *sharedInstance;
    VSDropdown *_dropdown;
    NSMutableArray * locationArray;
    NSTimer *connectionTimer;
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *userLocation;
    NSMutableArray *placeArray;
    NSString *streetStr;
    NSString *cityStr;
    NSString *stateStr;
    NSString *countryStr;
    NSString *neighbourHoodStr;
    NSString *subloacilityLevelStrr;
    NSString *streetNumber;
    NSString *premisesNumber;
    NSString *routeNumber;
    NSString *addressOtherStr;
    NSString *postalCode;
    NSString *arrangedAddress;
    NSString *addressOther1Str;
}


@property(nonatomic,strong)NSMutableArray *searchPlaceArray;
@property(nonatomic,strong)NSMutableArray *placeDetailsOtherArray;
@property(nonatomic,strong) PlaceObj *placeDetailsArray;
@property(nonatomic,strong)NSMutableArray *placeDetailsssArray;

@end

@implementation AddressValidateViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    countryNameStr = @"";
    sharedInstance = [SingletonClass sharedInstance];
    countryButton.layer.cornerRadius = 5;
    countryButton.layer.borderWidth = 1;
    [_countryTextField setDelegate:self];
    [countryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    countryButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countryButton.backgroundColor = [UIColor whiteColor];
    _countryTextField.hidden = YES;
    self.countryListpickerViewArray = [[NSMutableArray alloc] init];
    self.countryListpickerrray = [[NSMutableArray alloc] init];
    self.stateListpickerViewArray = [[NSMutableArray alloc] init];
    self.stateListpickerrray = [[NSMutableArray alloc] init];
    self.cityListpickerViewArray = [[NSMutableArray alloc] init];
    self.cityListpickerrray = [[NSMutableArray alloc] init];
    locationArray = [[NSMutableArray alloc]init];
    
    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
    searchQuery = [[SPGooglePlacesAutocompleteQuery alloc] initWithApiKey:@"AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0"];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [streetAddressTextField addTarget:self
                               action:@selector(editingChanged:)
                     forControlEvents:UIControlEventEditingChanged];
    [numberToolbar sizeToFit];
    zipCodeTextField.inputAccessoryView = numberToolbar;
    // [self getCountryApiCall];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)doneWithNumberPad{
    [self.view endEditing:YES];
}

#pragma  mark - UItextField Delegate Methods

-(void) editingChanged:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""])
    {
        [placeArray removeAllObjects];
        [self showDropDownForTextField:streetAddressTextField adContents:placeArray multipleSelection:NO];
    }
    else
    {
        if ([sender.text length])
        {
            [self callApiToSearchGooglePlacesWithString:[NSString stringWithFormat:@"%@",sender.text]];
        }
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    if (textField.text.length >2) {
    }}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //    if ((textField == _cityTextField) || (textField == _stateTextField) || (textField == _countryTextField) || (textField == zipCodeTextField))
    //        return NO;
    //    else
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
#pragma mark - Google Suggestion API

#pragma mark:- Api For Google Place API
- (void)callApiToSearchGooglePlacesWithString:(NSString *)searchString{
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed) {
        NSString *latitudeStr = sharedInstance.latiValueStr;
        NSString *lonitudeStr = sharedInstance.longiValueStr;
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)searchString,
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
        
        if ([latitudeStr length] && [lonitudeStr length]) {
            NSString   *locationValue = [NSString stringWithFormat:@"%@,%@",latitudeStr,lonitudeStr];
            NSString   *requestStr = [NSString stringWithFormat:@"%@json?input=%@&sensor=%@&key=%@&location=%@&radius=%@&strictbounds&offset=%lu",GOOGLE_GEOLOCATION_URL,[encodedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],@"true",GOOGLE_API_KEY,locationValue,@"50000",(unsigned long)searchString.length];
                NSString *encodedUrl = [requestStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //  [ProgressHUD show:@"Please wait..." Interaction:NO];
            [ServerRequest AFNetworkPostRequestUrlForGooglePlace:requestStr withParams:nil CallBack:^(id responseObject, NSError *error) {
                NSLog(@"response object Post Contractor Search List %@",responseObject);
                // [ProgressHUD dismiss];
                
                if(!error) {
                    NSLog(@"Response is --%@",responseObject);
                    if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
                        [locationArray removeAllObjects];
                        placeArray = [[NSMutableArray alloc]init];
                        NSArray *responseArray = [responseObject objectForKey:@"predictions"];
                        if (responseArray.count) {
                            locationArray = [SingletonClass parseAutocompleteResponse:responseObject andError:error];
                            for (PlaceObj *obj in locationArray) {
                                if (obj.placeDescription != nil) {
                                    [placeArray addObject:obj.placeDescription];
                                }
                            }
                            NSLog(@"Filtering Array >>>>>%lu",(unsigned long)placeArray.count);
                            [self showDropDownForTextField:streetAddressTextField adContents:placeArray multipleSelection:NO];
                        }
                        else
                        {
                           // [self showDropDownForTextField:streetAddressTextField adContents:placeArray multipleSelection:NO];
                        }
                        
                    } else
                    {
                        if ([[responseObject objectForKey:@"status"]isEqualToString:@"ZERO_RESULTS"]) {
                            [locationArray removeAllObjects];
                        }
                    }
                }
                else{
                }
            }];
        }
        else{
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
    else {
        sharedInstance.latiValueStr = @"28.616789";
        sharedInstance.longiValueStr = @"77.74756";
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"LocationDataValue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[AlertView sharedManager] presentAlertWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                     andButtonsWithTitle:@[@"OK"] onController:self
                                           dismissedWith:^(NSInteger index, NSString *buttonTitle) {
                                               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                           }];
    }
}

#pragma mark - VSDropdown Delegate methods.

- (void)dropdown:(VSDropdown *)dropDown didChangeSelectionForValue:(NSString *)str atIndex:(NSUInteger)index selected:(BOOL)selected
{
    UITextField *btn = (UITextField *)dropDown.dropDownView;
    [btn resignFirstResponder];
    NSString *allSelectedItems = nil;
    if (dropDown.selectedItems.count > 1)    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@","];
    }
    else{
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    btn.text = allSelectedItems;
    
    PlaceObj *customObj= [locationArray objectAtIndex:index];
    [self callGetDetailForPlaceID:customObj.placeID];
  //  [self getLatLonFromAddress:allSelectedItems andCount:1];
}

-(void)showDropDownForTextField:(UITextField *)txt adContents:(NSArray *)contents multipleSelection:(BOOL)multipleSelection {
    
    [_dropdown setDrodownAnimation:rand()%2];
    
    [_dropdown setAllowMultipleSelection:multipleSelection];
    
    [_dropdown setIsSearchForPlaces:YES];
    
    [_dropdown setupDropdownForView:txt];
    
    [_dropdown setBackgroundColor:[UIColor whiteColor]];
    
    [_dropdown setSeparatorColor:[UIColor blackColor]];
    
    if (_dropdown.allowMultipleSelection)
    {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:[txt.text componentsSeparatedByString:@","]];
    }
    else
    {
        [_dropdown reloadDropdownWithContents:contents andSelectedItems:@[txt.text]];
    }
    
}

- (UIColor *)outlineColorForDropdown:(VSDropdown *)dropdown
{
    UITextField *btn = (UITextField *)dropdown.dropDownView;
    
    return btn.textColor;
    
}

- (CGFloat)outlineWidthForDropdown:(VSDropdown *)dropdown
{
    return 0.0;
}

- (CGFloat)cornerRadiusForDropdown:(VSDropdown *)dropdown
{
    return 0.0;
}

- (CGFloat)offsetForDropdown:(VSDropdown *)dropdown
{
    return -2.0;
}

-(void)callGetDetailForPlaceID:(NSString*)pladeID{
    
    NSString   *requestStr = [NSString stringWithFormat:@"%@json?placeid=%@&key=%@",GOOGLE_API_BASE_URL_DETAIL,pladeID,GOOGLE_API_KEY];
    requestStr = [requestStr stringByReplacingOccurrencesOfString:@"-" withString:@"%2D"];
    [ServerRequest AFNetworkPostRequestUrlForGooglePlace:requestStr withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error) {
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
                _placeDetailsssArray = [[NSMutableArray alloc]init];
                _placeDetailsOtherArray = [[NSMutableArray alloc]init];
                _searchPlaceArray = [[NSMutableArray alloc]init];
                [_placeDetailsssArray removeAllObjects];
                NSDictionary *placeDictionary = [responseObject valueForKey:@"result"];
                _placeDetailsssArray = [placeDictionary objectForKey:@"address_components"] ;
                //                geometry =         {
                //                    location =             {
                //                        lat = "28.5785422";
                //                        lng = "77.31746199999999";
                //                    };
                //                    viewport =             {
                //                        northeast =                 {
                //                            lat = "28.5796261802915";
                //                            lng = "77.31907803029149";
                //                        };
                //                        southwest =                 {
                //                            lat = "28.5769282197085";
                //                            lng = "77.31638006970849";
                //                        };
                //                    };
                //                };
                NSDictionary *locationDict = [placeDictionary objectForKey:@"geometry"];
                if (locationDict.count != 0) {
                    NSDictionary *locationDictLatValue = [locationDict objectForKey:@"location"];
                    if (locationDictLatValue.count) {
                        sharedInstance.customLatiValueStr = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lat"]];
                        sharedInstance.customLongiValueStr = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lng"]];
                        sharedInstance.selectedAddressLatitudeStr = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lat"]];
                        sharedInstance.selectedAddressLongitudeStr = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lng"]];
                        sharedInstance.meetUpLocationLattitude = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lat"]];
                        sharedInstance.meetUpLocationLongtitude = [NSString stringWithFormat:@"%@", [locationDictLatValue objectForKey:@"lng"]];
                    }
                }
                
                if (_placeDetailsssArray.count) {
                    for (int i = 0; i<_placeDetailsssArray.count ; i++) {
                        _placeDetailsOtherArray = [_placeDetailsssArray valueForKey:@"types"];
                        if (_placeDetailsOtherArray.count) {
                            for (int j = 0; j<_placeDetailsOtherArray.count ; j++) {
                                _searchPlaceArray = _placeDetailsOtherArray[j];
                                if (_searchPlaceArray.count) {
                                    for (int k = 0; k<_searchPlaceArray.count; k++) {
                                        NSString *typeName =[_searchPlaceArray objectAtIndex:k];
                                        if ([typeName isEqualToString:@"postal_code"]) {
                                            postalCode = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",postalCode);
                                        }
                                        else if ([typeName isEqualToString:@"locality"]) {
                                            cityStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",cityStr);
                                        }
                                        else if ([typeName isEqualToString:@"administrative_area_level_1"]) {
                                            stateStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",stateStr);
                                        }
                                        else if ([typeName isEqualToString:@"country"]) {
                                            countryStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",countryStr);
                                        }
                                        else if ([typeName isEqualToString:@"neighborhood"]) {
                                            neighbourHoodStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",neighbourHoodStr);
                                        }
                                        else if ([typeName isEqualToString:@"sublocality_level_3"]) {
                                            subloacilityLevelStrr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",subloacilityLevelStrr);
                                        }
                                        else if ([typeName isEqualToString:@"street_number"]) {
                                            streetStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",streetStr);
                                        }
                                        else if ([typeName isEqualToString:@"premise"]) {
                                            premisesNumber = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",premisesNumber);
                                        }
                                        else if ([typeName isEqualToString:@"route"]) {
                                            routeNumber = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",routeNumber);
                                        }
                                        else if ([typeName isEqualToString:@"sublocality_level_2"]) {
                                            addressOtherStr = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",addressOtherStr);
                                        }
                                        else if ([typeName isEqualToString:@"sublocality_level_1"]) {
                                            addressOther1Str = [[_placeDetailsssArray objectAtIndex:j] valueForKey:@"long_name"];
                                            NSLog(@"Postsal Value %@",addressOther1Str);
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
                
                if (postalCode == nil) {
                    postalCode = @"";
                }
                else if (cityStr == nil) {
                    cityStr = @"";
                }
                else if (stateStr == nil) {
                    stateStr = @"";
                }
                else if (countryStr == nil) {
                    countryStr = @"";
                }
                else if (neighbourHoodStr == nil) {
                    neighbourHoodStr = @"";
                }
                else if (subloacilityLevelStrr == nil) {
                    subloacilityLevelStrr = @"";
                }
                else if (streetStr == nil) {
                    streetStr = @"";
                }
                else if (premisesNumber == nil) {
                    premisesNumber = @"";
                }
                else if (routeNumber == nil) {
                    routeNumber = @"";
                }
                else if (addressOtherStr == nil) {
                    addressOtherStr = @"";
                }
                else if (addressOther1Str == nil) {
                    addressOther1Str = @"";
                }
                
                if (neighbourHoodStr != nil && [neighbourHoodStr length]) {
                    arrangedAddress = neighbourHoodStr;
                }
                if (subloacilityLevelStrr != nil && [subloacilityLevelStrr length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = subloacilityLevelStrr;
                    }
                    else{
                        arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , subloacilityLevelStrr];
                    }
                }
                if (streetStr != nil && [streetStr length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = streetStr;
                    }
                    else{
                        arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , streetStr];
                    }
                }
                
                
                if (premisesNumber != nil && [premisesNumber length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = premisesNumber;
                    }
                    else{
                        arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , premisesNumber];
                    }
                }
                if (routeNumber != nil && [routeNumber length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = routeNumber;
                    }
                    else{
                        if (streetStr != nil && [streetStr length]) {
                            arrangedAddress = [NSString stringWithFormat:@"%@ %@",arrangedAddress , routeNumber];
                        }else {
                            arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , routeNumber];
                        }
                    }
                }
                
                if (addressOtherStr != nil && [addressOtherStr length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = addressOtherStr;
                    }
                    else{
                        arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , addressOtherStr];
                    }
                }
                if (addressOther1Str != nil && [addressOther1Str length]) {
                    if(![arrangedAddress length]){
                        arrangedAddress = addressOther1Str;
                    }
                    else{
                        arrangedAddress = [NSString stringWithFormat:@"%@, %@",arrangedAddress , addressOther1Str];
                    }
                }
                
                if ([arrangedAddress length]) {
                    sharedInstance.customAddressStr = arrangedAddress;
                }
                else{
                    sharedInstance.customAddressStr = [placeDictionary objectForKey:@"formatted_address"];

                }
                    if(cityStr != nil){
                        [_cityTextField setText:cityStr];
                    }
                    if(stateStr != nil){
                        [_stateTextField setText:stateStr];
                    }
                
                    if(postalCode != nil){
                        [zipCodeTextField setText:postalCode];
                    }
                [streetAddressTextField setText: sharedInstance.customAddressStr];
                //  [self.tableViewSearchBar reloadData];
            
            }
        }
    }];
}


- (void)getLatLonFromAddress:(NSString *)address andCount:(NSInteger) arrayCount_decreases {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    //  CLLocationDistance distance ;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         int count;
         if (error) {
             count = count - 1;
             if (count == 0) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ProcessComplete" object:nil userInfo:nil];
             }
         }else {
             if ([placemarks count]>0)
             {
                 // get the first one
                 CLPlacemark * mark = (CLPlacemark*)[placemarks objectAtIndex:0];
                 CLLocation *locationValue = mark.location;
                 CLLocationCoordinate2D userLoc = CLLocationCoordinate2DMake(mark.location.coordinate.latitude,mark.location.coordinate.longitude);
                 NSLog(@"Lattitude VAlue %f",userLoc.latitude);
                 NSLog(@"Longitude VAlue %f",userLoc.longitude);
                 sharedInstance.customLattitudeValueStr = [NSString stringWithFormat:@"%f",userLoc.latitude];
                 sharedInstance.customLongitudeValueStr = [NSString stringWithFormat:@"%f",userLoc.longitude];

                 if (locationValue != nil) {
                     [geocoder reverseGeocodeLocation:locationValue completionHandler:^(NSArray *_placemarks, NSError *error) {
                         
                         if (error == nil && [_placemarks count] > 0) {
                             
                             CLPlacemark * placemark = [_placemarks lastObject];
                             userLocation = [NSString stringWithFormat:@"%@",placemark.locality];
                             NSString *addressDetailsStr =  [NSString stringWithFormat:@"name =%@, thoroughfare = %@, locality =%@, subLocality = %@, administrativeArea = %@,  postalCode = %@ , subThoroughfare = %@", placemark.name,placemark.thoroughfare, placemark.locality, placemark.subLocality,placemark.administrativeArea, placemark.postalCode, placemark.subThoroughfare];
                             NSLog(@"locatedAt is: %@", addressDetailsStr);
                             if ([placemark.locality length]) {
                                 _cityTextField.text = placemark.locality;
                             }
                             else{
                                 if ([placemark.subAdministrativeArea length]) {
                                     
                                     _cityTextField.text = placemark.subAdministrativeArea;
                                 }
                                 else{
                                     _cityTextField.text = @"";
                                 }
                             }
                             
                             if ( [placemark.country length]) {
                                 _countryTextField.text = placemark.country;
                             }
                             else{
                                 _countryTextField.text = @"";
                             }
                             
                             
                             if ( [placemark.administrativeArea length]) {
                                 self.stateTextField.text = placemark.administrativeArea;
                             }
                             else{
                                 _stateTextField.text = @"";
                             }
                             
                             if ( [ placemark.postalCode length]) {
                                 zipCodeTextField.text = placemark.postalCode;
                             }
                             else
                             {
                                 zipCodeTextField.text = @"";
                             }
                         }
                     }];
                 }
                 // [self setUserLocation:mark];
                 if (count == 0) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ProcessComplete" object:nil userInfo:nil];
                 }
             }
         }
     }];
    //  return distance;
    
}

//-(void)callGetDetailForPlaceID:(NSString*)placeID {
//
//    NSString   *requestStr = [NSString stringWithFormat:@"%@json?placeid=%@&key=%@",GOOGLE_API_BASE_URL_DETAIL,placeID,GOOGLE_API_KEY];
//    //requestStr = [requestStr stringByReplacingOccurrencesOfString:@"-" withString:@"%2D"];
//    [ServerRequest AFNetworkPostRequestUrlForGooglePlace:requestStr withParams:nil CallBack:^(id responseObject, NSError *error) {
//        NSLog(@"response object Post Contractor Search List %@",responseObject);
//        [ProgressHUD dismiss];
//
//        if(!error) {
//            NSLog(@"Response is --%@",responseObject);
//            if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
//                arrayZipCodeDate = [[NSMutableArray alloc]init];
//                [arrayZipCodeDate removeAllObjects];
//                sharedObject = [SingletonClass parsePlaceDetailResponse:responseObject andError:error];
//                [arrayZipCodeDate addObject:sharedObject];
//                NSLog(@"Object Array >>>>>%lu",(unsigned long)arrayZipCodeDate.count);
//            }
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)doneButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    if([locationNameTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter a label." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else if([streetAddressTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter an address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
        
    }
    else if([self.cityTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the city." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    
    //    else if([_countryTextField.text length]==0) {
    //
    //        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please select the country name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [alrtShow show];
    //
    //    }
    else if([self.stateTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter the state." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    
    
    else if([zipCodeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please enter your zip code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else  {
        
        [self addCustomAddressApiCall];
    }
    
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Add Custom Address Api Call

- (void)addCustomAddressApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:userIdStr forKey:@"UserID"];
    [params setValue:locationNameTextField.text forKey:@"LocationName"];
    [params setValue:streetAddressTextField.text forKey:@"Address"];
    [params setValue:self.cityTextField.text.length?self.cityTextField.text:@"" forKey:@"City"];
    [params setValue:self.stateTextField.text forKey:@"State"];
    [params setValue:zipCodeTextField.text forKey:@"ZipCode"];
    [params setValue:_countryTextField.text forKey:@"Country"];
    [params setValue:self.stateTextField.text forKey:@"StateAbbrevation"];
 //   [params setValue:self.stateTextField.text forKey:@"StateAbbrevation"];

//    sharedInstance.customLattitudeValueStr
//    sharedInstance.customLongitudeValueStr
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:APIAddCustomLocationCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        // NSLog(@"Url List %@",urlstr);
        [ProgressHUD dismiss];
        
        if(!error) {
            
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                [CommonUtils showAlertWithTitle:@"Location Added" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } else {
                
                [CommonUtils showAlertWithTitle:@"Alert!" withMsg:[responseObject objectForKey:@"Message"] inController:self];
            }
        }
    }];
    
}


@end
