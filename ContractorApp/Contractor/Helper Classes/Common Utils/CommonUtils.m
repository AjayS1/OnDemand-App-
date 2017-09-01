//
//  CommonUtils.m


#import "CommonUtils.h"
//#import "UIImageView+WebCache.h"

@implementation CommonUtils

/*
//--View Background Color
+(UIColor *)setBgColor{

    return UIColorFromRGB(0X044E82);
}

//--View Background Color
+(UIColor *)setNavBarBgColor{
    
    return UIColorFromRGB(0XD22C3B);
}

//--View Background Color
+(UIColor *)setNavBarTitleColor{
    
    return UIColorFromRGB(0X518BD5);
}

*/


//--AlertView
+(void)showAlertWithTitle:(NSString *)title withMsg:(NSString *)msg inController:(UIViewController *)controller
{
    if ([msg isKindOfClass:[NSNull class]]) {
        [[[UIAlertView alloc]initWithTitle:title message:@"No Data" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }else{
    [[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
}

//--Email Validation
+(BOOL)isValidEmailId:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

//--Sorting Array
+(NSMutableArray *)sortArrayData :(NSMutableArray *)array{
    
    NSArray *sortedArray =[[NSArray alloc]init];
    sortedArray =[array sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedResponse =[[NSMutableArray alloc]initWithArray:sortedArray];
    return sortedResponse;
}

//--Create UILabel
+(UILabel *)createLabelWithRect :(CGRect)rect andTitle :(NSString *)title andTextColor:(UIColor *)color{
    
    UILabel *titleLable =[[UILabel alloc]initWithFrame:rect];
    titleLable =nil;
    if(titleLable ==nil){
        
        titleLable = [[UILabel alloc]initWithFrame:rect];
    }
    
    titleLable.text = title;
    titleLable.textColor =color;
    titleLable.backgroundColor =[UIColor clearColor];
//    titleLable.font=[UIFont fontWithName:KLightFontStyle size:14];
     titleLable.font=[UIFont systemFontOfSize:16];
    return titleLable;
}

//--Create UITextField
+(UITextField *)createTextFieldWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color withPlaceHolderText:(NSString *)placeHolderText{
    
    UITextField *textField =[[UITextField alloc]initWithFrame:rect];
    textField =nil;
    if(textField ==nil){
      
        textField =[[UITextField alloc]initWithFrame:rect];
    }
    
//    textField.attributedPlaceholder =
//    [[NSAttributedString alloc]
//     initWithString:placeHolderText
//     attributes:@{NSForegroundColorAttributeName:KTextFieldPlaceholderColor}];
  
    textField.text = title;
    textField.textColor =color;
    textField.backgroundColor =[UIColor clearColor];
  //  textField.font=[UIFont fontWithName:KMediumFontStyle size:16];
    textField.font=[UIFont systemFontOfSize:16];

    textField.borderStyle = UITextBorderStyleNone;
    textField.autocapitalizationType = NO;
    textField.autocorrectionType = NO;
    textField.userInteractionEnabled = YES;

    UIView *leftViewAdd = [[UIView alloc]initWithFrame:CGRectMake(35, 5, 10, 35)];
    textField.leftView = leftViewAdd;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.backgroundColor =[UIColor whiteColor];
    textField.delegate = self;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

//--Create UITextField
+(UITextField *)createTextFieldWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color withPlaceHolderText:(NSString *)placeHolderText fontType:(NSString *)fontType fontSize:(NSInteger)fontSize{
    
    UITextField *textField =[[UITextField alloc]initWithFrame:rect];
    textField =nil;
    if(textField ==nil){
        
        textField =[[UITextField alloc]initWithFrame:rect];
    }
    
   // textField.attributedPlaceholder =
//    [[NSAttributedString alloc]
//     initWithString:placeHolderText
//     attributes:@{NSForegroundColorAttributeName:KTextFieldPlaceholderColor}];
    
    textField.text = title;
    textField.textColor =color;
    textField.backgroundColor =[UIColor clearColor];
    textField.font=[UIFont fontWithName:fontType size:fontSize];
    return textField;
}

+(NSString *)getFormateedNumberWithValue:(NSString *)value{
    
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    numberFormatter.lenient = YES;
    NSNumber *number = [numberFormatter numberFromString:value];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *localizedMoneyString = [formatter stringFromNumber:number];
    NSLog(@"Formatted Value in Currency %@",localizedMoneyString);
    return localizedMoneyString;
}




//--Create UIButton
+(UIButton *)createButtonWithRect :(CGRect)rect andText :(NSString *)title andTextColor:(UIColor *)color andFontSize:(NSString *)fontsize andImgName:(NSString *)imgName{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button =nil;
    if(button ==nil){
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    button.frame=rect;
    button.backgroundColor =[UIColor clearColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
//    [button.titleLabel setFont:[UIFont fontWithName:KBoldFontStyle size:[fontsize intValue]]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
 //    [button setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];

    return button;
}

//--Title Label
+(UILabel *)createTitleLabel:(UIView *)view andTitle:(NSString *)title andWidth:(NSInteger)width {
    
    UILabel *titileLbl=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width)/2, 24, width, 40)];
    titileLbl =nil;
    if(titileLbl ==nil){
        
        titileLbl = [[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width)/2, 24, width, 40)];
    }
    
    titileLbl.backgroundColor=[UIColor clearColor];
    titileLbl.textColor=[UIColor whiteColor];
//    titileLbl.font = [UIFont fontWithName:KBoldFontStyle size:16];
    titileLbl.font = [UIFont systemFontOfSize:16];
    titileLbl.text = title;
    titileLbl.textAlignment=NSTextAlignmentCenter;
    
    return titileLbl;
}


+(UILabel *)createTitleLabel:(UIView *)view andTitle:(NSString *)title andWidth:(NSInteger)width andTextColor:(UIColor *)color
{

    UILabel *titileLbl=[[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width)/2, 24, width, 40)];
    titileLbl =nil;
    if(titileLbl ==nil){
        
        titileLbl = [[UILabel alloc]initWithFrame:CGRectMake((view.frame.size.width-width)/2, 24, width, 40)];
    }
    
    titileLbl.backgroundColor=[UIColor clearColor];
    titileLbl.textColor=[UIColor whiteColor];
//    titileLbl.font = [UIFont fontWithName:KBoldFontStyle size:20];
    titileLbl.font = [UIFont systemFontOfSize:20];
    titileLbl.text = title;
    titileLbl.textAlignment=NSTextAlignmentCenter;
    return titileLbl;
}

//--Create ImageView
+(UIImageView *)createImgViewForImage:(NSString *)imageName andFrame:(CGRect)frame{

    UIImageView *ImgVw =[[UIImageView alloc]initWithFrame:frame];
    ImgVw.image=[UIImage imageNamed:imageName];
    ImgVw.userInteractionEnabled=YES;
    return ImgVw;
}

// -- Check For Null Value String::
+(NSString *)checkStringForNULL:(NSString *)str{
    
    if(str == (id)[NSNull null] || [str isEqualToString:@""] || [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"]){
        
        return str =@"";
    }
    return str;
}

#pragma ImageView with SD webCache
+(void)setImageUrlString:(NSString *)urlString andImgView:(UIImageView *)imgView andisCircle:(BOOL)iscircle{

    NSURL *imgUrl =[[NSURL alloc]initWithString:urlString];
   // [imgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    NSLog(@"%@",imgUrl);
    if(iscircle){
        imgView.layer.cornerRadius = imgView.frame.size.height/2;
        imgView.clipsToBounds =YES;
    }
}

NSString * imageToNSString (UIImage *image ){
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return (imageStr.length) ? imageStr: @"";
}

#pragma Change Date to utc date
-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

#pragma mark: Check that user is selcted the 24th hour or 13th hour formate
+(BOOL)checkTheFormateType{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    NSLog(@"%@\n",(is24h ? @"YES" : @"NO"));
    return is24h;
    
}

+(NSString *) convertUTCTimeToLocalTime:(NSString *)dateString
                            WithFormate:(NSString *)formate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formate];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    //    if (isDayLightSavingTime) {
    //        NSTimeInterval timeInterval = [sourceTimeZone  daylightSavingTimeOffsetForDate:dateFromString];
    //        dateFromString = [dateFromString dateByAddingTimeInterval:timeInterval];
    //    }
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    //Log: dateRepresentation - 2016-03-08 01:00:00
    return dateRepresentation;
    
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMMM d, YYYY @ hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    NSLog(@"Date %@",dateRepresentation);
    return dateRepresentation;
}

@end
