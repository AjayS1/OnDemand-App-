#import <UIKit/UIKit.h>

@interface MARKRangeSlider : UIControl

// Values
@property (nonatomic, assign) CGFloat minimumValueChange;
@property (nonatomic, assign) CGFloat maximumValue;

@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;

@property (nonatomic, assign) CGFloat minimumDistance;

@property (nonatomic) BOOL pushable;
@property (nonatomic) BOOL disableOverlapping;

// Images
@property (nonatomic) UIImage *trackImage;
@property (nonatomic) UIImage *rangeImage;

@property (nonatomic) UIImage *leftThumbImage;
@property (nonatomic) UIImage *rightThumbImage;
- (void)setMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue ;
- (void)setLeftValue:(CGFloat)leftValue rightValue:(CGFloat)rightValue ;

@end
