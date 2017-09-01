
//  InviteFriendViewController.h
//  Customer
//  Created by Jamshed Ali on 23/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "THContactPickerView.h"
#import "THContactPickerTableViewCell.h"
@interface InviteFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ABPersonViewControllerDelegate,THContactPickerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *sendInvitationContacts;
@property (nonatomic, strong) NSArray *filteredContacts;
@property (nonatomic, strong) THContactPickerView *contactPickerView;



@end
