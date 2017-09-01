//
//  OnDemandDateReasonForDeclineViewController.h
//  Contractor
//
//  Created by Jamshed Ali on 09/09/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnDemandDateReasonForDeclineViewController : UIViewController {
    
    IBOutlet UILabel *titleLabel;
}

@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
@property(strong,nonatomic)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateDiclineOrDateCancelStr;
@property(strong,nonatomic)NSString *titleStr;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)dateCancelButtonClicked:(id)sender;

@end
