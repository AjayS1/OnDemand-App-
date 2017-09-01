
//  SettingsViewController.h
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
- (IBAction)backButtonClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *settingsTableView;

@end
