// Code foundation taken from http://www.raywenderlich.com/1371/how-to-integrate-iad-into-your-iphone-app

#import "iAdCreator.h"
#import "Device.h"

@implementation iAdCreator

@synthesize iAd;
@synthesize _adBannerViewIsVisible;
@synthesize contentView = _contentView;
@synthesize adBannerView = _adBannerView;
@synthesize viewAddedTo;
@synthesize windowAddedTo;


- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if([Device isiPad]) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return 341;
        } else {
            return 84;
        }
    }
    else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            return 32;
        } else {
            return 50;
        }
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

// Comment out or undef to use iAds at top of screen.
#define __BOTTOM_iAD__ 

-(void)createAdBannerView:(UIView *)view window:(UIWindow *)window
{
    self.viewAddedTo = view;
    self.windowAddedTo = window;
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    
    if (classAdBannerView != nil)
    {
        self.adBannerView = [[[classAdBannerView alloc]
                              initWithFrame:CGRectZero] autorelease];
        [_adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                          ADBannerContentSizeIdentifierPortrait,
                                                          ADBannerContentSizeIdentifierLandscape, nil]];
                
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        }
        else
        {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        }
                
#ifdef __BOTTOM_iAD__
        // Banner at Bottom
        CGRect cgRect = [window bounds];
        CGSize cgSize = cgRect.size;
        [_adBannerView setFrame:CGRectOffset([_adBannerView frame],
                                             0, cgSize.height + [self getBannerHeight])];
#else
        // Banner at the Top
        [adBannerView setFrame:CGRectOffset([adBannerView frame],
                                            0, -[self getBannerHeight])];
#endif
        
        [_adBannerView setDelegate:self];
        
        [viewAddedTo addSubview:_adBannerView];
    }
}

-(void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (_adBannerView != nil)
    {
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
        }
        else
        {
            [_adBannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
        } 
        
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (_adBannerViewIsVisible)
        {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
#ifdef __BOTTOM_iAD__
            CGRect cgRect =[[self windowAddedTo] bounds];
            CGSize cgSize = cgRect.size;
            
            adBannerViewFrame.origin.y = cgSize.height - [self getBannerHeight:toInterfaceOrientation];

#else
            adBannerViewFrame.origin.y = 0;
#endif
            [_adBannerView setFrame:adBannerViewFrame];
            
            CGRect contentViewFrame = _contentView.frame;
#ifdef __BOTTOM_iAD__
            contentViewFrame.origin.y = 0;
#else
            contentViewFrame.origin.y = [self getBannerHeight:toInterfaceOrientation];
#endif
            contentViewFrame.size.height = viewAddedTo.frame.size.height -
            [self getBannerHeight:toInterfaceOrientation];
            _contentView.frame = contentViewFrame;
        }
        else
        {
            CGRect adBannerViewFrame = [_adBannerView frame];
            adBannerViewFrame.origin.x = 0;
#ifdef __BOTTOM_iAD__
            CGRect cgRect =[[self windowAddedTo] bounds];
            CGSize cgSize = cgRect.size;
            adBannerViewFrame.origin.y = cgSize.height;
#else
            adBannerViewFrame.origin.y = 0;
#endif
            [_adBannerView setFrame:adBannerViewFrame];
            
            CGRect contentViewFrame = _contentView.frame;
            contentViewFrame.origin.y = 0;
            contentViewFrame.size.height = viewAddedTo.frame.size.height;
            _contentView.frame = contentViewFrame;
        }
        
        [UIView commitAnimations];
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!_adBannerViewIsVisible) {                
        _adBannerViewIsVisible = YES;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
    if (_adBannerViewIsVisible)
    {        
        _adBannerViewIsVisible = NO;
        [self fixupAdView:[UIDevice currentDevice].orientation];
    }
}


-(void) removeFromView {
   [_adBannerView removeFromSuperview]; 
}

- (void)dealloc {
    [iAd release];
    [_contentView release];
    [_adBannerView release];
    [viewAddedTo release];
    [windowAddedTo release];
    [super dealloc];
}

@end
