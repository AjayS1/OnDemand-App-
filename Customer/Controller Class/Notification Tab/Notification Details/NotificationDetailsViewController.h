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


@property(nonatomic,strong)NSString *maxIdStr;
@property(nonatomic,strong)NSString *idStr;

@property(nonatomic,strong)NSString *notificationMessageStr;

- (IBAction)backBtnClicked:(id)sender;


@end
