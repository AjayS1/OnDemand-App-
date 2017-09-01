//
//  LanguageViewController.h
//  Customer
//
//  Created by Jamshed Ali on 15/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *selectFirstImageView;
@property (strong, nonatomic) IBOutlet UIImageView *selectSecondImageView;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)autoDetectButtonClicked:(id)sender;
- (IBAction)englishButtonClicked:(id)sender;
@end
