//
//  NSDictionary+NullChecker.h
//  Customer
//
//  Created by Aditi Tiwari on 24/12/16.
//  Copyright (c) 2016 Flexsin. All rights reserved.

#import "NSDictionary+NullChecker.h"

@implementation NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)key expectedObj:(id)obj {
    
    id object = [self objectForKey:key];
    
    if ((object == nil) || (object == [NSNull null])) return obj;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        
        CFNumberType numberType = CFNumberGetType((CFNumberRef)object);
        if (numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type)
            return [NSString stringWithFormat:@"%f",[object floatValue]];
        else
            return [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
    }
    
	return object;
}

@end
