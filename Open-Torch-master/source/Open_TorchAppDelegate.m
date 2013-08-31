//
//  Open_TorchAppDelegate.m
//

#import "Open_TorchAppDelegate.h"

#import "Open_TorchViewController.h"

@implementation Open_TorchAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // hide status bar
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  
  // show window
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  [self turnTorchOn];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  [self turnTorchOff];
}

- (void)turnTorchOn
{
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  if (device && [device hasTorch] && [device hasFlash]) {
    [self turnTorchOnInFlashMode];
  } else {
    [self turnTorchOnInScreenMode];
  }
}

- (void)turnTorchOnInFlashMode
{
  AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  if (!captureSession) {
    AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error: nil];
    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];
    
    captureSession = [[AVCaptureSession alloc] init];
    
    [captureSession beginConfiguration];
    [device lockForConfiguration:nil];
    
    [captureSession addInput:flashInput];
    [captureSession addOutput:output];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device setFlashMode:AVCaptureFlashModeOn];
    
    [device unlockForConfiguration];
    
    [captureSession commitConfiguration];
  }
  
  [captureSession startRunning];
  
  [device lockForConfiguration:nil];
  [device setTorchMode:AVCaptureTorchModeOn];
  [device setFlashMode:AVCaptureFlashModeOn];
  [device unlockForConfiguration];
}

- (void)turnTorchOnInScreenMode
{
  self.viewController.screenTorchView.screenTorchOn = YES;
}

- (void)turnTorchOff
{
  if (!captureSession)
    return;
  
  [captureSession stopRunning];
  
  self.viewController.screenTorchView.screenTorchOn = NO;
}

- (void)dealloc
{
  [captureSession release];
  [_window release];
  [_viewController release];
  [super dealloc];
}

@end
