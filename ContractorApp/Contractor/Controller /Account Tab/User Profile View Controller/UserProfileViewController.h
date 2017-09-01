
//  UserProfileViewController.h
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    
    IBOutlet UITableView *profileTableView;
    NSArray *userProfileDataArray;
    NSMutableArray *profileTableDataArray;
}

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
