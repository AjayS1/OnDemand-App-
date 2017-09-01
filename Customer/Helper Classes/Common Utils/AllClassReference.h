//
//  AllClassReference.h


#import <Foundation/Foundation.h>

#ifndef __IPHONE_5_0
#warning "This project uses features only available in iOS SDK 5.0 and later."
#endif

#import "AppDelegate.h"
#import "ViewController.h"
#import "ServerHandler.h"
#import "ProgressHUD.h"
#import "UIImageView+WebCache.h"

//#import "CommonUtils.h"
//#import "NSString+PJR.h"

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>

#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
// quick create CGColor from 32-bit RGBA value
#define RGBA(rgb) CGColorCreate(CGColorSpaceCreateDeviceRGB(), (const float*)(&(const float[]){ \
(((rgb) & 0xFF000000) >> 24)/255.0, \
(((rgb) & 0x00FF0000) >> 16)/255.0, \
(((rgb) & 0x0000FF00) >>  8)/255.0, \
(((rgb) & 0x000000FF) >>  0)/255.0 \
}))

// quick create CGColor from 24-bit RGB value
#define RGB(rgb) RGBA(((rgb)<<8)|0xff)

// quick create UIColor from 24-bit RGB value
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
