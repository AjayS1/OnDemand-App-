
//  AgeFilterViewController.h
//  Customer
//  Created by Jamshed Ali on 24/11/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

#import "MARKRangeSlider.h"
#import "UIColor+Demo.h"

@interface AgeFilterViewController : UIViewController {
    
    IBOutlet UILabel *ageRangeLabel;
    
}

@property (nonatomic, strong) MARKRangeSlider *rangeAgeSlider;


- (IBAction)backButtonClicked:(id)sender;



@end
