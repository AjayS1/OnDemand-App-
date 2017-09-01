//
//  BlockViewController.h
//  Contractor
//
//  Created by Aditi on 31/07/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockViewController : UIViewController{
IBOutlet UITableView *blockTableView;
}
@property(nonatomic,strong)NSMutableArray *tableDataArray;
- (IBAction)backButtonClicked:(id)sender;




@end
