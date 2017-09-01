
//  SettingsViewController.h
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *settingsTableView;
}


- (IBAction)backButtonClicked:(id)sender;


@end
