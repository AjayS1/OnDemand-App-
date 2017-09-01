
//  ScheduleSessionViewController.m
//  Contractor
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "ScheduleSessionViewController.h"
#import "OnDemandDatePushNotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "ServerRequest.h"
#import "Define.h"
#import "AppDelegate.h"
#import "NSDate+MDExtension.h"
#import "MDTimePickerDialog.h"
#import "MDDatePickerDialog.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "AlertView.h"

@interface ScheduleSessionViewController ()
{
    NSDateFormatter *dateFormatter;
    NSString *dateStr;
    NSString *timeStr;
    NSString *timeStartStr;
    NSString *dateTimeStr;
    NSString *contractorUserId;
    NSString *streetStr;
    NSString *cityStr;
    NSString *stateStr;
    UIScrollView *timeSlotScrollView;
    NSString *addressVerify;
    NSArray *timeSlotArray;
    UIButton *bttnTag;
    NSString *startTime;
    NSString *endTime;
    NSString *endOtherTime;
    NSString *startOtherTime;
    
    NSString *startTimeBttn3;
    NSString *endTimeBttn4;
    NSString *startTimeBttn5;
    NSString *endTimeBttn6;
    NSMutableArray *arryschedule;
    NSString *workingDayOnOff;
    SingletonClass *sharedInstance;
}
@property(nonatomic) MDDatePickerDialog *datePicker;

@end

@implementation ScheduleSessionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sharedInstance = [SingletonClass sharedInstance];
    workingDayOnOff = @"1";
    contractorSchedulingDataArray = [[NSMutableArray alloc]init];
    arryschedule = [[NSMutableArray alloc]init];
    
    mStartContentList = [[NSMutableArray alloc]initWithObjects:@"12:00 AM",@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",nil];
    
    mEndContentList = [[NSMutableArray alloc]initWithObjects:@"01:00 AM",@"02:00 AM",@"03:00 AM",@"04:00 AM",@"05:00 AM",@"06:00 AM",@"07:00 AM",@"08:00 AM",@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:00 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",@"09:00 PM",@"10:00 PM",@"11:00 PM",@"11:59 PM",nil];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    secondView.hidden = YES;
    thirdView.hidden = YES;
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    
    [self getSessionDetailsValue];
    [self createAndHandleButton];
    //[self fetchContarctorScheduleAllDayApi];
    [self fetchschedulingSessionApi];
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSignalRReqest:)
                                                 name:@"SignalR"
                                               object:nil];
}


- (void)checkSignalRReqest:(NSNotification*) noti { 
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    
    if ([requestTypeStr isEqualToString:@"1"]) {
        NSString *dateIdStr = [responseObject objectForKey:@"dateId"];
        NSDictionary *dataDictionary = @{@"DateID":dateIdStr,@"Type":requestTypeStr};
        if (sharedInstance.onDemandPushNotificationArray.count) {
            [sharedInstance.onDemandPushNotificationArray removeAllObjects];
        }
        [sharedInstance.onDemandPushNotificationArray addObject:dataDictionary];
        NSLog(@"sharedInstance.onDemandPushNotificationArray ==  %@",sharedInstance.onDemandPushNotificationArray);
        OnDemandDatePushNotificationViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"onDamndDatePushNotification"];
        [self.navigationController pushViewController:dateDetailsView animated:YES];
    }
    else
    {
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SignalR"
                                                  object:nil];
}

- (void)initUI
{
    //  mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:mDefalutPopupBtn dataSource:self delegate:self popupType:XDPopupListViewNormal];
}

#pragma mark - XDPopupListViewDataSource & XDPopupListViewDelegate

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return mEndContentList.count;
}
- (CGFloat)itemCellHeight:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)itemCell:(NSIndexPath *)indexPath
{
    if (mEndContentList.count == 0) {
        return nil;
    }
    static NSString *identifier = @"ddd";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    NSInteger tag = bttnTag.tag;
    
    if (tag == 1 || tag == 3 || tag == 5)
    {
        // startTime = firstViewStartSessionTxtFld.text;
        cell.textLabel.text = mStartContentList[indexPath.row];
        // startTime = [self timeFormatted:timeStr];
    }
    else{
        cell.textLabel.text = mEndContentList[indexPath.row];
        
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, cell.contentView.bounds.size.height - 1.0f, cell.contentView.bounds.size.width, 1.0f)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    lineView.backgroundColor = [UIColor darkGrayColor];
    
    [cell.contentView addSubview:lineView];
    
    // cell.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    // self.separatorStyle = UITableViewCellSeparatorStyleNone;
    // cell.separatorInset = UIEdgeInsetsMake(0, 160, 0, 160);
    return cell;
}


