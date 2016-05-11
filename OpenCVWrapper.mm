//
//  OpenCVWrapper.m
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/videoio/cap_ios.h>
@interface OpenCVWrapper() <CvVideoCameraDelegate>
@property CvVideoCamera *videoCamera;
@end

@implementation OpenCVWrapper


+(NSString *) openCVersionString{
    
    return [NSString stringWithFormat:@"openCV Version %s", CV_VERSION];
}

- (void)startCamera:(UIImageView*) imageView{
    if (!self.videoCamera) {
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
        self.videoCamera.delegate = self;
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.videoCamera.defaultAVCaptureSessionPreset =
        AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation =
        AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 30;
        
//        self.videoCamera.
    }
    [self.videoCamera start];
}

- (void)stopCamera{
    [self.videoCamera stop];
}

- (void)processImage:(cv::Mat &)image{
    
}

//+ (void)startVideoCamera{
//    self->videoCamera = [[CvVideoCamera alloc] init];
//}

@end
