
//  FavoritesViewController.h
//  Customer
//  Created by Jamshed Ali on 14/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface FavoritesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    IBOutlet UITableView *favoritesTableView;
}

@property(nonatomic,strong)NSMutableArray *tableDataArray;

- (IBAction)backButtonClicked:(id)sender;
@end
