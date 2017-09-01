//
//  ChooseLocationViewController.h
//  Customer
//
//  Created by Aaditya on 07/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationDelegtae <NSObject>
-(void)locationStringValue :(NSString*)str;

@end
@interface ChooseLocationViewController : UIViewController
@property(nonatomic,assign) BOOL isCheckedFilterValue;
@property (nonatomic, weak) id <LocationDelegtae > delegate;
@property (assign) BOOL isSearchApply;
@end
