//
//
//  DatePickerSheetView.m
//  Customer
//
//  Created by Aditi on 12/12/15.
//  Copyright (c) 2016 Flexsin. All rights reserved.
//

#import "AppDelegate.h"

typedef void(^PickerPickDateBlock)(NSDate  *date);

@interface DatePickerSheetView : UIView


+(void)showDateOfBirth:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block;
// +(void)showDatePickerWithDate:(NSDate *)date isDOB:(NSString *)dob AndTimeZone:(NSString *)timeZone WithReturnDate :(PickerPickDateBlock)block;
+(void)showDatePickerWithDate:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block;
@end
