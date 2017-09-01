//
//  ReserveViewController.h
//  Customer
//
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SPGooglePlacesAutocomplete.h"
#import "AutocompletionTableView.h"
@class SPGooglePlacesAutocompleteQuery;

@interface ReserveViewController : UIViewController<UITextFieldDelegate,AutocompletionTableViewDelegate> {
    
    SPGooglePlacesAutocompleteQuery *searchQuery;
    NSArray *searchResultPlaces;

    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UITextField *meetingTextField;
    IBOutlet SAMTextView *meetingTextView;

    IBOutlet UILabel *meetingLabel;
    IBOutlet UIView *meetingView;
    IBOutlet UITextField *notesTextField;
    IBOutlet UIButton *rewardButton;
    IBOutlet UITextField *dayTimeTextField;
    IBOutlet UILabel *perhourPriceLbl;
    IBOutlet UILabel *minimumHourPriceLbl;
    IBOutlet UILabel *minuteAfterPriceLbl;
    IBOutlet UILabel *userNameLbl;
    IBOutlet UIView *estimatedRateView;
   
    IBOutlet UIImageView *dropDownImage;
    IBOutlet UIButton *sendReserveRequestButton;
    IBOutlet UIButton *enterPromoCodeButton;
    IBOutlet UILabel *promoCodeLabel;
    
    
}
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@property(nonatomic,strong) NSMutableDictionary *reserveDataDictionary;
@property(strong,nonatomic)NSString *checkControllerStr;

@property(strong,nonatomic)NSString *checkRequestNowControllerStr;

@property(strong,nonatomic)NSString *imageUrlStr;
@property(strong,nonatomic)NSString *contractorId;

@property(strong,nonatomic)NSString *rewardOnOff;


- (IBAction)backBtnClicked:(id)sender;
- (IBAction)dateTimeMethodCall:(id)sender;
- (IBAction)rewardButtonClicked:(id)sender;
- (IBAction)meetUpAddressButtonClicked:(id)sender;

@end
