//
//  CurrentLocationsViewController.h
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentLocationsViewController : UIViewController<UITextFieldDelegate> {
    
    IBOutlet UITextField *countryTextField;
    IBOutlet UITextField *cityTextField;
    IBOutlet UITextField *stateTextField;
    IBOutlet UITextField *zipCodeTextField;
    IBOutlet UITextField *labelTextField;
    IBOutlet UITextField *AddressTextField;
    NSString *locationStr;
}

- (IBAction)doneButtonClicked:(id)sender;

- (IBAction)backButtonClicked:(id)sender;


@end
