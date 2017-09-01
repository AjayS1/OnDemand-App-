
//  UseGPSLocationFilterViewController.h
//  Customer
//  Created by Jamshed Ali on 23/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface UseGPSLocationFilterViewController : UIViewController {
    
    IBOutlet UIView *locationView;
    IBOutlet UISwitch *gpsOnOffSwitch;
    IBOutlet UILabel *selectedAddressLabel;
    
}

- (IBAction)gpsLocationOnOff:(id)sender;

- (IBAction)backBtnClicked:(id)sender;

- (IBAction)selectAddressOrPincode:(id)sender;



@end
