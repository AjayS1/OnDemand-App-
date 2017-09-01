//
//  PlaceObj.h
//  Customer
//
//  Created by Apoorve Tyagi on 17/2/17.
//  Copyright (c) 2017 Flexsin Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// address dictionary key values
static NSString* const streetNumber = @"street_number";
static NSString* const route = @"route";
static NSString* const sublocality2 = @"sublocality_level_2";
static NSString* const sublocality1 = @"sublocality_level_1";
static NSString* const locality = @"locality";
static NSString* const administrativeArea2 = @"administrative_area_level_2";
static NSString* const administrativeArea1 = @"administrative_area_level_1";
static NSString* const country = @"country";
static NSString* const postal_code = @"postal_code";

@interface PlaceObj : NSObject

@property (nonatomic, strong) NSString *placeName;
@property (nonatomic, strong) NSString *placeNameWithDetails;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *placeDescription;
@property (nonatomic, strong) NSMutableString *placeAddress;
@property (nonatomic, strong) NSString *placeLAttitude;
@property (nonatomic, strong) NSString *placeLongitude;
@property(assign,nonatomic) BOOL checkLocationStr;



@property (nonatomic, strong) NSString *placeLocalityName;
@property (nonatomic, strong) NSString *placeSubLocalityName;
@property (nonatomic, strong) NSString *placeSubAdminName;
@property (nonatomic, strong) NSString *placeStateAbbribiation;
@property (nonatomic, strong) NSString *placeZipCode;
@property (nonatomic, strong) NSMutableDictionary *placeAddressDictionary;

@property (nonatomic, assign) BOOL placeHasData;
@property (nonatomic, assign) BOOL placeHasCoordinate;

@end
