//
//  CurrentLocationsViewController.m
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "CurrentLocationsViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
#import "AlertView.h"
#import "VSDropdown.h"
#import "CountryCodeSuggestion.h"
#import "PlaceObj.h"
#define PARAM_PRIDICTION    @"predictions"
#define GOOGLE_GEOLOCATION_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/"
#define GOOGLE_API_BASE_URL_DETAIL @"https://maps.googleapis.com/maps/api/place/details/"
#define GOOGLE_API_KEY   @"AIzaSyAhPCXBNCtec4Y3PlMMhHZ0SiWQV7FYaEs"

@interface CurrentLocationsViewController () <VSDropdownDelegate>{
    
    SingletonClass *sharedInstance;
    VSDropdown *_dropdown;
    NSMutableArray * locationArray;
    NSTimer *connectionTimer;
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSMutableArray *placeArray;
    NSString *userLocation;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatiorView;
@end

@implementation CurrentLocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    sharedInstance = [SingletonClass sharedInstance];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    _indicatiorView.hidden = YES;
    locationArray = [[NSMutableArray alloc]init];

    _dropdown = [[VSDropdown alloc]initWithDelegate:self];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:YES];
//    IBOutlet UITextField *countryTextField;
//    IBOutlet UITextField *cityTextField;
//    IBOutlet UITextField *stateTextField;
//    IBOutlet UITextField *zipCodeTextField;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
    [cityTextField addTarget:self
                            action:@selector(editingChanged:)
                  forControlEvents:UIControlEventEditingChanged];
    
    
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
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

#pragma  mark - UItextField Delegate Methods

-(void) editingChanged:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""])
    {
        [placeArray removeAllObjects];
        [self showDropDownForTextField:cityTextField adContents:placeArray multipleSelection:NO];
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
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)doneButtonClicked:(id)sender {
    
    if([cityTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the city." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([stateTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the state." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([zipCodeTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the zipcode." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    } else if([countryTextField.text length]==0) {
        
        UIAlertView *alrtShow=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter your country." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alrtShow show];
        
    }
    else  {
        [self.view endEditing:YES];
        [self callLatLongApiForString:sharedInstance.customAddressValue];
    }
    
}

-(void)callLatLongApiForString:(NSString *)locationString{
    
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    if (![APPDELEGATE geocoder]) {
        
        APPDELEGATE.geocoder= [[CLGeocoder alloc] init];
    }
    
    [[APPDELEGATE geocoder] geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            
            NSString  *streetStr = [CommonUtils checkStringForNULL:placemark.thoroughfare];
            NSString  *cityStr = [CommonUtils checkStringForNULL:placemark.locality];
            NSString  *stateStr = [CommonUtils checkStringForNULL:placemark.administrativeArea];
            NSString  *countryStr = [CommonUtils checkStringForNULL:placemark.country];
            NSString  * zipCodeStr = [CommonUtils checkStringForNULL:placemark.postalCode];
            CLLocation *location = placemark.location;
            float latitude=  location.coordinate.latitude;
            float longitude= location.coordinate.longitude;
            NSLog(@"Location Value  %@,%@,%@,%@,%@,%@,%@",streetStr,locatedAt,streetStr,cityStr,stateStr,countryStr,zipCodeStr);
            NSLog(@"Latitutde Value %f, Logtitude VAlue%f",latitude,longitude);
            sharedInstance.customLatiValueStr = [NSString stringWithFormat:@"%.8f", location.coordinate.latitude];
            sharedInstance.customLongiValueStr = [NSString stringWithFormat:@"%.8f", location.coordinate.longitude];
            if ([sharedInstance.customLatiValueStr length]) {
                [self updatePreferencesLocationApiData];
            }
        }
    }];
    
}



#pragma mark-- PreferencesLocation API Call
-(void)updatePreferencesLocationApiData
{
    
    NSString *userIdStr = sharedInstance.userId;
    locationStr = [NSString stringWithFormat:@"%@,%@,%@,%@",cityTextField.text,stateTextField.text,countryTextField.text,zipCodeTextField.text];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@?userID=%@&City=%@&State=%@&Country=%@&Zipcode=%@&StateAbbrevation=%@&Lat=%@&Long=%@",APIPrefernceChangeLocationData,userIdStr,cityTextField.text,stateTextField.text,countryTextField.text,zipCodeTextField.text,@"null",sharedInstance.customLatiValueStr,sharedInstance.customLongiValueStr];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForQA:encodedUrl withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get UserInfo List %@",responseObject);
        
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
          //  [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
            
        }
        else{
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    
                    [[AlertView sharedManager] presentAlertWithTitle:@"Location Status" message:[responseObject objectForKey:@"Message"]
                                                 andButtonsWithTitle:@[@"OK"] onController:self
                                                       dismissedWith:^(NSInteger index, NSString *buttonTitle)
                     {
                         if ([buttonTitle isEqualToString:@"OK"]) {
                             [self.view endEditing:YES];
                             [self.navigationController popViewControllerAnimated:YES];
                         }}];
                    
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            } else {
                
                NSLog(@"Error");
            }
        }
    }];
}


