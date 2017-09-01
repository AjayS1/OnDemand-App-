//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesInputToolbar.h"
#import "JSQMessagesComposerTextView.h"
#import "JSQMessagesToolbarButtonFactory.h"
#import "SingletonClass.h"
#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIView+JSQMessages.h"

static void * kJSQMessagesInputToolbarKeyValueObservingContext = &kJSQMessagesInputToolbarKeyValueObservingContext;


@interface JSQMessagesInputToolbar () {
    
    SingletonClass *sharedInstance;
}

@property (assign, nonatomic) BOOL jsq_isObserving;

@end



@implementation JSQMessagesInputToolbar

@dynamic delegate;

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.jsq_isObserving = NO;
    self.sendButtonOnRight = YES;

     sharedInstance = [SingletonClass sharedInstance];
    
    self.preferredDefaultHeight = 44.0f;
    self.maximumHeight = NSNotFound;

    JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
    toolbarContentView.frame = self.frame;
   // toolbarContentView.frame = CGRectMake(0, self.frame.origin.y, 800, 50);

    [self addSubview:toolbarContentView];
    [self jsq_pinAllEdgesOfSubview:toolbarContentView];
    [self setNeedsUpdateConstraints];
    _contentView = toolbarContentView;

    [self jsq_addObservers];

    JSQMessagesToolbarButtonFactory *toolbarButtonFactory = [[JSQMessagesToolbarButtonFactory alloc] initWithFont:[UIFont boldSystemFontOfSize:17.0]];
    self.contentView.leftBarButtonItem = [toolbarButtonFactory defaultAccessoryButtonItem];
    self.contentView.rightBarButtonItem = [toolbarButtonFactory defaultSendButtonItem];

    [self toggleSendButtonEnabled];
}

- (JSQMessagesToolbarContentView *)loadToolbarContentView
{
    NSArray *nibViews = [[NSBundle bundleForClass:[JSQMessagesInputToolbar class]] loadNibNamed:NSStringFromClass([JSQMessagesToolbarContentView class])
                                                                                          owner:nil
                                                                                        options:nil];
    return nibViews.firstObject;
}

- (void)dealloc
{
    [self jsq_removeObservers];
}

#pragma mark - Setters

- (void)setPreferredDefaultHeight:(CGFloat)preferredDefaultHeight
{
    NSParameterAssert(preferredDefaultHeight > 0.0f);
    _preferredDefaultHeight = preferredDefaultHeight;
}

#pragma mark - Actions

- (void)jsq_leftBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
}

- (void)jsq_rightBarButtonPressed:(UIButton *)sender
{
    [self.delegate messagesInputToolbar:self didPressRightBarButton:sender];
}

#pragma mark - Input toolbar

- (void)toggleSendButtonEnabled
{
    BOOL hasText = [self.contentView.textView hasText];

    if (self.sendButtonOnRight) {
        
        if ([sharedInstance.dateEndMessageDisableStr isEqualToString:@"1"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"2"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"4"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"6"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"10"]|| [sharedInstance.dateEndMessageDisableStr isEqualToString:@"11"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"13"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"15"] ||[sharedInstance.dateEndMessageDisableStr isEqualToString:@"19"] ||[sharedInstance.dateEndMessageDisableStr isEqualToString:@"20"] || [sharedInstance.dateEndMessageDisableStr isEqualToString:@"9"] ||[sharedInstance.dateEndMessageDisableStr isEqualToString:@"100"]) {
            self.contentView.rightBarButtonItem.enabled = NO;
            [self.contentView.textView setFont:[UIFont systemFontOfSize:13.0]];
            [self.contentView.rightBarButtonItem setHidden:YES];
            [self.contentView.textView setFrame:CGRectMake(-60, self.contentView.frame.origin.y, 800, self.contentView.frame.size.height)];
            self.contentView.textView.userInteractionEnabled = NO;
            self.contentView.textView.text = @"This line is closed";
            self.contentView.textView.layer.cornerRadius = 0.0;
            self.contentView.textView.layer.borderWidth = 0.0;
            [self.contentView.textView setBackgroundColor:[UIColor clearColor]];
         //   [self.contentView setHidden:YES];
        }
        
        else {
            self.contentView.rightBarButtonItem.enabled = hasText;
        }
    }
    else {
        self.contentView.leftBarButtonItem.enabled = hasText;
    }
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesInputToolbarKeyValueObservingContext) {
        if (object == self.contentView) {

            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {

                [self.contentView.leftBarButtonItem removeTarget:self
                                                          action:NULL
                                                forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.leftBarButtonItem addTarget:self
                                                       action:@selector(jsq_leftBarButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(rightBarButtonItem))]) {

                [self.contentView.rightBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];

                [self.contentView.rightBarButtonItem addTarget:self
                                                        action:@selector(jsq_rightBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }

            [self toggleSendButtonEnabled];
        }
    }
}

- (void)jsq_addObservers
{
    if (self.jsq_isObserving) {
        return;
    }

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];

    self.jsq_isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_jsq_isObserving) {
        return;
    }

    @try {
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];

        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(rightBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
    }
    @catch (NSException *__unused exception) { }
    
    _jsq_isObserving = NO;
}

@end