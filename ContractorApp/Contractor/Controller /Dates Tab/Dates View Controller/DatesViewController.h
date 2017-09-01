
//  DatesViewController.h
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface DatesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView *datesTable;
}
- (IBAction)segmentAction:(id)sender;
//@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
//@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
//@property (strong, nonatomic) IBOutlet UILabel *adressLbl;
//@property (strong, nonatomic) IBOutlet UILabel *statusAcceptedLbl;
@property (assign) BOOL isFromDateDetails;
@property (assign) BOOL isFromDateCancel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentButton;

@end
