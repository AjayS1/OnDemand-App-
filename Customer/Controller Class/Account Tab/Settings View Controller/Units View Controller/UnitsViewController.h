//
//  UnitsViewController.h
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitsViewController : UIViewController {
    
    IBOutlet UIImageView *selectFirstImageView;
    IBOutlet UIImageView *selectSecondIMageView;
    IBOutlet UIButton *feetButton;
    IBOutlet UIButton *meterButton;
}


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)feetButtonClicked:(id)sender;
- (IBAction)centeMeterButtonClicked:(id)sender;

@end
