//
//  NotificationDetailsViewController.h
//  Customer
//
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UILabel *notificationDetailsLbl;
    IBOutlet UITableView *notificationTableView;
}

@property(nonatomic,strong)NSString *notificationType;
@property(nonatomic,strong)NSString *notificationMessageStr;
@property(nonatomic,strong)NSString *maxIdStr;
@property(nonatomic,strong)NSString *idStr;
- (IBAction)backBtnClicked:(id)sender;
@end
