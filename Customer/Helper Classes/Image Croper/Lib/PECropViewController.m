//
//  PECropViewController.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/19.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropViewController.h"
#import "PECropView.h"
#import "ImageCropViewController.h"
#define WIN_HEIGHT              [[UIScreen mainScreen]bounds].size.height

@interface PECropViewController () <UIActionSheetDelegate>{
    int numRot ;
}
@property (nonatomic) PECropView *cropView;
@property (nonatomic) UIActionSheet *actionSheet;

- (void)commonInit;

@end

@implementation PECropViewController
@synthesize rotationEnabled = _rotationEnabled;

+ (NSBundle *)bundle
{
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"PEPhotoCropEditor" withExtension:@"bundle"];
        bundle = [[NSBundle alloc] initWithURL:bundleURL];
    });
    
    return bundle;
}

static inline NSString *PELocalizedString(NSString *key, NSString *comment)
{
    return [[PECropViewController bundle] localizedStringForKey:key value:nil table:@"Localizable"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.rotationEnabled = YES;
}

#pragma mark -

- (void)loadView {
    UIView *contentView = [[UIView alloc] init];
    [self.tabBarController.tabBar setHidden:YES];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = contentView;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    numRot = 1;
     self.cropView = [[PECropView alloc] initWithFrame:contentView.bounds];
    self.cropView.keepingCropAspectRatio = YES;
    [contentView addSubview:self.cropView];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.toolbar.translucent = NO;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:177/255.0 green:128/255.0 blue:186/255.0 alpha:1.0]];
    self.navigationItem.title = @"CROP/ROTATE";
    [self.navigationController.navigationBar setTitleTextAttributes:
    @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"CANCEL" style:UIBarButtonItemStyleDone target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneBarButton;
    
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                           target:self
//                                                                                           action:@selector(done:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    if (!self.toolbarItems) {
//        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                       target:nil
//                                                                                       action:nil];
//        UIBarButtonItem *constrainButton = [[UIBarButtonItem alloc] initWithTitle:PELocalizedString(@"", nil)
//                                                                            style:UIBarButtonItemStyleBordered
//                                                                           target:self
//                                                                           action:@selector(constrain:)];
//        self.toolbarItems = @[flexibleSpace, flexibleSpace];
//    }
   // self.navigationController.toolbarHidden = self.toolbarHidden;
    //ImageCropViewController *contentView = [[ImageCropViewController alloc]init];
    self.cropView.image = self.image;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.cropAspectRatio != 0) {
        self.cropAspectRatio = self.cropAspectRatio;
    }
    if (!CGRectEqualToRect(self.cropRect, CGRectZero)) {
        self.cropRect = self.cropRect;
    }
    if (!CGRectEqualToRect(self.imageCropRect, CGRectZero)) {
        self.imageCropRect = self.imageCropRect;
    }
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
 }

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    UIView *subtitleMessageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    subtitleMessageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:subtitleMessageView];
    
    UIView *subtitleButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    subtitleButtonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subtitleButtonView];
    NSLog(@"Window Height%f",self.view.frame.size.height);
    
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, subtitleMessageView.frame.size.width, 50)];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.text = @"Drag the corners to crop your photo";
    subtitleLabel.adjustsFontSizeToFitWidth = YES;
    [subtitleMessageView addSubview:subtitleLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Rotate the image by using your finger" forState:UIControlStateNormal];
    NSLog(@"Main Height %f",WIN_HEIGHT);
    [button setUserInteractionEnabled:NO];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    button.frame = CGRectMake(20.0, 10.0, subtitleButtonView.frame.size.width-40, 40.0);
    button.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:90.0/255.0 blue:140.0/255.0 alpha:1.0];
    [subtitleButtonView addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

#pragma mark -
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.cropView.image = image;
    [self.cropView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)setKeepingCropAspectRatio:(BOOL)keepingCropAspectRatio
{
    _keepingCropAspectRatio = keepingCropAspectRatio;
    self.cropView.keepingCropAspectRatio = self.keepingCropAspectRatio;
}

- (void)setCropAspectRatio:(CGFloat)cropAspectRatio
{
    _cropAspectRatio = cropAspectRatio;
    self.cropView.cropAspectRatio = self.cropAspectRatio;
}

- (void)setCropRect:(CGRect)cropRect {
    
    _cropRect = cropRect;
    _imageCropRect = CGRectZero;
    CGRect cropViewCropRect = self.cropView.cropRect;
    cropViewCropRect.origin.x += cropRect.origin.x;
    cropViewCropRect.origin.y += cropRect.origin.y;
    CGSize size = CGSizeMake(fminf(CGRectGetMaxX(cropViewCropRect) - CGRectGetMinX(cropViewCropRect), CGRectGetWidth(cropRect)),
                             fminf(CGRectGetMaxY(cropViewCropRect) - CGRectGetMinY(cropViewCropRect), CGRectGetHeight(cropRect)));
    cropViewCropRect.size = size;
    self.cropView.cropRect = cropViewCropRect;
    
}

- (void)setImageCropRect:(CGRect)imageCropRect
{
    _imageCropRect = imageCropRect;
    _cropRect = CGRectZero;
    
    self.cropView.imageCropRect = imageCropRect;
}

- (BOOL)isRotationEnabled
{
    return _rotationEnabled;
}

- (void)setRotationEnabled:(BOOL)rotationEnabled
{
    _rotationEnabled = rotationEnabled;
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
}

- (CGAffineTransform)rotationTransform
{
    return self.cropView.rotation;
}

- (CGRect)zoomedCropRect
{
    return self.cropView.zoomedCropRect;
}

- (void)resetCropRect
{
    [self.cropView resetCropRect];
}

- (void)resetCropRectAnimated:(BOOL)animated
{
    [self.cropView resetCropRectAnimated:animated];
}

#pragma mark -

-(void)aMethod:(UIButton*)sender
{
    self.cropView.rotationGestureRecognizer.enabled = _rotationEnabled;
    self.cropView.transform = CGAffineTransformMakeRotation(M_PI_2 * numRot);
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:self.cropView.image.CGImage options:nil];
    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI_2 * numRot)];
    [self.cropView setRotationAngle:(M_PI_2 * numRot)];
    //[self setCropRect:self.imageCropRect];
    self.keepingCropAspectRatio = self.keepingCropAspectRatio;
    ++numRot;
    //NSLog(@"Value Of Rotation %d",numRot);
}


- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewControllerDidCancel:)]) {
        [self.delegate cropViewControllerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:transform:cropRect:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage transform: self.cropView.rotation cropRect: self.cropView.zoomedCropRect];
    }
    else if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCroppingImage:)]) {
        [self.delegate cropViewController:self didFinishCroppingImage:self.cropView.croppedImage];
    }
}

- (void)constrain:(id)sender
{
 }

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        CGRect cropRect = self.cropView.cropRect;
        CGSize size = self.cropView.image.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        CGFloat ratio;
        if (width < height) {
            ratio = width / height;
            cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect));
        } else {
            ratio = height / width;
            cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio);
        }
        self.cropView.cropRect = cropRect;
    }
    else if (buttonIndex == 1) {
        self.cropView.cropAspectRatio = 1.0f;
    }
    else if (buttonIndex == 2) {
        self.cropView.cropAspectRatio = 2.0f / 3.0f;
    }
    else if (buttonIndex == 3) {
        self.cropView.cropAspectRatio = 3.0f / 5.0f;
    }
    else if (buttonIndex == 4) {
        CGFloat ratio = 3.0f / 4.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
    else if (buttonIndex == 5) {
        self.cropView.cropAspectRatio = 4.0f / 6.0f;
    }
    else if (buttonIndex == 6) {
        self.cropView.cropAspectRatio = 5.0f / 7.0f;
    }
    else if (buttonIndex == 7) {
        self.cropView.cropAspectRatio = 8.0f / 10.0f;
    }
    else if (buttonIndex == 8) {
        CGFloat ratio = 9.0f / 16.0f;
        CGRect cropRect = self.cropView.cropRect;
        CGFloat width = CGRectGetWidth(cropRect);
        cropRect.size = CGSizeMake(width, width * ratio);
        self.cropView.cropRect = cropRect;
    }
}
@end
