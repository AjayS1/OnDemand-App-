//
//  DatePickerSheetView.m
//  Customer
//
//  Created by Aditi on 12/12/15.
//  Copyright (c) 2016 Flexsin. All rights reserved.
//

#import "DatePickerSheetView.h"

@implementation DatePickerSheetView


PickerPickDateBlock datePickerBlock;
UIDatePicker *datePicker;
UIView *bgView;
static DatePickerSheetView *datePickerManager = nil;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

//Birthday Date Picker
+(void)showDateOfBirth:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    datePickerBlock = [block copy];
    datePickerManager = [[DatePickerSheetView alloc] init];
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:type];
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePickerManager addSubview:datePicker];
    [datePickerManager setBackgroundColor:[UIColor whiteColor]];
    UIButton *leftCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCancle setFrame:CGRectMake(5, 10, 60, 30)];
    [leftCancle setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [leftCancle setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftCancle addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDone setFrame:CGRectMake(appDel.window.frame.size.width-55, 10, 50, 30)];
    [rightDone setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [rightDone setTitle:@"Done" forState:UIControlStateNormal];
    [rightDone addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [datePickerManager addSubview:leftCancle];
    [datePickerManager addSubview:rightDone];
    [datePicker setFrame:CGRectMake(0, 40, appDel.window.frame.size.width, 240)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [datePicker setLocale:locale];
    
  // NSDate* dateMin = [NSDate dateWithTimeInterval:(31536000*100) sinceDate:[NSDate date]];
   // NSDate *datew = [NSDate dateWithTimeIntervalSinceReferenceDate:-(NSTimeInterval)(31536000.0*100)];
   // datePicker.minimumDate = datew;

    datePicker.minimumDate = date;
    datePicker.maximumDate = nil;
     //datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:-(60*60*60*24*365*16)];
    
    if (date) {
        [datePicker setDate:date animated:YES];
    }else
        [datePicker setDate:[NSDate date] animated:YES];
    
    if(timeZone)
    {
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        
    }else
    {
        [datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    }
    appDel = [[UIApplication sharedApplication] delegate];
    
    bgView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.0];
    
    
    datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 280);
    [appDel.window addSubview:bgView];
    
    [appDel.window addSubview:datePickerManager];
    [appDel.window bringSubviewToFront:datePickerManager];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -280, appDel.window.frame.size.width, 280);
        [bgView setAlpha:0.6];
        
    } completion:^(BOOL finished) {
        
    }];
}


//Date Picker
+(void)showDatePickerWithDate:(NSDate *)date AndTimeZone:(NSString *)timeZone datePickerType:(UIDatePickerMode)type WithReturnDate :(PickerPickDateBlock)block
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    datePickerBlock = [block copy];
    
    datePickerManager = [[DatePickerSheetView alloc] init];
    
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:type];
    
    [datePicker setBackgroundColor:[UIColor whiteColor]];
    [datePickerManager addSubview:datePicker];
    [datePickerManager setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *leftCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftCancle setFrame:CGRectMake(5, 10, 60, 30)];
    [leftCancle setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [leftCancle setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftCancle addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightDone setFrame:CGRectMake(appDel.window.frame.size.width-55, 10, 50, 30)];
    [rightDone setTitleColor:[UIColor colorWithRed:0.0/255.0 green:148.0/255.0 blue:251.0/255.0 alpha:1.f] forState:UIControlStateNormal];
    [rightDone setTitle:@"Done" forState:UIControlStateNormal];
    [rightDone addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    [datePickerManager addSubview:leftCancle];
    [datePickerManager addSubview:rightDone];
    
    [datePicker setFrame:CGRectMake(0, 40, appDel.window.frame.size.width, 240)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [datePicker setLocale:locale];
    
    
    //NSDate* dateMin = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24*365*100)];
   // datePicker.minimumDate = dateMin;
    datePicker.minimumDate = [NSDate date];
    datePicker.maximumDate = nil;
    
    
    
    
    if (date) {
        [datePicker setDate:date animated:YES];
    }else
        [datePicker setDate:[NSDate date] animated:YES];
    
    if(timeZone)
    {
        [datePicker setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        
    }else
    {
        [datePicker setTimeZone:[NSTimeZone systemTimeZone]];
    }
    appDel = [[UIApplication sharedApplication] delegate];
    
    bgView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.0];
    
    
    datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 280);
    [appDel.window addSubview:bgView];
    
    [appDel.window addSubview:datePickerManager];
    [appDel.window bringSubviewToFront:datePickerManager];
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.9 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -280, appDel.window.frame.size.width, 280);
        [bgView setAlpha:0.6];
        
    } completion:^(BOOL finished) {
        
    }];
}


+(void)cancelActionSheet:(id)sender{
//    datePickerBlock(nil);
    bgView.hidden=YES;
    [self removePickerView];
}

+(void)removePickerView
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    [UIView animateWithDuration:0.1 animations:^{
        datePickerManager.frame = CGRectMake(0, appDel.window.frame.size.height -260, 320, 260);
        
    } completion:^(BOOL finished) {
        for (id obj  in datePickerManager.subviews) {
            [obj removeFromSuperview];
        }
        [datePickerManager removeFromSuperview];
        datePickerManager =nil;
        [[appDel.window viewWithTag:11] removeFromSuperview];
    }];
}


#pragma mark - Action Sheet Callback function

#pragma mark - Action Sheet Callback function
+(void)doneActionSheet:(id)sender{
    
    datePickerBlock(datePicker.date);
    bgView.hidden=YES;
    
    [DatePickerSheetView removePickerView];
}

@end
