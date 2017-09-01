//
//  UpdateProfileSelectionViewController.h
//  Customer
//
//  Created by Jamshed on 7/12/16.
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
    NSMutableArray *arOptions;
    NSMutableArray *selectedMultipleRowDataArray;
    NSMutableArray *languageNameArray;
    NSMutableArray *modelTypeNameArray;
    NSMutableArray *modelTypeIdArray;
    NSMutableArray *bodyTypeArray;
    NSMutableArray *bodyTypeIdArray;
    NSMutableArray *ethnicityTypeArray;
    NSMutableArray *ethnicityTypeIdArray;
    NSMutableArray *eyeTypeArray;
    NSMutableArray *eyeIdArray;
    NSMutableArray *hairTypeArray;
    NSMutableArray *hairIdArray;
    NSMutableArray *educationTypeArray;
    NSMutableArray *educationIdArray;
    NSMutableArray *commonArray;

}

@property(nonatomic,strong) NSString *selectedIndexxStr;
@property(nonatomic,strong) NSString *typeValueStr;

@property(nonatomic,assign) BOOL isCheckedFilterValue;
@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSMutableArray *languageIdArray;
@property(nonatomic,strong) NSMutableArray *smokingIdArray;
@property(nonatomic,strong) NSMutableArray *smokingNameArray;
@property(nonatomic,strong) NSMutableArray *drinkingNameArray;

@property(nonatomic,strong) NSMutableArray *drinkingIdArray;



- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;


@end
