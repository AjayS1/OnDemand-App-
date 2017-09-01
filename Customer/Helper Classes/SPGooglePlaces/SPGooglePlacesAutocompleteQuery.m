//
//  SPGooglePlacesAutocompleteQuery.m
//  SPGooglePlacesAutocomplete
//
//  Created by Stephen Poletto on 7/17/12.
//  Copyright (c) 2012 Stephen Poletto. All rights reserved.
//

#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"
#import "UserData.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "SingletonClass.h"
#define GOOGLE_GEOLOCATION_URL @"https://maps.googleapis.com/maps/api/place/autocomplete/"

@interface SPGooglePlacesAutocompleteQuery() {
    
    SingletonClass *sharedInstance;
    NSTimer *connectionTimer;
    CLLocationDistance *distance;
    NSMutableData *receivedData;

}
@property (nonatomic, copy) SPGooglePlacesAutocompleteResultBlock resultBlock;
@end

@implementation SPGooglePlacesAutocompleteQuery

- (id)initWithApiKey:(NSString *)apiKey {
    self = [super init];
    if (self) {
        // Setup default property values.
        self.sensor = YES;
        self.key = apiKey;
        self.offset = NSNotFound;
        self.location = CLLocationCoordinate2DMake(-1, -1);
        self.radius = 100;
        self.types = SPPlaceTypeInvalid;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Query URL: %@", [self googleURLString]];
}

- (NSString *)googleURLString {
   
  //  AppDelegate *appDelegate= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    sharedInstance = [SingletonClass sharedInstance];
   // NSMutableString *url;
 //   /*
//    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%@,%@&components=country:%@&radius=300&key=%@",[self.input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],appDelegate.reg_Lat,appDelegate.reg_Long,appDelegate.countryIOSCode ,self.key];
  //  */
    
  //  NSString *lonitudeStr =  [[NSUserDefaults standardUserDefaults]objectForKey:@"LONGITUDEDATA"];
  //  NSString *latitudeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"LATITUDEDATA"];
    NSString *latitudeStr = sharedInstance.latiValueStr;
    NSString *lonitudeStr = sharedInstance.longiValueStr;
    CLLocation *coreLocation = [[CLLocation alloc]initWithLatitude:[latitudeStr doubleValue] longitude:[lonitudeStr doubleValue]];
    NSLog(@"Location %@",coreLocation);
    NSMutableString *url;
    
    /*
     -(void)googleAPICallWithText:(NSString*)strData {
     
     
     //google api url
     NSString   *web_service_URL = [NSString stringWithFormat:@"%@json?input=%@&sensor=%@&key=%@",GOOGLE_GEOLOCATION_URL,strData,@"true",GOOGLE_API_KEY];
     
     NSMutableString *reqData = [NSMutableString stringWithFormat:@""];
     id jsonDta= [reqData dataUsingEncoding:NSUTF8StringEncoding];
     
     [self WebsewrviceAPICall:web_service_URL webserviceBodyInfo:jsonRepresantationFormat];
     }
     
    
     */
  NSString    *strData = [self.input stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  

    if (sharedInstance.checkisSearchAllOverTheArea == YES) {
          url = [NSMutableString stringWithFormat:@"%@json?input=%@&sensor=%@&key=%@",GOOGLE_GEOLOCATION_URL,strData,@"false",self.key];
        NSLog(@"Place Url ===  %@",url);

    }
    else{
        NSString *iSOCodeStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CountryISOCode"];
         url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=establishment&location=%@,%@&components=country:%@&radius=500&key=%@",[self.input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],latitudeStr,lonitudeStr,iSOCodeStr,self.key];
    }
 
    NSLog(@"Place Url ===  %@",url);
    
    return url;
}


//AIzaSyAW4AldQrkEsG5PJX8nDZL6_-ecYX9Z4-0

- (void)cleanup {
    googleConnection = responseData = nil;
    self.resultBlock = nil;
}

- (void)cancelOutstandingRequests {
    [googleConnection cancel];
    [self cleanup];
}

- (void)fetchPlaces:(SPGooglePlacesAutocompleteResultBlock)block {
    if (!self.key) {
        return;
    }
    
    if (SPIsEmptyString(self.input)) {
        // Empty input string. Don't even bother hitting Google.
        block(@[], nil);
        return;
    }
    
    [self cancelOutstandingRequests];
    
    self.resultBlock = block;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self googleURLString]]];
    googleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    responseData = [[NSMutableData alloc] init];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)failWithError:(NSError *)error {
    if (self.resultBlock != nil) {
        self.resultBlock(nil, error);
    }
    [self cleanup];
}

- (void)succeedWithPlaces:(NSArray *)places {
    NSMutableArray *parsedPlaces = [NSMutableArray array];
    
    if(places.count >0){
  //  SPGooglePlacesAutocompletePlace *place = [places firstObject];
        /*
    if (place) {
        [place resolveToPlacemark:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
            
            NSLog(@"Placemark: %@", placemark);
            NSLog(@"Latitude Placemark: %f", placemark.location.coordinate.latitude);
            NSLog(@"Longitude Placemark: %f", placemark.location.coordinate.longitude);
            
        }];
    }*/
    }
    
    for (NSDictionary *place in places) {
        [parsedPlaces addObject:[SPGooglePlacesAutocompletePlace placeFromDictionary:place apiKey:self.key]];
           }
    if (self.resultBlock != nil) {
        self.resultBlock(parsedPlaces, nil);
      }
    [self cleanup];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (connection == googleConnection) {
        [responseData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connnection didReceiveData:(NSData *)data {
    if (connnection == googleConnection) {
        [responseData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (connection == googleConnection) {
        [self failWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == googleConnection) {
        NSError *error = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        if (error) {
            [self failWithError:error];
            return;
        }
        if ([response[@"status"] isEqualToString:@"ZERO_RESULTS"]) {
            [self succeedWithPlaces:@[]];
            return;
        }
        if ([response[@"status"] isEqualToString:@"OK"]) {
            [self succeedWithPlaces:response[@"predictions"]];
            return;
        }
        
        // Must have received a status of OVER_QUERY_LIMIT, REQUEST_DENIED or INVALID_REQUEST.
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: response[@"status"]};
        [self failWithError:[NSError errorWithDomain:@"com.spoletto.googleplaces" code:kGoogleAPINSErrorCode userInfo:userInfo]];
    }
}

@end
