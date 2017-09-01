
//  BodyTypeViewController.h
//  Customer
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface BodyTypeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *bodyTypeTableView;

- (IBAction)backButtonClicked:(id)sender;
@end