- (void)clickedListViewAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld: %@", (long)indexPath.row, mEndContentList[indexPath.row]);
    
    timeStr = [NSString stringWithFormat:@"%@",[mEndContentList objectAtIndex:indexPath.row]];
    timeStartStr = [NSString stringWithFormat:@"%@",[mStartContentList objectAtIndex:indexPath.row]];
    
    // timeStr = [NSString stringWithFormat:@"%.2li:%.2li", (long)hour, (long)minute];
    
    NSArray *internalTime = [timeStr componentsSeparatedByString:@":"];
    int hours = [[internalTime objectAtIndex:0]intValue];
    NSLog(@"%d",hours);
    NSInteger tag = bttnTag.tag;
    
    if (tag == 1)
    {
        firstViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStartStr];
        // startTime = firstViewStartSessionTxtFld.text;
        
        // startTime = [self timeFormatted:timeStr];
        
    }
    else if(tag == 2)
    {
        NSString *hourFormateStr = [self changeformate_string24hr:firstViewStartSessionTxtFld.text];
        
        NSArray *internalTime1 = [hourFormateStr componentsSeparatedByString:@":"];
        int startHours = [[internalTime1 objectAtIndex:0]intValue];
        startHours = startHours +2;
        NSString *hourMinuteFormateStr = [self changeformate_string24hr:timeStr];
        
        NSArray *internalTime2 = [hourMinuteFormateStr componentsSeparatedByString:@":"];
        int endHours = [[internalTime2 objectAtIndex:0]intValue];
        endTime = [self timeFormatted:timeStr];
        if ((startHours == endHours)|| (startHours <= endHours))
        {
            firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
        }
        else
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
            //firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",@"11:59 PM"];
        }
    }
    else if(tag == 3)
    {
        
        
        NSString *hourFormateStr = [self changeformate_string24hr:firstViewEndSessionTxtFld.text];
        NSArray *internalTime1 = [hourFormateStr componentsSeparatedByString:@":"];
        int startHours = [[internalTime1 objectAtIndex:0]intValue];
        startHours = startHours +1;
        
        NSString *hourMinuteFormateStr = [self changeformate_string24hr:timeStr];
        NSArray *internalTime2 = [hourMinuteFormateStr componentsSeparatedByString:@":"];
        int endHours = [[internalTime2 objectAtIndex:0]intValue];
        endTime = [self timeFormatted:timeStr];
        
        if ((startHours == endHours)|| (startHours <= endHours))
        {
            secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStartStr];
        }
        else
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
            // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",@"12:00 AM"];
        }
    }
    else if(tag == 4)
    {
        
        NSString *hourFormateStr = [self changeformate_string24hr:secondViewStartSessionTxtFld.text];
        
        NSArray *internalTime1 = [hourFormateStr componentsSeparatedByString:@":"];
        int startHours = [[internalTime1 objectAtIndex:0]intValue];
        
        startHours = startHours +2;
        NSString *hourMinuteFormateStr = [self changeformate_string24hr:timeStr];
        
        NSArray *internalTime2 = [hourMinuteFormateStr componentsSeparatedByString:@":"];
        int endHours = [[internalTime2 objectAtIndex:0]intValue];
        
        endTime = [self timeFormatted:timeStr];
        
        if ((startHours == endHours)|| (startHours <= endHours))
        {
            
            secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            
        }
        else
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
            //secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",@"11:59 PM"];
        }
    }
    else if(tag == 5)
    {
        
        NSString *hourFormateStr = [self changeformate_string24hr:secondViewEndSessionTxtFld.text];
        
        NSArray *internalTime1 = [hourFormateStr componentsSeparatedByString:@":"];
        int startHours = [[internalTime1 objectAtIndex:0]intValue];
        startHours = startHours +1;
        NSString *hourMinuteFormateStr = [self changeformate_string24hr:timeStr];
        
        NSArray *internalTime2 = [hourMinuteFormateStr componentsSeparatedByString:@":"];
        int endHours = [[internalTime2 objectAtIndex:0]intValue];
        endTime = [self timeFormatted:timeStr];
        if ((startHours == endHours)|| (startHours <= endHours))
        {
            thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStartStr];
        }
        else
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
            // thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",@"12:00 AM"];
        }
    }
    else if(tag == 6)
    {
        NSString *hourFormateStr = [self changeformate_string24hr:thirdViewStartSessionTxtFld.text];
        
        NSArray *internalTime1 = [hourFormateStr componentsSeparatedByString:@":"];
        int startHours = [[internalTime1 objectAtIndex:0]intValue];
        startHours = startHours +2;
        NSString *hourMinuteFormateStr = [self changeformate_string24hr:timeStr];
        NSArray *internalTime2 = [hourMinuteFormateStr componentsSeparatedByString:@":"];
        int endHours = [[internalTime2 objectAtIndex:0]intValue];
        endTime = [self timeFormatted:timeStr];
        if ((startHours == endHours)|| (startHours <= endHours))
        {
            thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
        }
        else
        {
            [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
            //thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",@"11:59 PM"];
        }
    }
    //}
    dateTimeStr = [NSString stringWithFormat:@"%@",timeStr];
}


