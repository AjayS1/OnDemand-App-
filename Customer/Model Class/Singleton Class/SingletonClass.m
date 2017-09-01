//
//  AppDelegate.m
//  Customer
//
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "SingletonClass.h"
#import "ServerRequest.h"
#import "AppDelegate.h"
#import "PlaceObj.h"

#define GOOGLE_API_BASE_URLs @"https://maps.googleapis.com/maps/api/place/autocomplete/"
#define GOOGLE_API_BASE_URL_DETAIL @"https://maps.googleapis.com/maps/api/place/details/"
#define GOOGLE_API_KEY   @"AIzaSyDhfdPYj9RhAT0cik2Bt4TaqG9oKsUciwo"
static NSString *zipCodeValueStr;
static SingletonClass *sharedInstance = nil;

@implementation SingletonClass

@synthesize selectedStartAgeStr;

+(SingletonClass*)sharedInstance {
    
    if (sharedInstance == nil){
        sharedInstance = [[SingletonClass alloc]init];
    }
    return sharedInstance;
}

-(id)init {
    self = [super init];
    if (self!=nil){
    }
    return self;
}

#pragma mark--Email Validation
+(BOOL)emailValidation:(NSString *)email{
    BOOL result;
    //checking email validation
    NSString *emailRegEx = @"[A-Z0-9a-z._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    if ([emailTest evaluateWithObject:email] == YES)
    {
        result=YES;
    }
    else
    {
        result=NO;
    }
    return result;
    
}

+(NSMutableArray *)parselocationData: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.locationID =[List objectForKey:@"LocationID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}


/*
 - (void)goFetch:(void(^)(NSArray *))completion
 {
 AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
 success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
 if( completion ) completion([JSON valueForKey:@"posts"]);
 }
 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {}
 }
 
 */

+(PlaceObj *)parsePlaceDetailResponse:(NSDictionary*)responseDict andError:(NSError*)error{
    PlaceObj *place = [[PlaceObj alloc] init];
    NSLog(@"response dict %@",responseDict);
    if ([[responseDict objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray *venues = [[responseDict objectForKey:@"result"] objectForKey:@"address_components"];
        if (venues.count == 8) {
            [place setPlaceLocalityName:[[venues objectAtIndex:6] objectForKey:@"long_name"]] ;
            [place setPlaceSubLocalityName:[[venues objectAtIndex:1] objectForKey:@"long_name"]];
            [place setPlaceSubAdminName:[[venues objectAtIndex:3] objectForKey:@"short_name"]];
            [place setPlaceID:[[venues objectAtIndex:4] objectForKey:@"short_name"]];
            [place setPlaceStateAbbribiation:[[venues objectAtIndex:5] objectForKey:@"long_name"]];
            place.placeZipCode = [[venues objectAtIndex:7] objectForKey:@"short_name"];
        }
        else if (venues.count == 4) {
            [place setPlaceLocalityName:[[venues objectAtIndex:0] objectForKey:@"long_name"]] ;
            [place setPlaceSubLocalityName:[[venues objectAtIndex:1] objectForKey:@"long_name"]];
            [place setPlaceSubAdminName:[[venues objectAtIndex:2] objectForKey:@"short_name"]];
            [place setPlaceStateAbbribiation:[[venues objectAtIndex:3] objectForKey:@"long_name"]];
        }
        else if (venues.count == 6) {
            [place setPlaceLocalityName:[[venues objectAtIndex:2] objectForKey:@"long_name"]] ;
            [place setPlaceSubLocalityName:[[venues objectAtIndex:3] objectForKey:@"long_name"]];
            [place setPlaceSubAdminName:[[venues objectAtIndex:4] objectForKey:@"short_name"]];
            [place setPlaceStateAbbribiation:[[venues objectAtIndex:5] objectForKey:@"long_name"]];
        }
    }
    return place;
}

+(NSMutableArray *)parselocationFromGoogleData: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.locationName = [List objectForKey:@"name"];
        appUserInfo.locationAddress = [List objectForKey:@"vicinity"];
        appUserInfo.placeID = [List objectForKey:@"place_id"];
        appUserInfo.zipCodeValueStr = zipCodeValueStr;
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

//-(void)callGetDetailForPlaceID:(NSString*)placeID {
//    NSMutableArray *arrayZipCodeDate= [[NSMutableArray alloc]init];
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
//                [arrayZipCodeDate removeAllObjects];
//                sharedInstance.sharedObject = [self parsePlaceDetailResponse:responseObject andError:error];
//                [arrayZipCodeDate addObject:sharedObject];
//                NSLog(@"Object Array >>>>>%lu",(unsigned long)arrayZipCodeDate.count);
//            }
//        }
//    }];
//}

+(void )callGetDetailForPlaceID:(NSString*)pladeID{
    NSString *requestedStr;
    NSString   *requestStr = [NSString stringWithFormat:@"%@json?placeid=%@&key=%@",GOOGLE_API_BASE_URL_DETAIL,pladeID,GOOGLE_API_KEY];
    requestStr = [requestStr stringByReplacingOccurrencesOfString:@"-" withString:@"%2D"];
    [ServerRequest AFNetworkPostRequestUrlForGooglePlace:requestStr withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Post Contractor Search List %@",responseObject);
        [ProgressHUD dismiss];
        
        if(!error) {
            if ([[responseObject objectForKey:@"status"]isEqualToString:@"OK"]) {
                NSLog(@"Response is --%@",responseObject);
//                _placeDetailsArray = [[NSMutableArray alloc]init];
//                [_placeDetailsArray removeAllObjects];
//                _placeDetailsArray = [SingletonClass parseAutocompleteResponse:responseObject andError:error];
//                NSLog(@"Filtering Array >>>>>%lu",(unsigned long)_placeDetailsArray.count);
                //  [self.tableViewSearchBar reloadData];

            }
        }
    }];
}


+(NSString *)getLatLongFromAddress :(NSString *)address{
    
    if (!(APPDELEGATE.geocoder)) {
       APPDELEGATE.geocoder = [[CLGeocoder alloc] init];
    }
    ;
    [APPDELEGATE.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString  *zipCodeStr;
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
            sharedInstance.zipValueStr = [CommonUtils checkStringForNULL:placemark.postalCode];
            zipCodeStr  = [CommonUtils checkStringForNULL:placemark.postalCode];
            CLLocation *location = placemark.location;
            NSLog(@"location %@",location);
            float latitude=  location.coordinate.latitude;
            float longitude= location.coordinate.longitude;
            
            if (!zipCodeStr.length) {
                zipCodeStr = @"";
            }
            sharedInstance.meetUpLocationLattitude =[NSString stringWithFormat:@"%f",latitude];
            sharedInstance.meetUpLocationLongtitude = [NSString stringWithFormat:@"%f",longitude];
            
        }
    }];
    return  sharedInstance.zipValueStr;
}


