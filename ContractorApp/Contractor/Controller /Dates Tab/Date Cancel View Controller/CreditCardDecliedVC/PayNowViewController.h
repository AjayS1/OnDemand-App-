
//  PayNowViewController.h
//  Customer
//  Created by Jamshed Ali on 15/09/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "TESignatureView.h"

@interface PayNowViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIScrollView *bgScrollView;
    
    IBOutlet UITextField *cardNumberTxt;
    IBOutlet UITextField *monthTxt;
    IBOutlet UITextField *yearTxt;
    IBOutlet UITextField *securityCodeNumberTxt;
    IBOutlet UITextField *nameOfCardTxt;
    IBOutlet UITextField *addressTxt;
    IBOutlet UITextField *cityTxt;
    IBOutlet UITextField *stateOrProvinceTxt;
    IBOutlet UITextField *zipOrPostalCodeTxt;
    IBOutlet UITextField *countryTxt;
    
    IBOutlet UIButton *countryButton;
   
    UIPickerView *datePicker;
    UIToolbar* numberToolbar;
    NSString *monthStr;
    NSString *verifiedId;
}

@property(nonatomic,strong)NSString *totalAmountStr;
@property(nonatomic,strong)NSString *amountPaidForDateID;
@property(nonatomic,strong)NSDictionary *dateDetailsDictionaryFromDecline;
@property(assign) BOOL isFromCreditCardDeclined;
@property(assign) BOOL isFromCancelDateByCustomer;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *countryListpickerViewArray;

@property (assign) IBOutlet UIButton *monthButton;
@property (strong, nonatomic) IBOutlet UIButton *yearButton;

@property (strong, nonatomic) TESignatureView *signtureView;
@property (strong, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (strong, nonatomic) IBOutlet UIButton *signatureCreateButton;

-(IBAction)backButtonMethodClicked:(id)sender;
-(IBAction)countryListButtonClicked:(id)sender;
-(IBAction)AddCreditCardClicked:(id)sender;
- (IBAction)yearButtonClicked:(id)sender;
- (IBAction)monthButtonClicked:(id)sender;
- (IBAction)clearSIgnButtonClicked:(id)sender;
- (IBAction)saveSignButtonClicked:(id)sender;
- (IBAction)signatureCreateButtonClicked:(id)sender;


@end