-(NSString *)changeformate_string24hr:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    NSString *dateFromString = [NSString stringWithFormat:@"%@ %@",dateString,date];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate* wakeTime = [df dateFromString:dateFromString];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:wakeTime];
    
}

-(NSString *)changeformate_string24hrValue:(NSString *)date
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    NSString *dateFromString = [NSString stringWithFormat:@"%@ %@",dateString,date];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
    NSDate* wakeTime = [df dateFromString:dateFromString];
    [df setDateFormat:@"HH:mm"];
    return [df stringFromDate:wakeTime];
    
}

- (IBAction)startBttn1:(id)sender {
    
    bttnTag = (UIButton *)sender;
    if (bttnTag.tag == 1) {
        
        [self firstStartTimeSlotMethod];
        
    } else if (bttnTag.tag == 2) {
        
        [self firstEndTimeSlotMethod];
        
    } else if (bttnTag.tag == 3) {
        
        [self secondStartTimeSlotMethod];
        
    } else if (bttnTag.tag == 4) {
        
        [self secondEndTimeSlotMethod];
        
    } else if (bttnTag.tag == 5) {
        
        [self thirdStartTimeSlotMethod];
        
    } else if (bttnTag.tag == 6) {
        
        [self thirdEndTimeSlotMethod];
    }
    
    
    NSLog(@"%@",bttnTag);
}


#pragma mark First Start Time Method Call
- (void)firstStartTimeSlotMethod {
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:firstTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    [mDefalutPopupListView show];
}


#pragma mark First Start Time Method Call
- (void)firstEndTimeSlotMethod {
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:secondTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    [mDefalutPopupListView show];
}

#pragma mark Second Start Time Method Call
- (void)secondStartTimeSlotMethod {
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:thirdTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    [mDefalutPopupListView show];
}

#pragma mark Second End Time Method Call
- (void)secondEndTimeSlotMethod {
    
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:fourthTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    
    [mDefalutPopupListView show];
    
}

#pragma mark Third Start Time Method Call
- (void)thirdStartTimeSlotMethod {
    
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:fifthTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    
    [mDefalutPopupListView show];
    
}

#pragma mark Third End Time Method Call
- (void)thirdEndTimeSlotMethod {
    
    mDefalutPopupListView = [[XDPopupListView alloc] initWithBoundView:sixTimeButton dataSource:self delegate:self popupType:XDPopupListViewNormal];
    
    [mDefalutPopupListView show];
    
}


