//
//  NSDictionary+NullChecker.h
//  Customer
//
//  Created by Aditi Tiwari on 24/12/16.
//  Copyright (c) 2016 Flexsin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)object expectedObj:(id)obj;

@end
