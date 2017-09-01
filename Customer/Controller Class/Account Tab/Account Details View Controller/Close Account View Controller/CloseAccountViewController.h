//
//  CloseAccountViewController.h
//  Customer
//
//  Created by Jamshed Ali on 20/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloseAccountViewController : UIViewController<UITextViewDelegate> {
    
    IBOutlet UITextView *commentsTextView;
}


- (IBAction)backButtonClicked:(id)sender;
- (IBAction)confirmCloseAccountButtonClicked:(id)sender;

@end