- (void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog
           didSelectHour:(NSInteger)hour
               andMinute:(NSInteger)minute {
    
    timeStr = [NSString stringWithFormat:@"%.2li:%.2li", (long)hour, (long)minute];
    
    NSArray *internalTime = [timeStr componentsSeparatedByString:@":"];
    int hours = [[internalTime objectAtIndex:0]intValue];
    
    NSInteger tag = bttnTag.tag;
    
    if (hours > 12)
    {
        if (tag == 1)
        {
            firstViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            startTime = [self timeFormatted:timeStr];
            
        }else if(tag == 2)
        {
            firstViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            startTime = [self timeFormatted:timeStr];
            
            NSInteger convertStartTime = [startTime intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            endTime = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [endTime intValue];
            
            convertEndTime = convertEndTime;
            
            
            if (convertEndTime == convertStartTime)
            {
                
                firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            //            if (convertStartTime > convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select minimum 2 hours" inController:self];
            //
            //            }else
            //            {
            //                 firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
            //
            //            }
            
            
        }
        else if(tag == 3)
        {
            NSInteger convertStartTime = [endTime intValue];
            
            convertStartTime = convertStartTime + 3600;
            
            startTimeBttn3 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [startTimeBttn3 intValue];
            
            convertEndTime = convertEndTime;
            
            //            if (convertStartTime >= convertEndTime)
            if (convertEndTime == convertStartTime)
            {
                
                secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
        }
        else if(tag == 4)
        {
            NSInteger convertStartTime = [startTimeBttn3 intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            endTimeBttn4 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [endTimeBttn4 intValue];
            
            convertEndTime = convertEndTime;
            
            //            if (convertStartTime >= convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select minimum 1 hours" inController:self];
            //            }else
            //            {
            //                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
            //
            //            }
            
            
            if (convertEndTime == convertStartTime)
            {
                
                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            // secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
        }
        else if(tag == 5)
        {
            NSInteger convertStartTime = [endTimeBttn4 intValue];
            
            convertStartTime = convertStartTime + 3600;
            
            startTimeBttn5 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [startTimeBttn5 intValue];
            
            convertEndTime = convertEndTime;
            
            
            
            if (convertEndTime == convertStartTime)
            {
                
                thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ ",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
        }
        else if(tag == 6)
        {
            NSInteger convertStartTime = [startTimeBttn5 intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            endTimeBttn6 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [endTimeBttn6 intValue];
            
            convertEndTime = convertEndTime;
            
            
            if (convertEndTime == convertStartTime)
            {
                
                thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ ",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
        }
        
    }else
    {
        if (tag == 1)
        {
            firstViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            
            startTime = [self timeFormatted:timeStr];
            
            
        }else if(tag == 2)
        {
            
            firstViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            
            startTime = [self timeFormatted:timeStr];
            
            NSInteger convertStartTime = [startTime intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            
            endTime = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [endTime intValue];
            
            convertEndTime = convertEndTime;
            
            
            if (convertEndTime == convertStartTime)
            {
                
                firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"2 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            
            //            if (convertStartTime > convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select minimum 2 hours" inController:self];
            //
            //            }else
            //            {
            //                firstViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ AM",timeStr];
            //
            //            }
            
        }
        else if(tag == 3)
        {
            NSInteger convertStartTime = [endTime intValue];
            
            convertStartTime = convertStartTime + 3600;
            
            startTimeBttn3 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [startTimeBttn3 intValue];
            
            convertEndTime = convertEndTime;
            
            
            if (convertEndTime == convertStartTime)
            {
                
                secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            //            if (convertStartTime == convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Minimun 1 Hour difference" inController:self];
            //            }else
            //            {
            //                secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ AM",timeStr];
            //
            //            }
        }
        else if(tag == 4)
        {
            NSInteger convertStartTime = [startTimeBttn3 intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            endTimeBttn4 = [self timeFormatted:timeStr];
            
            NSInteger convertEndTime = [endTimeBttn4 intValue];
            
            convertEndTime = convertEndTime;
            
            
            
            if (convertEndTime == convertStartTime)
            {
                
                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            //            if (convertStartTime >= convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select minimum 1 hours" inController:self];
            //            }else
            //            {
            //                secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ AM",timeStr];
            //
            //            }
            
            
            // secondViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
        }
        else if(tag == 5)
        {
            int convertStartTime = [endTimeBttn4 intValue];
            
            convertStartTime = convertStartTime + 3600;
            
            startTimeBttn5 = [self timeFormatted:timeStr];
            
            int convertEndTime = [startTimeBttn5 intValue];
            
            convertEndTime = convertEndTime;
            
            
            
            if (convertEndTime == convertStartTime)
            {
                
                thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            //            if (convertStartTime >= convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Minimun 1 Hour difference" inController:self];
            //            }else
            //            {
            //                thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ AM",timeStr];
            //
            //            }
            
            
            
            //            thirdViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
        }
        else if(tag == 6)
        {
            int convertStartTime = [startTimeBttn5 intValue];
            
            convertStartTime = convertStartTime + 7200;
            
            endTimeBttn6 = [self timeFormatted:timeStr];
            
            int convertEndTime = [endTimeBttn6 intValue];
            
            convertEndTime = convertEndTime;
            
            
            if (convertEndTime == convertStartTime)
            {
                
                thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
                
                
            } else if (convertEndTime > convertStartTime) {
                
                thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@",timeStr];
            }
            else
            {
                
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"1 hours interval is required." inController:self];
                // secondViewStartSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
                
            }
            
            
            
            //            if (convertStartTime >= convertEndTime)
            //            {
            //                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please select minimum 1 hours" inController:self];
            //            }else
            //            {
            //                thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ AM",timeStr];
            //
            //            }
            
            
            // thirdViewEndSessionTxtFld.text = [NSString stringWithFormat:@"%@ PM",timeStr];
        }
        
        
    }
    
    dateTimeStr = [NSString stringWithFormat:@"%@",timeStr];
    
}

- (NSString *)timeFormatted:(NSString *)time
{
    NSArray *timeArry = [time componentsSeparatedByString:@":"];
    int secondHours = [[timeArry objectAtIndex:0] intValue];
    int secondMints = [[timeArry objectAtIndex:1] intValue];
    
    int num_seconds = secondHours * (60 * 60);
    
    int minutesSecond = secondMints * 60;
    
    int  totalSecond = num_seconds + minutesSecond;
    
    NSString *finalTime = [NSString stringWithFormat:@"%d",totalSecond];
    
    //    int seconds = totalSeconds % 60;
    //    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    //
    //    NSString *finalTime = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    //
    //    NSLog(@"%@",finalTime);
    
    return finalTime;
}



/*
 - (NSString *)calculateDuration:(NSString *)oldTime secondDate:(NSString *)currentTime
 {
 
 NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
 [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
 
 NSDate *now = [NSDate date];
 NSString *dateStr1 = [dateFormatter1 stringFromDate:now];
 NSArray *dateArry = [dateStr1 componentsSeparatedByString:@" "];
 NSString *currentDate = [dateArry objectAtIndex:0];
 
 
 
 NSString *oldTimeWithDate = [NSString stringWithFormat:@"%@ %@ +0000",currentDate,oldTime];
 NSString *currentTimeWithDate = [NSString stringWithFormat:@"%@ %@ +0000",currentDate,currentTime];
 
 
 
 NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
 [dateFormatter2 setDateFormat: @"yyyy-MM-dd HH:mm a zzz"];
 
 NSDate *finalOldtime = [dateFormatter2 dateFromString:oldTimeWithDate];
 NSDate *finalCurrenttime = [dateFormatter2 dateFromString:currentTimeWithDate];
 
 NSLog(@"finalOldtime: %@", finalOldtime);
 NSLog(@"finalCurrenttime: %@", finalCurrenttime);
 
 NSTimeInterval distanceBetweenDates = [finalCurrenttime timeIntervalSinceDate:finalOldtime];
 double secondsInAnHour = 3600;
 NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
 
 NSLog(@"hoursBetweenDates: %@", hoursBetweenDates);
 
 NSString *str = [NSString stringWithFormat:@"%ld",(long)hoursBetweenDates];
 //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
 //    [dateFormat setDateFormat:@"HH:mm a"];
 //
 //    NSDate *date1 = [dateFormat dateFromString:oldTime];
 //    NSDate *date2 = [dateFormat dateFromString:currentTime];;
 //
 //    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
 //
 //    int hh = secondsBetween / (60*60);
 //    double rem = fmod(secondsBetween, (60*60));
 //    int mm = rem / 60;
 //    rem = fmod(rem, 60);
 //    int ss = rem;
 //
 //    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",hh,mm,ss];
 
 return str;
 }
 */


- (void)timePickerCancelDialog {
    
    NSLog(@"Time Cancel");
    dateTimeStr = @"";
}



- (void)createAndHandleButton {
    
    frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
    
    //CGRect frame = CGRectMake(0,0,320,40);
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstButton addTarget:self action:@selector(firstSessionAddMethodCall:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.frame = frame;
    [firstButton setTitle: @"Add Another Session" forState: UIControlStateNormal];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setTitleColor:[UIColor colorWithRed:129.0/255.0 green:90.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    firstButton.tag = 111;
    [self.view addSubview:firstButton];
    
    
    frame = CGRectMake(20,secondView.frame.origin.y+secondView.frame.size.height+2,self.view.frame.size.width-100,45);
    secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondButton addTarget:self action:@selector(secondSessionAddMethodCall:) forControlEvents:UIControlEventTouchUpInside];
    secondButton.frame = frame;
    [secondButton setTitle: @"Add Another Session" forState: UIControlStateNormal];
    secondButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [secondButton setTitleColor:[UIColor colorWithRed:129.0/255.0 green:90.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    secondButton.tag = 222;
    [self.view addSubview:secondButton];
    
    secondButton.hidden = YES;
    thirdButton.hidden = YES;
    
    if(secondView.hidden && thirdView.hidden)
    {
        
    } else {
        
    }
    
    /*
     thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [thirdButton addTarget:self action:@selector(btnAddRowTapped:) forControlEvents:UIControlEventTouchUpInside];
     thirdButton.frame = frame;
     [thirdButton setTitle: @"Add Another Session" forState: UIControlStateNormal];
     thirdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [thirdButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     thirdButton.tag = 333;
     [self.view addSubview:thirdButton];
     
     */
    
}


-(void)getSessionDetailsValue
{
    NSString *dayStr;
    dayIdStr = [self.scheduleSessionDict valueForKey:@"DayID"];
    if([dayIdStr isEqualToString:@"1"])
    {
        dayStr = @"Monday";
    }
    else if ([dayIdStr isEqualToString:@"2"])
    {
        dayStr = @"Tuesday";
    }
    else if ([dayIdStr isEqualToString:@"3"])
    {
        dayStr = @"Wednesday";
    }
    else if ([dayIdStr isEqualToString:@"4"])
    {
        dayStr = @"Thursday";
    }
    else if ([dayIdStr isEqualToString:@"5"])
    {
        dayStr = @"Friday";
    }
    else if ([dayIdStr isEqualToString:@"6"])
    {
        dayStr = @"Saturday";
    }
    else if ([dayIdStr isEqualToString:@"7"])
    {
        dayStr = @"Sunday";
    }
    dayLabel.text = dayStr;
    NSString *isWorkingDayStr = [self.scheduleSessionDict valueForKey:@"isWorkingDay"];
    if([isWorkingDayStr isEqualToString:@"True"])
    {
        
        [scheduleSessionSwitch setOn:YES];
    }
    else
    {
        [scheduleSessionSwitch setOn:NO];
        
    }
}

- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    if ([switchControl isOn]) {
        NSLog(@"its on!");
    } else {
        NSLog(@"its off!");
    }
}


- (IBAction)dayOnOffSwitchMethodCall:(id)sender {
    
    BOOL state = [sender isOn];
    if (state) {
        workingDayOnOff = @"1";
    } else {
        workingDayOnOff = @"0";
    }
    NSString *rez = state == YES ? @"YES" : @"NO";
    NSLog(@" Check On Off %@",rez);
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)firstSessionAddMethodCall:(id)sender {
    
    secondView.hidden = NO;
    firstButton.hidden = YES;
    secondButton.hidden = NO;
    frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
}

-(IBAction)secondSessionAddMethodCall:(id)sender {
    
    thirdView.hidden = NO;
    firstButton.hidden = YES;
    secondButton.hidden = YES;
    thirdButton.hidden = YES;
    firstViewdeleteButton.hidden = YES;
    
    frame = CGRectMake(20,secondView.frame.origin.y+secondView.frame.size.height+2,self.view.frame.size.width-100,45);
}


#pragma mark First Delete Button Method Call
- (IBAction)firstViewdeleteButtonClicked:(id)sender {
    
    secondButton.hidden = YES;
    secondView.hidden = YES;
    
    frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
    
    //CGRect frame = CGRectMake(0,0,320,40);
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstButton addTarget:self action:@selector(firstSessionAddMethodCall:) forControlEvents:UIControlEventTouchUpInside];
    firstButton.frame = frame;
    [firstButton setTitle: @"Add Another Session" forState: UIControlStateNormal];
    firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [firstButton setTitleColor:[UIColor colorWithRed:129.0/255.0 green:90.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    firstButton.tag = 111;
    [self.view addSubview:firstButton];
    
    secondViewStartSessionTxtFld.text = @"";
    secondViewEndSessionTxtFld.text = @"";
    
}

#pragma mark Second Delete Button Method Call
- (IBAction)secondViewdeleteButtonClicked:(id)sender
{
    thirdView.hidden = YES;
    firstViewdeleteButton.hidden = NO;
    //  secondViewStartSessionTxtFld.text = @"";
    //  secondViewEndSessionTxtFld.text = @"";
    thirdViewStartSessionTxtFld.text = @"";
    thirdViewEndSessionTxtFld.text = @"";
}

- (IBAction)selectScheduleTimeButtonClicked:(id)sender
{
    
}


-(void)fetchschedulingSessionApi{
    
    //  NSString *userIdStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"USERIDDATA"];
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",dayIdStr,@"DayID",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APIContarctorSchedulingList withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if ([responseObject isKindOfClass:[NSNull class]] || (![responseObject isKindOfClass:[NSDictionary class]])) {
            // [CommonUtils showAlertWithTitle:@"Sorry" withMsg:@"Could not connect to the server" inController:self];
        }
        else
        {
            if(!error){
                
                NSLog(@"Response is --%@",responseObject);
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                    NSArray *scheduleArray = [responseObject objectForKey:@"ContractorScheduling"];
                    int i;
                    for( i =0; i < scheduleArray.count; i++)
                    {
                        
                        NSDictionary *dict = [scheduleArray objectAtIndex:i];
                        
                        [contractorSchedulingDataArray addObject:dict];
                        
                        NSString *timeSlot = [CommonUtils checkStringForNULL:[NSString stringWithFormat:@"%@",[dict valueForKey:@"StartTime"]]];
                        NSArray *nameStr = [timeSlot componentsSeparatedByString:@"."];
                        NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                        NSLog(@"%@",fileKey);
                        NSString *reserveDate = [self convertUTCTimeToLocalTime:fileKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        NSArray *timSlotArray = [[self changeDateInParticularFormateWithString:reserveDate WithFormate:@"yyyy-MM-dd hh:mm a"] componentsSeparatedByString:@""];
                        NSString *sepreatedArrayString = [NSString stringWithFormat:@"%@",[timSlotArray firstObject]];
                        NSLog(@"Availabel Time %@",sepreatedArrayString);
                        NSString *timeEndSlot = [CommonUtils checkStringForNULL:[NSString stringWithFormat:@"%@",[dict valueForKey:@"EndTime"]]];
                        NSArray *nameEndStr = [timeEndSlot componentsSeparatedByString:@"."];
                        NSString *fileEndKey = [NSString stringWithFormat:@"%@",[nameEndStr objectAtIndex:0]];
                        NSLog(@"%@",fileEndKey);
                        NSString *reserveEndDate = [self convertUTCTimeToLocalTime:fileEndKey WithFormate:@"yyyy-MM-dd'T'HH:mm:ss"];
                        NSArray *timSlotEndArray = [[self changeDateInParticularFormateWithString:reserveEndDate WithFormate:@"yyyy-MM-dd hh:mm a"] componentsSeparatedByString:@""];
                        NSString *sepreatedEndString = [NSString stringWithFormat:@"%@",[timSlotEndArray firstObject]];
                        NSLog(@"Availabel Time %@",sepreatedArrayString);
                        endOtherTime = [self timeFormatted:sepreatedEndString];
                        
                        NSInteger convertEndTime = [endOtherTime intValue];
                        startOtherTime = [self timeFormatted:sepreatedArrayString];
                        
                        NSInteger convertStartTime = [startOtherTime intValue];
                        
                        
                        
                        if(i==0)
                        {
                            if (convertEndTime == convertStartTime)
                            {
                                
                                firstViewStartSessionTxtFld.text = sepreatedArrayString;
                                firstViewEndSessionTxtFld.text = sepreatedEndString;
                                firstViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstView.hidden = NO;
                                frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                                
                                
                            } else if (convertEndTime > convertStartTime) {
                                
                                firstViewStartSessionTxtFld.text = sepreatedArrayString;
                                firstViewEndSessionTxtFld.text = sepreatedEndString;
                                firstViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstView.hidden = NO;
                                frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                            }
                            else
                            {
                                
                                firstViewStartSessionTxtFld.text = @"12:00 AM";
                                firstViewEndSessionTxtFld.text = @"11:59 PM";
                                
                            }
                            //                            firstViewStartSessionTxtFld.text = sepreatedArrayString;
                            //                            firstViewEndSessionTxtFld.text = sepreatedEndString;
                            //                            firstViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                            //                            firstViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                            //                            firstView.hidden = NO;
                            //                            frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                        }
                        if(i==1)
                        {
                            if (convertEndTime == convertStartTime)
                            {
                                secondView.hidden = NO;
                                firstViewdeleteButton.hidden = NO;
                                frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                                secondViewStartSessionTxtFld.text = sepreatedArrayString;
                                secondViewEndSessionTxtFld.text = sepreatedEndString;
                                secondViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                secondViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstButton.hidden = YES;
                                secondButton.hidden = NO;
                                
                            }
                            else if (convertEndTime > convertStartTime) {
                                
                                secondView.hidden = NO;
                                firstViewdeleteButton.hidden = NO;
                                frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                                secondViewStartSessionTxtFld.text = sepreatedArrayString;
                                secondViewEndSessionTxtFld.text = sepreatedEndString;
                                secondViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                secondViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstButton.hidden = YES;
                                secondButton.hidden = NO;
                            }
                            else
                            {
                                secondViewStartSessionTxtFld.text = @"12:00 AM";
                                secondViewEndSessionTxtFld.text = @"11:59 PM";
                            }
                        }
                        if(i==2)
                        {
                            if (convertEndTime == convertStartTime)
                            {
                                thirdView.hidden = NO;
                                frame = CGRectMake(20,thirdView.frame.origin.y+thirdView.frame.size.height+2,self.view.frame.size.width-100,45);
                                thirdViewStartSessionTxtFld.text = sepreatedArrayString;
                                thirdViewEndSessionTxtFld.text = sepreatedEndString;
                                thirdViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                thirdViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstButton.hidden = YES;
                                secondButton.hidden = YES;
                            }
                            
                            else if (convertEndTime > convertStartTime)
                            {
                                thirdView.hidden = NO;
                                frame = CGRectMake(20,thirdView.frame.origin.y+thirdView.frame.size.height+2,self.view.frame.size.width-100,45);
                                thirdViewStartSessionTxtFld.text = sepreatedArrayString;
                                thirdViewEndSessionTxtFld.text = sepreatedEndString;
                                thirdViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                thirdViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                                firstButton.hidden = YES;
                                secondButton.hidden = YES;
                            }
                            else
                            {
                                thirdViewStartSessionTxtFld.text = @"12:00 AM";
                                thirdViewEndSessionTxtFld.text = @"11:59 PM";
                            }
                        }
                    }
                    
                    if (contractorSchedulingDataArray.count == 1)
                    {
                        firstViewdeleteButton.hidden = NO;
                    }
                }
                else
                {
                    //[CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                    firstViewStartSessionTxtFld.text = @"12:00 AM";
                    firstViewEndSessionTxtFld.text = @"11:59 PM";
                    firstViewStartSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                    firstViewEndSessionTxtFld.textAlignment = NSTextAlignmentCenter;
                    firstView.hidden = NO;
                    frame = CGRectMake(20,firstView.frame.origin.y+firstView.frame.size.height+2,self.view.frame.size.width-100,45);
                }
            }
            else
            {
                NSLog(@"Error is found");
                [CommonUtils showAlertWithTitle:@"Alert" withMsg:@"Please insert valid User name and Password." inController:self];
            }
        }
    }];
}

- (IBAction)doneBttn:(id)sender {
    [self updateContractorschedulingSessionApi];
}

-(NSString *)getUTCFormateDateWithString:(NSString *)localDate
{
    
    NSDateFormatter *dateFormatterString=[[NSDateFormatter alloc] init];
    [dateFormatterString setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatterString stringFromDate:[NSDate date]];
    NSString *utcFromate = [NSString stringWithFormat:@"%@T%@:00",dateString,localDate];
    
    NSDateFormatter *dateUTCString=[[NSDateFormatter alloc] init];
    [dateUTCString setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *convertedUTCDate = [[NSDate alloc] init];
    
    convertedUTCDate = [dateUTCString dateFromString:utcFromate];
    NSLog(@"UTC Date %@",convertedUTCDate);
    NSDateFormatter *UTCDateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [UTCDateFormatter setTimeZone:timeZone];
    [UTCDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSString *dateStringVlaue = [UTCDateFormatter stringFromDate:convertedUTCDate];
    return dateStringVlaue;
}

#pragma mark Update Contractor Schedule Api Call
- (void)updateContractorschedulingSessionApi{
    
    NSString *userIdStr = sharedInstance.userId;
    for (int i=0; i<3; i++)
    {
        if (i == 0)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            NSString *hourFormateStr = [self changeformate_string24hrValue:firstViewStartSessionTxtFld.text];
            NSString *hourMinuteFormateStr = [self changeformate_string24hrValue:firstViewEndSessionTxtFld.text];
            NSArray *nameStr = [hourFormateStr componentsSeparatedByString:@" "];
            NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
            NSArray *nameEndStr = [hourMinuteFormateStr componentsSeparatedByString:@" "];
            NSString *fileEndKey = [NSString stringWithFormat:@"%@",[nameEndStr objectAtIndex:0]];
            [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileKey]] forKey:@"StartTime"];
            [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileEndKey]] forKey:@"EndTime"];
            [arryschedule addObject:dict];
            
        }
        if (i == 1) {
            
            if([secondViewStartSessionTxtFld.text length]==0) {
            }
            else {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                NSString *hourFormateStr = [self changeformate_string24hr:secondViewStartSessionTxtFld.text];
                NSString *hourMinuteFormateStr = [self changeformate_string24hr:secondViewEndSessionTxtFld.text];
                NSArray *nameStr = [hourFormateStr componentsSeparatedByString:@" "];
                NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                NSArray *nameEndStr = [hourMinuteFormateStr componentsSeparatedByString:@" "];
                NSString *fileEndKey = [NSString stringWithFormat:@"%@",[nameEndStr objectAtIndex:0]];
                [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileKey]] forKey:@"StartTime"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileEndKey]] forKey:@"EndTime"];
                [arryschedule addObject:dict];
            }
        }
        
        if (i == 2)
        {
            if([thirdViewStartSessionTxtFld.text length]==0) {
            }
            else {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                NSString *hourFormateStr = [self changeformate_string24hr:thirdViewStartSessionTxtFld.text];
                NSString *hourMinuteFormateStr = [self changeformate_string24hr:thirdViewEndSessionTxtFld.text];
                NSArray *nameStr = [hourFormateStr componentsSeparatedByString:@" "];
                NSString *fileKey = [NSString stringWithFormat:@"%@",[nameStr objectAtIndex:0]];
                NSArray *nameEndStr = [hourMinuteFormateStr componentsSeparatedByString:@" "];
                NSString *fileEndKey = [NSString stringWithFormat:@"%@",[nameEndStr objectAtIndex:0]];
                [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileKey]] forKey:@"StartTime"];
                [dict setObject:[NSString stringWithFormat:@"%@",[self getUTCFormateDateWithString:fileEndKey]] forKey:@"EndTime"];
                [arryschedule addObject:dict];
            }
        }
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:arryschedule forKey:@"ContractorSchedulingList"];
    [params setObject:userIdStr forKey:@"userID"];
    [params setObject:dayIdStr forKey:@"DayID"];
    [params setObject:workingDayOnOff forKey:@"isWorkingDay"];
    
    NSLog(@"%@",params);
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    NSString *resultAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData as string:\n%@", resultAsString);
    
    id json = resultAsString;
    NSLog(@"%@",json);
    
    if([AFNetworkReachabilityManager sharedManager].reachable) {
        
        [ProgressHUD show:@"Please wait..." Interaction:NO];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.requestSerializer = serializer;
        
        [manager POST:[NSString stringWithFormat:@"%@%@",NewBaseServerUrl,APIUpdateContarctorSchedulingList] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [ProgressHUD dismiss];
            
            if(!error) {
                
                if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [CommonUtils showAlertWithTitle:@"Alert" withMsg:[responseObject objectForKey:@"Message"] inController:self];
                }
            }
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [ProgressHUD dismiss];
            NSLog(@"the falire is %@", error);
        }];
        
    }
    else
    {
        [ServerRequest networkConnectionLost];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark:- Change UTC time Current Local Time
-(NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    NSDateFormatter *dateFormatter5 = [[NSDateFormatter alloc]init];
    [dateFormatter5 setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter5 setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter5 dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    if (isDayLightSavingTime) {
        //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
        //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    }
    [dateFormatter5 setLocale:[NSLocale currentLocale]];
    [dateFormatter5 setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
}

-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"hh:mm a"];
    NSString *dateRepresentation = [dateFormatter2 stringFromDate:formatedDate];
    return dateRepresentation;
}

@end
