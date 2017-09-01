
//  PastDuePaymentViewController.m
//  Customer
//  Created by Jamshed Ali on 26/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PastDuePaymentViewController.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@interface PastDuePaymentViewController (){
    NSDateFormatter *dateFormatter;
    NSString *dateIdString;
    
}

@end

@implementation PastDuePaymentViewController

@synthesize pastDuePaymentDetailsDictionary;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setValueOnTheLabel];
}

- (void)viewDidLayoutSubviews {
    bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    dateFormatter = [[NSDateFormatter alloc]init];
    if (WIN_WIDTH == 320) {
        [chargeBreakdownLabel setFont:[UIFont systemFontOfSize:12.0]];
        [chargeBreakdownLabelWithValue setFont:[UIFont systemFontOfSize:12.0]];

    }
}

-(void)setValueOnTheLabel
{
    userNameLabel.text = [pastDuePaymentDetailsDictionary objectForKey:@"UserName"];
    dateIdString =[NSString stringWithFormat:@"%@", [pastDuePaymentDetailsDictionary objectForKey:@"DateId"]];
    
    NSString *reserveTimeStr = [NSString stringWithFormat:@"%@", [pastDuePaymentDetailsDictionary objectForKey:@"RequestSendDateTime"]];
    NSArray *arrayOfTime = [reserveTimeStr componentsSeparatedByString:@"."];
    NSString *reservationTime = [arrayOfTime objectAtIndex:0];
    NSString *reserveDate = [CommonUtils convertUTCTimeToLocalTime:reservationTime WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    dateTimeLabel.text = [CommonUtils changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];

    NSString *reserveStartTimeStr = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",[pastDuePaymentDetailsDictionary objectForKey:@"StartTime"]]];
    NSArray *nameStr = [reserveStartTimeStr componentsSeparatedByString:@"."];
    NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
    NSLog(@"%@",fileKey);
    NSString *reserveStartDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    dateStartTimeLabel.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithStringForDate:reserveStartDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
    
    NSString *reserveEndTimeStr = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@",[pastDuePaymentDetailsDictionary objectForKey:@"EndTime"]]];
    NSArray *nameEndStr = [reserveEndTimeStr componentsSeparatedByString:@"."];
    NSString *fileEndKey = [NSString stringWithFormat:@"%@",[nameEndStr objectAtIndex:0]];
    NSLog(@"%@",fileKey);
    NSString *reserveEndDate = [self convertUTCTimeToLocalTime:fileEndKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
    dateEndTimeLabel.text = [NSString stringWithFormat:@"%@",[self changeDateInParticularFormateWithStringForDate:reserveEndDate WithFormate:@"yyyy-MM-dd HH:mm:ss"]];
    dateMeetLocationLabel.text = [pastDuePaymentDetailsDictionary objectForKey:@"Location"];
//    dateMeetLocationLabel.numberOfLines = 0;
//    dateMeetLocationLabel.lineBreakMode =NSLineBreakByWordWrapping;
//    [dateMeetLocationLabel sizeToFit];
    dateStatusLabel.text = @"Completed";
    [ratingLabel setText:[NSString stringWithFormat:@"%.1f", [[pastDuePaymentDetailsDictionary objectForKey:@"Rating"] floatValue]]];
    minimumDateAmount.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[pastDuePaymentDetailsDictionary objectForKey:@"BaseFee"] floatValue]]];
    NSString *additionaTime = [NSString stringWithFormat:@"%@",[pastDuePaymentDetailsDictionary objectForKey:@"AdditionalDuration"]];
    if ([additionaTime isEqualToString:@"0"]) {
        additionalTimeLabel.text = @"Additional Time";
    }
    else{
        additionalTimeLabel.text = [NSString stringWithFormat:@"Additional Time (%@ minutes)",[pastDuePaymentDetailsDictionary objectForKey:@"AdditionalDuration"]];
    }
    
    addtionaltimeAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[pastDuePaymentDetailsDictionary objectForKey:@"ExtraAmount"] floatValue]]];
    
    subtotalLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[pastDuePaymentDetailsDictionary objectForKey:@"SubTotal"] floatValue]]];
    creditCardFeesAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[pastDuePaymentDetailsDictionary objectForKey:@"TipAmount"] floatValue]]];
    chargeBackFeesAmountLabel.text =[CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f", [[pastDuePaymentDetailsDictionary objectForKey:@"ChageBackFee"] floatValue]]];
    totalAmountLabel.text = [CommonUtils getFormateedNumberWithValue:[NSString stringWithFormat:@"%.2f",[[pastDuePaymentDetailsDictionary objectForKey:@"Total"] floatValue]]];
    [self setLayoutOfView];
    
}

#pragma mark: Change Date in Particular Formate
-(NSString *)changeDateInParticularFormateWithStringForDate :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}


#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    NSDateFormatter *anotherFormate = [[NSDateFormatter alloc] init];
    
    [anotherFormate setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    [anotherFormate setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [anotherFormate dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    //    if (isDayLightSavingTime) {
    //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
    //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    //    }
    [anotherFormate setLocale:[NSLocale currentLocale]];
    [anotherFormate setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}



-(void)setLayoutOfView
{
      dateMeetLocationLabel.numberOfLines = 0;
      dateMeetLocationLabel.lineBreakMode =NSLineBreakByWordWrapping;
      [dateMeetLocationLabel sizeToFit];
    [dateStatusLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, dateMeetLocationLabel.frame.origin.y+dateMeetLocationLabel.frame.size.height+14, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
     [statusImage setFrame:CGRectMake(statusImage.frame.origin.x, dateMeetLocationLabel.frame.origin.y+dateMeetLocationLabel.frame.size.height+13, statusImage.frame.size.width, statusImage.frame.size.height)];
    [ratingLabel setFrame:CGRectMake(dateStatusLabel.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+10, dateStatusLabel.frame.size.width, dateStatusLabel.frame.size.height)];
    [ratingImage setFrame:CGRectMake(ratingImage.frame.origin.x, dateStatusLabel.frame.origin.y+dateStatusLabel.frame.size.height+9, ratingImage.frame.size.width, ratingImage.frame.size.height)];
    [sepeartorView setFrame:CGRectMake(0, ratingLabel.frame.origin.y+ratingLabel.frame.size.height+14, self.view.frame.size.width, 1)];
     [chargeBreakDownView setFrame:CGRectMake(chargeBreakDownView.frame.origin.x, sepeartorView.frame.origin.y+sepeartorView.frame.size.height+15, chargeBreakDownView.frame.size.width, chargeBreakDownView.frame.size.height)];
    [payNowButton setFrame:CGRectMake(payNowButton.frame.origin.x, chargeBreakDownView.frame.origin.y+chargeBreakDownView.frame.size.height+32, payNowButton.frame.size.width, payNowButton.frame.size.height)];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)payNowMethodClicked:(id)sender {
    
    float a= [[pastDuePaymentDetailsDictionary objectForKey:@"Total"] floatValue];
    NSInteger totalAmount = lroundf(a);
    NSString *totalAmountPay = [NSString stringWithFormat:@"%ld",(long)totalAmount];
    PastDuePaymentListVC *payNowView = [self.storyboard instantiateViewControllerWithIdentifier:@"PastDuePaymentListVC"];
    payNowView.self.totalAmountStr = totalAmountPay;
    payNowView.dateIDStr = dateIdString;
    [self.navigationController pushViewController:payNowView animated:YES];
    
}
@end
