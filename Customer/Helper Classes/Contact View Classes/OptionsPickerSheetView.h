//
//  OptionsPickerSheetView.h
//  OnDemand Aoo
//
//  Created by Aditi on 10/5/17.
//  Copyright (c) 2017 Flexsin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OptionPickerSheetBlock)(NSString  *selectedText,NSInteger selectedIndex);

@interface OptionsPickerSheetView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

+ (id)sharedPicker;

-(void)showPickerSheetWithOptions:(NSArray *)options AndComplitionblock:(OptionPickerSheetBlock )block;

@end
