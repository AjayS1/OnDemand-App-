
//  NotificationsViewController.h
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *notificationTableView;
}

@end
