// Code foundation taken from http://www.raywenderlich.com/1371/how-to-integrate-iad-into-your-iphone-app

#import <iAd/iAd.h>

@interface iAdCreator : NSObject<ADBannerViewDelegate> {
    IBOutlet ADBannerView *iAd;
    UIView *_contentView;
    BOOL _adBannerViewIsVisible;
    id adBannerView;
    UIView *viewAddedTo;
    UIWindow *windowAddedTo;
}

@property(nonatomic, retain) ADBannerView *iAd;
@property(nonatomic) BOOL _adBannerViewIsVisible;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) id adBannerView;
@property (nonatomic, retain) UIView *viewAddedTo;
@property (nonatomic, retain) UIWindow *windowAddedTo;

-(void) createAdBannerView:(UIView *)view window:(UIWindow *)window;
-(void)fixupAdView:(UIInterfaceOrientation)toInterfaceOrientation;
-(void) removeFromView;

@end
