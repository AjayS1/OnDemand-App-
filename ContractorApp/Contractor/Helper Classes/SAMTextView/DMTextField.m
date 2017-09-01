//
//  DMTextField.m
//  Customer
//
//  Created by Aditi on 27/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "DMTextField.h"
#import "CommonUtils.h"

@implementation DMTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =  [super initWithCoder:aDecoder];
    if(self){
        
        [self defaultSetup];
    }
    return self;
}

- (void)defaultSetup {
    self.textColor = [UIColor blackColor];
    [self setupPlaceHolder];
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [CommonUtils colorWithHexString:@"CCCCCC"].CGColor;
    [self addPaddingWithValue:0];
}

- (void)setupPlaceHolder {
    if (self.placeholder.length) {//for avoiding nil placehoder
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName :[UIFont fontWithName:@"HelveticaNeue" size:14],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
}

- (void)addPaddingWithValue:(CGFloat )value {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, value+10, self.frame.size.height)];
    [self setLeftView:paddingView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setRightViewMode:UITextFieldViewModeAlways];
    // [self addplaceHolderImageInsideView:paddingView];
}

- (void)addplaceHolderImageInsideView:(UIView *)view {
    UIImageView *placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    placeHolderImageView.contentMode = UIViewContentModeScaleAspectFit;
    placeHolderImageView.center = view.center;
    placeHolderImageView.tag = 999;
    //placeHolderImageView.backgroundColor = [UIColor redColor];
    [view addSubview:placeHolderImageView];
    
}

- (void)setPaddingValue:(NSInteger)value {
    [self addPaddingWithValue:value];
}


@end
