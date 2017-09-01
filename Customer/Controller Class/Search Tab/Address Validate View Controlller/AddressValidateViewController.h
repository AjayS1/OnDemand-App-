
//  AddressValidateViewController.h
//  Customer
//  Created by Jamshed Ali on 25/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface AddressValidateViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UITextField *locationNameTextField;
    IBOutlet UITextField *streetAddressTextField;
    IBOutlet UITextField *zipCodeTextField;
    SPGooglePlacesAutocompleteQuery *searchQuery;
    NSArray *searchResultPlaces;

    IBOutlet UIButton *countryButton;
}

@property (nonatomic, retain) NSMutableArray *countryListpickerViewArray;
@property (nonatomic, retain) NSMutableArray *countryListpickerrray;

@property (nonatomic, retain) NSMutableArray *stateListpickerViewArray;
@property (nonatomic, retain) NSMutableArray *stateListpickerrray;
@property (nonatomic, retain) NSMutableArray *cityListpickerViewArray;
@property (nonatomic, retain) NSMutableArray *cityListpickerrray;
@property (weak, nonatomic)  IBOutlet UITextField *countryTextField;
@property (weak, nonatomic)  IBOutlet UITextField *cityTextField;
@property (weak, nonatomic)  IBOutlet UITextField *stateTextField;

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
-(IBAction)countryListButtonClicked:(id)sender;

@property(nonatomic,assign) BOOL isCheckedFilterValue;


@end
