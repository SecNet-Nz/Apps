

#import <UIKit/UIKit.h>

@interface OTTorchView : UIImageView
{
  BOOL screenTorchOn;
}

- (void)setScreenTorchOn:(BOOL)newScreenTorchOn;
- (BOOL)screenTorchOn;

@end
