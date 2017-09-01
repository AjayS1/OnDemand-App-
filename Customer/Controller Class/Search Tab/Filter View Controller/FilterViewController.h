
//  FilterViewController.h
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "SingletonClass.h"

@interface FilterViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
    IBOutlet UITableView *sortTable;
    UITextField *countryTextFiled;
    UITextField *stateTextFiled;
    UITextField *cityTextFiled;
    UITextField *zipCodeTextFiled;
    UITextField *ageTextFiled;
    UIView *friendListVw;
    NSString *locationStr;
    NSString *ageStr;
    NSString *typeStr;
    SingletonClass *sharedInstance;
    
    // Set UpdatedValue
    NSMutableDictionary *dictForTypeDataValue;
    NSMutableDictionary *dictForBodyTypeDataValue;
    NSMutableDictionary *dictForEthnicityValue;
    NSMutableDictionary *dictForEyeColorValue;
    NSMutableDictionary *dictForHairValue;
    NSMutableDictionary *dictForSmokingValue;
    NSMutableDictionary *dictForDrinkingValue;
    NSMutableDictionary *dictForEducationValue;
    NSMutableDictionary *dictForLanguageValue;
    NSMutableDictionary *dictForWeightValue;
    NSMutableDictionary *dictForHeightValue;
    
    NSString *languageSelectedName;
    
    NSArray *arrAgePickerView;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UISegmentedControl *segmentedControl1;
    IBOutlet UISegmentedControl *availableNowSegmentedControl;
    
    BOOL  isEmpty;
    UIView *viewForPicker;
    
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentButton;

@property (nonatomic, retain) UIPickerView *pickerView;
@property(nonatomic,strong) NSMutableArray *userProfileDataArray;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)resetBtnClicked:(id)sender;
- (IBAction)searchBtnClicked:(id)sender;
- (IBAction)segmentControlBtnClicked:(UISegmentedControl *)SControl;
- (IBAction)secondSegmentControlBtnClicked:(UISegmentedControl *)SControl;
- (IBAction)availableNowSecondSegmentControlBtnClicked:(UISegmentedControl *)SControl;



@end
