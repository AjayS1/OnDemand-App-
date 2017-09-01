//
//  WeightFilterViewController.h
//  Customer
//
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MARKRangeSlider.h"
#import "UIColor+Demo.h"
@interface WeightFilterViewController : UIViewController {
    
    IBOutlet UILabel *weightRangeLabel;
}

@property (nonatomic, strong) MARKRangeSlider *rangeWeightSlider;

- (IBAction)backButtonClicked:(id)sender;

@end
