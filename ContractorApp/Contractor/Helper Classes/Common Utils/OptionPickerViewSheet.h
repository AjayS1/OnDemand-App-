//
//  OptionPickerViewSheet.h
//  Contractor
//
//  Created by Aditi on 26/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^OptionPickerSheetBlock)(NSString  *selectedText,NSInteger selectedIndex);

@interface OptionPickerViewSheet : UIView<UIPickerViewDelegate,UIPickerViewDataSource,UIApplicationDelegate>
+ (id)sharedPicker;

-(void)showPickerSheetWithOptions:(NSArray *)options AndComplitionblock:(OptionPickerSheetBlock )block;
@end
