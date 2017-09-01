


//
//  CountryCodeSuggestion.m
//  Customer
//
//  Created by Aditi on 03/01/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "CountryCodeSuggestion.h"

@implementation CountryCodeSuggestion

+(NSMutableArray *)getSearchInfoFromDict:(id)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id item in array) {
        CountryCodeSuggestion *searchObj = [[CountryCodeSuggestion alloc] init];
        searchObj.countryID = [item objectForKey:@"ID"];
        searchObj.countryName = [item objectForKey:@"Value"];
        [tempArray addObject:searchObj];
    }
    return tempArray;
}


+(NSMutableArray *)getSearchInfoFromDictinoaryValue:(id)array {
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id item in array) {
        CountryCodeSuggestion *searchObj = [[CountryCodeSuggestion alloc] init];
        [searchObj setDiscription:[item objectForKey:@"description"]];
        [tempArray addObject:searchObj];
    }
    
    return tempArray;
}
@end
