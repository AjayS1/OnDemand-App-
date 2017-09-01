
//  DatesViewController.h
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface DatesViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *datesTable;
    
}
@property (assign) BOOL isFromDateDetails;

@property (strong, nonatomic) IBOutlet UISegmentedControl  *segmentButton;
- (IBAction)segmentAction:(id)sender;

@property (strong, nonatomic)IBOutlet UIImageView *dateImageView;
@property (strong, nonatomic)IBOutlet UILabel *dontHaveMessage;



@end
