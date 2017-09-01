
//  AddressAutoCompleteViewController.h
//  Customer
//  Created by Jamshed Ali on 23/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "SPGooglePlacesAutocomplete.h"
#import "AutocompletionTableView.h"

@protocol AutoLocationDelegtae <NSObject>
-(void)locationString :(NSString*)str;
@end

@interface AddressAutoCompleteViewController : UIViewController<UITextFieldDelegate,AutocompletionTableViewDelegate,UITableViewDelegate,UITableViewDataSource> {
    SPGooglePlacesAutocompleteQuery *searchQuery;
    NSArray *searchResultPlaces;
    IBOutlet UITextField *addressTextField;
}

@property (nonatomic, strong) CLGeocoder* geocoder;
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, weak) id <AutoLocationDelegtae > delegate;
@property (assign) BOOL isFromRequestNow;
@property (assign) BOOL isFromGPSLocation;

-(IBAction)cancelBtnClicked:(id)sender;


@end
