//
//  CreditCardViewController.h
//  Customer
//
//  Created by Jamshed on 7/27/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "TESignatureView.h"
#import "DMTextField.h"

@interface CreditCardViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource> {
    
     IBOutlet UIScrollView *bgScrollView;
     IBOutlet DMTextField *cardNumberTxt;
     IBOutlet DMTextField *monthTxt;
     IBOutlet DMTextField *yearTxt;
     IBOutlet DMTextField *securityCodeNumberTxt;
     IBOutlet DMTextField *nameOfCardTxt;
     IBOutlet DMTextField *addressTxt;
     IBOutlet DMTextField *cityTxt;
     IBOutlet DMTextField *stateOrProvinceTxt;
     IBOutlet DMTextField *zipOrPostalCodeTxt;
     IBOutlet DMTextField *countryTxt;
   //  IBOutlet UITextField *signatureTxtView;
   //     __weak IBOutlet TESignatureView *signtureView;
   //  TESignatureView *signtureView;
     UIPickerView *datePicker;
     UIToolbar* numberToolbar;
     NSString *monthStr;
     NSString *verifiedId;
    IBOutlet UIButton *countryButton;
    
}


@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *countryListpickerViewArray;

@property (assign) IBOutlet UIButton *monthButton;

@property (strong, nonatomic) IBOutlet UIButton *yearButton;

//@property (strong, nonatomic) IBOutlet TESignatureView *signtureView;


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
