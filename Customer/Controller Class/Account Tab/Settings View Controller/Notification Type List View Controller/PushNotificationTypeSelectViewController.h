//
//  PushNotificationTypeSelectViewController.h
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushNotificationTypeSelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>  {
    
    IBOutlet UITableView *pushNotificationTableView;
    NSMutableArray *pushSettingsData;
}

- (IBAction)backButtonClicked:(id)sender;

@end