-(void)getStateAbbrevationWithString:(NSString *)stateName
{
    
    NSString *urlstr=[NSString stringWithFormat:@"http://gd.geobytes.com/AutoCompleteCity?callback=?&q=%@",stateName];
    NSString *encodedUrl = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         // [ProgressHUD dismiss];
         if (data.length > 0 && connectionError == nil)
         {
             //  sharedInstance.customStateAbbriviation
             NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
             if (jsonString.length) {
                 NSString *jsonString1 =[jsonString substringFromIndex:2];
                 NSString *subString = [jsonString1 substringToIndex:[jsonString1 length]- 4];
                 NSLog(@"Response>>>%@",subString);
                 NSArray *arr = [subString componentsSeparatedByString:@","];
                 NSLog(@"Response>>>%lu",(unsigned long)arr.count);
                 sharedInstance.customStateAbbriviation = [arr objectAtIndex:1];
                 if (sharedInstance.customStateAbbriviation.length) {
                     [self updatePreferencesLocationApiData];
                 }
             }
          }
     }];
}

-(void)changeByteIntoCurrectFormateWith:(NSData *)dataValue{
    NSData *data = dataValue; // your image data
    const unsigned char *bytes = [data bytes]; // no need to copy the data
    NSUInteger length = [data length];
    NSMutableArray *byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i < length; i++) {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    NSDictionary *dictJson = [NSDictionary dictionaryWithObjectsAndKeys:
                              byteArray, @"photo",
                              nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictJson options:0 error:NULL];
    NSLog(@"Json Data %@",jsonData);
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Google Suggestion API

#pragma mark:- Api For Google Place API
- (void)callApiToSearchGooglePlacesWithString:(NSString *)searchString{
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed) {
        sharedInstance.latiValueStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
        sharedInstance.longiValueStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
        NSString *latitudeStr = sharedInstance.latiValueStr;
        NSString *lonitudeStr = sharedInstance.longiValueStr;
        NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                        NULL,
                                                                                                        (CFStringRef)searchString,
                                                                                                        NULL,
                                                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                        kCFStringEncodingUTF8 ));
        
        if ([latitudeStr length] && [lonitudeStr length]) {
           // NSString   *locationValue = [NSString stringWithFormat:@"%@,%@",@"34.1478",@"118.1445"];
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
                            [self showDropDownForTextField:cityTextField adContents:placeArray multipleSelection:NO];
                        }
                        else
                        {
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
    if (dropDown.selectedItems.count > 1)
    {
        allSelectedItems = [dropDown.selectedItems componentsJoinedByString:@","];
    }
    else
    {
        allSelectedItems = [dropDown.selectedItems firstObject];
    }
    btn.text = allSelectedItems;
    sharedInstance.customAddressValue = allSelectedItems;
    [self getLatLonFromAddress:allSelectedItems andCount:1];
    
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


- (void)getLatLonFromAddress:(NSString *)address andCount:(NSInteger) arrayCount_decreases {
    
    _indicatiorView.hidden = NO;
    [_indicatiorView startAnimating];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    //  CLLocationDistance distance ;
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error)
     {
         int count;
         if (error) {
//             [AlertView sharedManager]presentAlertWithTitle:@"Sorry!" message:@"No result found." andButtonsWithTitle:<#(NSArray *)#> onController:<#(UIViewController *)#> dismissedWith:<#^(NSInteger index, NSString *buttonTitle)completionBlock#>
             [cityTextField becomeFirstResponder];
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
                 
                 if (locationValue != nil) {
                     [geocoder reverseGeocodeLocation:locationValue completionHandler:^(NSArray *_placemarks, NSError *error) {
                         
                         if (error == nil && [_placemarks count] > 0) {
                             
                             CLPlacemark * placemark = [_placemarks lastObject];
                             userLocation = [NSString stringWithFormat:@"%@",placemark.locality];
                             _indicatiorView.hidden = YES;
                             [_indicatiorView stopAnimating];
                             NSString *addressDetailsStr =  [NSString stringWithFormat:@"name =%@, thoroughfare = %@, locality =%@, subLocality = %@, administrativeArea = %@,  postalCode = %@ , subThoroughfare = %@", placemark.name,placemark.thoroughfare, placemark.locality, placemark.subLocality,placemark.administrativeArea, placemark.postalCode, placemark.subThoroughfare];
                             NSLog(@"locatedAt is: %@", addressDetailsStr);
                             
                             if ([placemark.locality length]) {
                                 cityTextField.text = placemark.locality;
                             }
                             else{
                                 if ([placemark.subAdministrativeArea length]) {
                                     
                                     cityTextField.text = placemark.subAdministrativeArea;
                                 }
                                 else{
                                     cityTextField.text = @"";
                                 }
                             }
                             
                             if ( [placemark.country length]) {
                                 countryTextField.text = placemark.country;
                             }
                             else{
                                 countryTextField.text = @"";
                             }
                             
                             
                             if ( [placemark.administrativeArea length]) {
                                
                                 stateTextField.text = placemark.administrativeArea;
                             }
                             else{
                                 stateTextField.text = @"";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
