//
//  GenderPreferenceViewController.h
//  Contractor
//
//  Created by Deepak on 9/1/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderPreferenceViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *genderPreferencesTableView;
    NSMutableArray *genderPreferencesTableDataArray;
    NSString *selectedgenderData;
    }
@property(nonatomic,strong) NSString *genderStr;
@property(nonatomic,strong) NSString *genderLblStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
