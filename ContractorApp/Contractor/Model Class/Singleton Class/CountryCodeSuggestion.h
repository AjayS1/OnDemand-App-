//
//  CountryCodeSuggestion.h
//  Customer
//
//  Created by Aditi on 03/01/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryCodeSuggestion : NSObject
@property (strong, nonatomic) NSString      *countryCode;
@property (strong, nonatomic) NSString      *countryName;
@property (strong, nonatomic) NSString      *countryAbbriviation;
@property (strong, nonatomic) NSString      *countryID;
@property (strong, nonatomic) NSString      *discription;

+(NSMutableArray *)getSearchInfoFromDict:(id)array;
+(NSMutableArray *)getSearchInfoFromDictinoaryValue:(id)array;
@end
