//
//  CommonUtils.h
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "Define.h"

//#import "ServerHandler.h"
//#import "SingletonClass.h"
//#import "UCZProgressView.h"
//#import "UIImageView+WebCache.h"
//#import "ServerRequest.h"
//#import "SJAvatarBrowser.h"
//#import "SAMTextView.h"
//#import "HPGrowingTextView.h"

@interface CommonUtils : NSObject <UITextFieldDelegate>

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

//--Background Color
+(UIColor *)setBgColor;
+(UIColor *)setNavBarBgColor;
+(UIColor *)setNavBarTitleColor;
+ (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate;
+(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate;
+(NSString *)setDateStatusWithDate:(NSString *)date;
+(NSString *)changeDateINString :(NSString *)string WithFormate:(NSString *)formate;

//--AlertView
+(void)showAlertWithTitle:(NSString *)title withMsg:(NSString *)msg inController:(UIViewController *)controller;

//--Email Validation
+(BOOL)isValidEmailId:(NSString *)checkString;

//color for hexString

+(UIColor*)colorWithHexString:(NSString*)hex;
//--Sort Array
+(NSMutableArray *)sortArrayData :(NSMutableArray *)array;

//--Create UILabel
+(UILabel *)createLabelWithRect :(CGRect)rect andTitle :(NSString *)title andTextColor:(UIColor *)color;

//--Create UITextField
+(UITextField *)createTextFieldWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color withPlaceHolderText:(NSString *)placeHolderText;
//--Create UITextField
+(UITextField *)createTextFieldWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color withPlaceHolderText:(NSString *)placeHolderText fontType:(NSString *)fontType fontSize:(NSInteger)fontSize;

//--Create UIButton
+(UIButton *)createButtonWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color andFontSize:(NSString *)fontsize andImgName:(NSString *)imgName;

//--Create Title label
+(UILabel *)createTitleLabel:(UIView *)view andTitle:(NSString *)title andWidth:(NSInteger)width;

+(UILabel *)createTitleLabel:(UIView *)view andTitle:(NSString *)title andWidth:(NSInteger)width andTextColor:(UIColor *)color;

//--Create ImageView with Image
+(UIImageView *)createImgViewForImage:(NSString *)imageName andFrame:(CGRect)frame;

+(NSString *)getFormateedNumberWithValue:(NSString *)value;
// String NULL Validation
+(NSString *)checkStringForNULL:(NSString *)str;

// -- ImageView with SD webCache::
+(void)setImageUrlString:(NSString *)urlString andImgView:(UIImageView *)imgView andisCircle:(BOOL)iscircle;

+(void)setImageUrlString:(NSString *)urlString andImgView:(UIImageView *)imgView andisCircle:(BOOL)isCircle placeHolder:(NSString *)placeHolderImgName;

+ (NSString*)getfeetAndInches:(float)centimeter ;
+(NSInteger  )ChangeIncheToCm:(NSInteger)inche;
+(NSInteger )ChangeCmToInche:(NSInteger)cm;
+(NSString * )ChangeIncheTofit:(NSInteger)inche;
-(NSString *)getUTCFormateDate:(NSDate *)localDate;
+(BOOL)checkTheFormateType;
@end
