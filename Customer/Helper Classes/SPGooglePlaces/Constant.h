//
//  Constant.h
//  Bling App
//
//  Created by Flexsin on 21/11/14.
//  Copyright (c) 2014 Flexsin. All rights reserved.
//

#define iPhone [[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone
#import "UserData.h"
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define sharedUserDataObj [UserData getUserData]
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]// device check
#define IS_IPHONE4  ([[ UIScreen mainScreen ] bounds ].size.height == 480)
//#import "ELCImagePickerHeader.h"
#define IS_IPHONE6  ([[ UIScreen mainScreen ] bounds ].size.height == 667)
#define IS_IPHONE6Plus  ([[ UIScreen mainScreen ] bounds ].size.height == 736)
// roboto font
//#import "MeVC.h"
#define OpenSansSemiBold @"OpenSans-Semibold"
#define OpenSans @"OpenSans"
#define OpenSansLight @"OpenSans-Light"
#define OpenSansBold @"opensans-bold"

#define BlockServiceBaseUrl @"http://flexsin.org/lab/visualtotal/public/media/service/"
#define BASE_URLImage @"http://flexsin.org/lab/visualtotal/public/media/category/"
#define BASE_URLuservender @"http://flexsin.org/lab/visualtotal/public/media/userimage/"
#define BASE_URLImageProduct @"http://flexsin.org/lab/visualtotal/public/media/product/"
#define BASE_URLImagestaff @"http://flexsin.org/lab/visualtotal/public/media/staff/"





