//
//  PreferenceViewController.h
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferenceViewController : UIViewController
{

    IBOutlet UILabel *genderPreferneceLable;
    IBOutlet UILabel *distanceLable;
    IBOutlet UILabel *currentLocationLable;
    IBOutlet UILabel *paymentTypeLable;
    NSDictionary *paymentDictData;
    NSMutableArray *paymentModeArr;
    NSString *genderLl;
}

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)genderPreferneceButtonClicked:(id)sender;
- (IBAction)distanceButtonClicked:(id)sender;
- (IBAction)currentLocationButtonClicked:(id)sender;
- (IBAction)paymentTypeButtonClicked:(id)sender;


@end
