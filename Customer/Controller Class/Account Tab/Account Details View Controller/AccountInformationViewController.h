
//  AccountInformationViewController.h
//  Customer
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
typedef enum {
    
    ALERT_TYPE_FIRSTNAME = 100,
    ALERT_TYPE_LASTNAME,
    ALERT_TYPE_DOB
} ALERT_TYPE;

@interface AccountInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    ALERT_TYPE *enumTypes;
    IBOutlet UITableView *accountTableView;
    NSMutableArray *tabledataArray;
    NSMutableArray * userInfoArr;
}


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)saveInformationButtonClicked:(id)sender;
- (IBAction)closeAccountButtonClicked:(id)sender;
@end
