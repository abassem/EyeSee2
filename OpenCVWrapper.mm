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
    }
    [self.videoCamera start];
    
}

- (void)stopCamera{
    [self.videoCamera stop];
}

- (void)processImage:(cv::Mat &)image{
    UIImage *capturedImage = [self UIImageFromCVMat:image];

}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end
