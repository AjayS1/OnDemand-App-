//
//  UpdateProfileSelectionViewController.h
//  Customer
//
//  Created by Deepak on 7/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateProfileSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *updateProfileTable;
    NSMutableArray *updateProfileDataArray;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *doneButton;
    NSString *bodyTypeValueStr;
    NSString *bodyTypeIdStr;
    NSMutableArray *languageDataArray;
    NSMutableArray *smokingDataArray;
    NSMutableArray *drinkingDataArray;
    NSMutableArray *cellSelected;
    NSMutableArray *commonArray;
}
@property(nonatomic,strong) NSString *selectedIndexxStr;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSMutableArray *languageIdArray;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;


@end
