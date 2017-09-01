//
//  DateCancelViewController.h
//  Contractor
//
//  Created by Jamshed Ali on 17/08/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateCancelViewController : UIViewController {
    
    IBOutlet UILabel *titleLabel;
}

@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;
@property(strong,nonatomic)NSString *dateIdStr;
@property(strong,nonatomic)NSString *dateDiclineOrDateCancelStr;
@property(strong,nonatomic)NSString *titleStr;
@property(strong,nonatomic)NSString *buttonSattus;
@property(strong,nonatomic)NSString *dateTypeStr;


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)dateCancelButtonClicked:(id)sender;

@end
