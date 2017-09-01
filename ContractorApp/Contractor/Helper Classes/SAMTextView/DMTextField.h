//
//  DMTextField.h
//  Customer
//
//  Created by Aditi on 27/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMTextField : UITextField
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic, setter=setPaddingValue:) IBInspectable NSInteger paddingValue;

@end
