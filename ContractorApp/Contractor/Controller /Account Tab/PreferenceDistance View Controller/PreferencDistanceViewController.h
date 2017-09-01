//
//  PreferencDistanceViewController.h
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencDistanceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *distanceTableView;
    NSMutableArray *distanceTableDataArray;
    NSMutableArray *selectedIndexArr;
    NSString *selectedDistanceId;
}
@property(nonatomic,strong) NSString *selectedIndexxStr;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
