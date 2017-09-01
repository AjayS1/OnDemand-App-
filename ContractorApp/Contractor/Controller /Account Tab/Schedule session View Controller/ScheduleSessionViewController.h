
//  ScheduleSessionViewController.h
//  Contractor
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "XDPopupListView.h"

@interface ScheduleSessionViewController : UIViewController <XDPopupListViewDataSource, XDPopupListViewDelegate> {
    
    IBOutlet UITableView *scheduleSessionTableView;
    NSMutableArray *sceduleSessionTableDataArray;
    
    IBOutlet UISwitch *scheduleSessionSwitch;
    IBOutlet UILabel *dayLabel;
    IBOutlet UITextField *firstViewStartSessionTxtFld;
    IBOutlet UITextField *firstViewEndSessionTxtFld;
    IBOutlet UITextField *secondViewStartSessionTxtFld;
    IBOutlet UITextField *secondViewEndSessionTxtFld;
    IBOutlet UITextField *thirdViewStartSessionTxtFld;
    IBOutlet UITextField *thirdViewEndSessionTxtFld;
    IBOutlet UIView *firstView;
    IBOutlet UIView *secondView;
    IBOutlet UIView *thirdView;
    IBOutlet UIButton *firstViewdeleteButton;
    IBOutlet UIButton *secondViewdeleteButton;
    
    IBOutlet UIButton *firstTimeButton;
    
    IBOutlet UIButton *secondTimeButton;
    
    IBOutlet UIButton *thirdTimeButton;
    
    IBOutlet UIButton *fourthTimeButton;
    
    IBOutlet UIButton *fifthTimeButton;

    IBOutlet UIButton *sixTimeButton;
    
    
    UIButton *firstButton;
    UIButton *secondButton;
    UIButton *thirdButton;
    CGRect frame;
    NSString *dayIdStr;
    NSMutableArray *contractorSchedulingDataArray;
    

    XDPopupListView *mDefalutPopupListView;
    NSMutableArray *mStartContentList;
    NSMutableArray *mEndContentList;

}
@property(nonatomic,strong) NSDictionary *scheduleSessionDict;


- (IBAction)dayOnOffSwitchMethodCall:(id)sender;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)firstViewdeleteButtonClicked:(id)sender;
- (IBAction)secondViewdeleteButtonClicked:(id)sender;
- (IBAction)selectScheduleTimeButtonClicked:(id)sender;



@end
