
//  ScheduleViewController.h
//  Contractor
//  Created by Jamshed Ali on 27/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface ScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *scheduleTableView;
    NSMutableArray *sceduleTableDataArray;
    
}

- (IBAction)backButtonClicked:(id)sender;


@end
