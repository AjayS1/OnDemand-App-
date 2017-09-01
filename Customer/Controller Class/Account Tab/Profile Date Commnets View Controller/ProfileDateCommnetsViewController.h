//
//  ProfileDateCommnetsViewController.h
//  Customer
//
//  Created by Jamshed on 7/13/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileDateCommnetsViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextView *commentTextView;
    IBOutlet UILabel *textLabel;
    
    
}

@property(nonatomic,strong) NSString *titleStr;
@property(nonatomic,strong) NSString *dateLikeMessageStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;

@end
