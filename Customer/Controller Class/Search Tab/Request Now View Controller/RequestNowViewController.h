//
//  RequestNowViewController.h
//  Customer
//  Created by Jamshed Ali on 09/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

#import "SPGooglePlacesAutocomplete.h"
#import "AutocompletionTableView.h"

@class GradientProgressView;

@interface RequestNowViewController : UIViewController<UITextFieldDelegate,AutocompletionTableViewDelegate>  {
    
    SPGooglePlacesAutocompleteQuery *searchQuery;
    NSArray *searchResultPlaces;
    
    IBOutlet UIScrollView *bgScrollView;
    IBOutlet UITextField *meetingTextField;
    IBOutlet UITextField *notesTextField;
    IBOutlet UIButton *rewardButton;
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *perhourPriceLbl;
    IBOutlet UILabel *minimumHourPriceLbl;
    IBOutlet UILabel *minuteAfterPriceLbl;
    IBOutlet UILabel *userNameLbl;
    IBOutlet UIImageView *dropDownImage;
    IBOutlet SAMTextView *meetingTextView;
    IBOutlet UIView *estimatedRateView;
    
    IBOutlet UIButton *sendRequestNowButton;
    
    IBOutlet UIButton *locationButton;
    
    GradientProgressView *progressView;

    IBOutlet UIButton *enterPromoCodeButton;
    IBOutlet UILabel *promoCodeLabel;
    
}

@property (strong, nonatomic) CAGradientLayer *gradient;

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;

@property(nonatomic,strong) NSMutableDictionary *requestNowDataDictionary;
@property(strong,nonatomic)NSString *checkControllerStr;
@property(strong,nonatomic)NSString *imageUrlStr;
@property(strong,nonatomic)NSString *contractorId;


- (IBAction)backBtnClicked:(id)sender;
- (IBAction)sentRequestBtnClicked:(id)sender;
- (IBAction)rewardButtonClicked:(id)sender;

- (IBAction)meetUpAddressButtonClicked:(id)sender;
- (IBAction)enterPromoCodeMethodClicked:(id)sender;


@end