+(NSMutableArray *)parseAutocompleteResponse:(NSDictionary*)responseDict andError:(NSError*)error{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSLog(@"response dict %@",responseDict);
    if ([[responseDict objectForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray *venues = [responseDict objectForKey:@"predictions"];
        
        for (NSDictionary *dict in venues) {
            
            PlaceObj *place = [[PlaceObj alloc] init];
            [place setPlaceName:[[dict objectForKey:@"structured_formatting"] objectForKey:@"main_text"]];
            [place setPlaceNameWithDetails:[[dict objectForKey:@"structured_formatting"] objectForKey:@"secondary_text"]];
            [place setPlaceDescription:[dict objectForKey:@"description"]];
            [place setPlaceID:[dict objectForKey:@"place_id"]];
            [place setPlaceAddressDictionary:[dict objectForKey:@""]];
            place.placeAddress = [dict objectForKey:@"vicinity"];
            place.placeAddress = [[NSMutableString alloc] init];
            NSMutableArray *arrValue = [[NSMutableArray alloc] init];
            arrValue = [dict objectForKey:@"terms"];
            for (int i = 0; i < [arrValue count]; i++) {
                
                if (i == 0) {
                    [place setPlaceName:[[arrValue objectAtIndex:i] objectForKey:@"value"]];
                }else{
                    if ([place.placeAddress length]) {
                        [place.placeAddress appendString:@","];
                    }
                    NSDictionary *dictTemp = [arrValue objectAtIndex:i];
                    [place.placeAddress appendString:[dictTemp objectForKey:@"value"]];
                }
            }
            [place setPlaceHasData:YES];
            [place setPlaceHasCoordinate:NO];
            
            [tempArray addObject:place];
        }
    }
    return tempArray;
}


+(NSMutableArray *)parseDateForLocation: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.strEventType = [List objectForKey:@"EventType"];
        appUserInfo.strIsEmailNotification = [List objectForKey:@"isEmailNotification"];
        appUserInfo.strIsMobileNotification = [List objectForKey:@"isMobileNotification"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}


+(NSMutableArray *)parseDateForFilterType: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.filterType = [List objectForKey:@"Value"];
        appUserInfo.filterTypeID = [List objectForKey:@"ID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parselocationFromCustomData: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        if ([[List objectForKey:@"LocationName"] length]) {
            appUserInfo.locationName = [List objectForKey:@"LocationName"];

        }
        else{
            appUserInfo.locationName = @"";

        }
        
        if ([[List objectForKey:@"CustomAddress"] isKindOfClass:[NSString class]]) {
            appUserInfo.locationAddress = [List objectForKey:@"CustomAddress"];
            
        }
        else{
            appUserInfo.locationAddress = @"";
            
        }
        if ([[List objectForKey:@"LocationID"] isKindOfClass:[NSString class]]) {
            appUserInfo.locationID = [List objectForKey:@"LocationID"];
            
        }
        else{
            appUserInfo.locationID = @"";
            
        }

        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parselocationFromCustomCountry: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.countryName = [List objectForKey:@"Value"] ;
        appUserInfo.countryID = [List objectForKey:@"ID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSMutableArray *)parseCancelDateDetails: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.cancelDatevalue = [List objectForKey:@" Value"];
        appUserInfo.cancelDateID = [List objectForKey:@"ID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%f,%f&output=csv",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    locationString = [locationString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return [locationString substringFromIndex:6];
}

+(NSMutableArray *)getSearchInfoFromDict:(id)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id item in array) {
        SingletonClass *searchObj = [[SingletonClass alloc] init];
        [searchObj setDiscription:[item objectForKey:@"description"]];
        [tempArray addObject:searchObj];
    }
    return tempArray;
}

+(NSMutableArray *)parseDateForPayment: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        
        appUserInfo.accountNumStr = [List objectForKey:@"AccountNumber"];
        appUserInfo.accountType = [List objectForKey:@"PaymentMethod"];
        appUserInfo.accountPrimary = [List objectForKey:@"isPrimary"];
        appUserInfo.accountVerifyStatus = [List objectForKey:@"VerificationStatus"];
        appUserInfo.accountStatus = [List objectForKey:@"Status"];
        appUserInfo.VerifyId = [List objectForKey:@"VerfyID"];
        appUserInfo.expiryDate = [List objectForKeyNotNull:@"Expiry" expectedObj:@""];
        appUserInfo.paymentAmount = [List objectForKey:@"AuthenticationPaymentAmount"];
        appUserInfo.bankName = [List objectForKey:@"Name"];
        
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

//

+(NSMutableArray *)parseDateForPaymentVerified: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        
        appUserInfo.accountNumStr = [List objectForKey:@"AccountNumber"];
        appUserInfo.accountType = [List objectForKey:@"PaymentMethod"];
        appUserInfo.accountPrimary = [List objectForKey:@"isPrimary"];
        appUserInfo.accountVerifyStatus = [List objectForKey:@"VerificationStatus"];
        appUserInfo.accountStatus = [List objectForKey:@"Status"];
        appUserInfo.VerifyId = [List objectForKey:@"VerfyID"];
        appUserInfo.expiryDate = [List objectForKeyNotNull:@"Expiry" expectedObj:@""];
        appUserInfo.paymentAmount = [List objectForKey:@"AuthenticationPaymentAmount"];
        appUserInfo.bankName = [List objectForKey:@"Name"];
        appUserInfo.bankAccountID = [List objectForKey:@"AccountID"];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}
//Parse data for Pending Date Array
+(NSMutableArray *)parseDateForDateArray: (NSArray *)response{
    NSMutableArray *arrayOfLocationList= [[NSMutableArray alloc]init];
    
    for (NSDictionary*List in response) {
        SingletonClass *appUserInfo = [[SingletonClass alloc]init];
        appUserInfo.dateID = [List objectForKeyNotNull:@"DateID" expectedObj:@"" ];
        appUserInfo.dateStatusType = [List objectForKeyNotNull:@"DateStatusType" expectedObj:@"" ];
        appUserInfo.dateType = [List objectForKeyNotNull:@"DateType" expectedObj:@"" ];
        appUserInfo.dateLocation = [List objectForKeyNotNull:@"Location" expectedObj:@"" ];
        appUserInfo.dateName = [List objectForKeyNotNull:@"Name" expectedObj:@"" ];
        appUserInfo.datePicture = [List objectForKeyNotNull:@"PicUrl" expectedObj:@"" ];
        appUserInfo.dateRequestTime = [List objectForKeyNotNull:@"RequestTime" expectedObj:@"" ];
        appUserInfo.dateReserveTime = [List objectForKeyNotNull:@"ReserveTime" expectedObj:@"" ];
        appUserInfo.dateRequestType = [List objectForKeyNotNull:@"RequestType" expectedObj:@"" ];
        appUserInfo.statusTypeOfDate = [List objectForKeyNotNull:@"StatusType" expectedObj:@"" ];
        appUserInfo.isContractorRead = [List objectForKeyNotNull:@"isContractorRead" expectedObj:@"" ];
        appUserInfo.isCustomerRead = [List objectForKeyNotNull:@"isCustomerRead" expectedObj:@"" ];
        [arrayOfLocationList addObject:appUserInfo];
    }
    return arrayOfLocationList;
}

@end
