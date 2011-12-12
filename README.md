iAdCreator - Easily add iAds to your iOS applications
=====================================================

Supports iAd banners at the top and bottom of the screen for iPhone and iPad in portrait and landscape modes. 

Core code concept taken from http://www.raywenderlich.com/1371/how-to-integrate-iad-into-your-iphone-app

Usage
-----

Within your view:

  #import "iAdCreator.h"
  @interface ExampleUIController {
    iAdCreator *_adBannerView;
  }
  @property (nonatomic, retain) iAdCreator *adBannerView;

  @implementation ExampleUIController
    @synthesize adBannerView = _adBannerView;
    -(void)viewDidAppear:(BOOL)animated {
      _adBannerView = [[iAdCreator alloc] init];
      [_adBannerView createAdBannerView:self.view window:self.view.window];
    }
    -(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
      [_adBannerView fixupAdView:toInterfaceOrientation];
    }
    - (void)viewDidDisappear:(BOOL)animated {
      [_adBannerView removeFromView];
    }
    - (void)dealloc {
      [[NSNotificationCenter defaultCenter] removeObserver:self];
      [_adBannerView release];
    }
