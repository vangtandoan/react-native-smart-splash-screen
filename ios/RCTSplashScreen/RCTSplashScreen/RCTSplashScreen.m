
#import "RCTSplashScreen.h"

static RCTRootView *rootView = nil;

@interface RCTSplashScreen()

@end

@implementation RCTSplashScreen

RCT_EXPORT_MODULE(SplashScreen)


+ (void)open:(RCTRootView *)v {
    [RCTSplashScreen open:v withImageNamed:@"splash"];
}


+ (void)open:(RCTRootView *)v withImageNamed:(NSString *)imageName {
    CGRect tFrame = [UIScreen mainScreen].bounds;
    rootView = v;
    //[rootView setBackgroundColor:[UIColor colorWithRed:54/255.0 green:37/255.0 blue:80/255.0 alpha:1.0]];
    UIView *bgView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    [bgView setBackgroundColor: [UIColor colorWithRed:54/255.0 green:37/255.0 blue:80/255.0 alpha:1.0]];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake((tFrame.size.width - 271)/2, (tFrame.size.height / 2 - 171/2) - 45, 271, 171)];
    view.image = [UIImage imageNamed:imageName];
    
//    view.contentMode = UIViewContentModescaleAspectFit;
    view.contentMode = UIViewContentModeScaleAspectFit;

    [bgView addSubview:view];
    
    [[NSNotificationCenter defaultCenter] removeObserver:rootView  name:RCTContentDidAppearNotification object:rootView];
    
    [rootView setLoadingView:bgView];
}

RCT_EXPORT_METHOD(close:(NSDictionary *)options) {
    if (!rootView) {
        return;
    }
    
    int animationType = UIAnimationNone;
    int duration = 0;
    int delay = 0;
    
    if(options != nil) {
        
        NSArray *keys = [options allKeys];
        
        if([keys containsObject:@"animationType"]) {
            animationType = [[options objectForKey:@"animationType"] intValue];
        }
        if([keys containsObject:@"duration"]) {
            duration = [[options objectForKey:@"duration"] intValue];
        }
        if([keys containsObject:@"delay"]) {
            delay = [[options objectForKey:@"delay"] intValue];
        }
    }

    if(animationType == UIAnimationNone) {
        rootView.loadingViewFadeDelay = 0;
        rootView.loadingViewFadeDuration = 0;
    }
    else {
        rootView.loadingViewFadeDelay = delay / 1000.0;
        rootView.loadingViewFadeDuration = duration / 1000.0;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rootView.loadingViewFadeDelay * NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   ^{
                       [UIView animateWithDuration:rootView.loadingViewFadeDuration
                                        animations:^{
                                            if(animationType == UIAnimationScale) {
                                                rootView.loadingView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                                rootView.loadingView.alpha = 0;
                                            }
                                            else {
                                                rootView.loadingView.alpha = 0;
                                            }
                                        } completion:^(__unused BOOL finished) {
                                            [rootView.loadingView removeFromSuperview];
                                        }];
                   });
    
}

- (NSDictionary *)constantsToExport
{
    return @{
             @"animationType": @{
                     @"none": @(UIAnimationNone),
                     @"fade": @(UIAnimationFade),
                     @"scale": @(UIAnimationScale),
                 }
             };
}

@end
