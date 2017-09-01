
//  LocationViewController.h
//  Customer
//  Created by Jamshed on 8/3/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface LocationViewController : UIViewController
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *sliderVlaueLbl;
    IBOutlet UILabel *sliderMaximumVlaueLbl;
    IBOutlet UITextField *countryTextFld;
    IBOutlet UITextField *stateTextFld;
    IBOutlet UITextField *cityTextFld;
    IBOutlet UITextField *zipCodeTextFld;
    IBOutlet UISlider *sliderView;
    NSString *locationStr;
    NSString *sliderValueStr;
    int progressAsInt;
}

@property(nonatomic,strong) NSString *titleStr;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)sliderButtonClicked:(UISlider *)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
