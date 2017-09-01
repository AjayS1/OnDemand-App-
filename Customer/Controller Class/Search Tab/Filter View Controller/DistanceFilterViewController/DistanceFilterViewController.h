//
//  DistanceFilterViewController.h
//  Customer
//
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistanceFilterViewController : UIViewController {

    IBOutlet UISlider *distanceSlider;
    IBOutlet UILabel *distanceValueLabel;
    
}

- (IBAction)distanceSliderMethodCall:(id)sender;

- (IBAction)backBtnClicked:(id)sender;


@end
