
//  AlertsViewController.h
//  Customer
//  Created by Jamshed Ali on 14/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface AlertsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *alertTableView;
    NSMutableArray *userAlertDataArray;
}


- (IBAction)backButtonClicked:(id)sender;

@end
