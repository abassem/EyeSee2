//
//  OpenCVWrapper.m
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import "OpenCVWrapper.h"
#import "Money.h"
#import <opencv2/highgui/cap_ios.h>
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/imgproc/types_c.h>
#import <CoreGraphics/CoreGraphics.h>
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/core/core.hpp"
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/calib3d/calib3d.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include <typeinfo>

@interface OpenCVWrapper() <CvVideoCameraDelegate>
@property CvVideoCamera *videoCamera;
@property UIImageView *mainImageView;
@property NSArray *moneyArray;
@property bool foundMoney;
@property (nonatomic, readwrite) int moneyFound;
@end

@implementation OpenCVWrapper

-(void)initMoney {
    
    self.moneyFound = 0;
    
    Money *oneMoney = [[Money alloc] init];
    [oneMoney setName:@"One Ringgit"];
    [oneMoney setValue:1];
    [oneMoney setCounter:0];
    [oneMoney setImage:[UIImage imageNamed:@"rm1frontCropped.png"]];
    
    Money *fiveMoney = [[Money alloc] init];
    [fiveMoney setName:@"Five Ringgit"];
    [fiveMoney setValue:5];
    [fiveMoney setCounter:0];
    [fiveMoney setImage:[UIImage imageNamed:@"rm5frontCropped.png"]];
    
    Money *tenMoney = [[Money alloc] init];
    [tenMoney setName:@"Ten Ringgit"];
    [tenMoney setValue:10];
    [tenMoney setCounter:0];
    [tenMoney setImage:[UIImage imageNamed:@"rm10frontCroppedSS.png"]];
    
    Money *twentyMoney = [[Money alloc] init];
    [twentyMoney setName:@"Twenty Ringgit"];
    [twentyMoney setValue:20];
    [twentyMoney setCounter:0];
    [twentyMoney setImage:[UIImage imageNamed:@"rm20frontCropped.png"]];
    
    self.moneyArray = [[NSArray alloc] initWithObjects:oneMoney,fiveMoney,tenMoney,twentyMoney, nil];
}

+(NSString *) openCVersionString{
    
    return [NSString stringWithFormat:@"openCV Version %s", CV_VERSION];
}


//Starts Camera (image View and MainImage VIew)
- (void)startCamera:(UIImageView*)imageView alt:(UIImageView*) mainImageView{
    if (!self.videoCamera) {
        
        //Initiate VideoCamera
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
        self.mainImageView = mainImageView;
        self.videoCamera.delegate = self;
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        self.videoCamera.defaultAVCaptureSessionPreset =
        AVCaptureSessionPreset640x480;
        self.videoCamera.defaultAVCaptureVideoOrientation =
        AVCaptureVideoOrientationPortrait;
        self.videoCamera.defaultFPS = 10 ;
    }
    [self.videoCamera start];
    
}
//Stops Camera
- (void)stopCamera{
    [self.videoCamera stop];
}

//delegate required Method
- (void)processImage:(cv::Mat &)image{
        
    if(self.moneyFound == 0) {
        //    captured Image is result CVmat to UIImage
        UIImage *capturedImage = [self UIImageFromCVMat:image];
        for (int i = 0; i < [self.moneyArray count]; i++) {
            Money *money = self.moneyArray[i];
        [self checkImageWorks:capturedImage:money];
         }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate found];
            [self stopCamera];
        });
        
    }
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




- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

- (void)checkImageWorks: (UIImage *)inputImage:(Money *)money{
    
    UIImage *sceneImage, *objectImage1;

    cv::Mat sceneImageMat, objectImageMat1;
    cv::vector<cv::KeyPoint> sceneKeypoints, objectKeypoints1;
    cv::Mat sceneDescriptors, objectDescriptors1;
    cv::SurfFeatureDetector *surfDetector;
    cv::SurfDescriptorExtractor surfExtractor;
    cv::FlannBasedMatcher flannMatcher;
    cv::vector<cv::DMatch> matches;
    float minimumDistance;
    int minHessian;
    double minDistMultiplier;
    minimumDistance = 0.6;
    minHessian = 400;
    minDistMultiplier= 3;
    surfDetector = new cv::SurfFeatureDetector(minHessian);
    
    sceneImage = inputImage;
    
    objectImage1 = [money getImage];

    
    sceneImageMat = cv::Mat(sceneImage.size.height, sceneImage.size.width, CV_8UC1);
    objectImageMat1 = cv::Mat(objectImage1.size.height, objectImage1.size.width, CV_8UC1);
    
    
    cv::cvtColor([self cvMatFromUIImage:sceneImage], sceneImageMat, CV_BGR2GRAY);
    cv::cvtColor([self cvMatFromUIImage:objectImage1], objectImageMat1, CV_BGR2GRAY);
    
    if (!sceneImageMat.data || !objectImageMat1.data) {
        NSLog(@"NO DATA");
    }
    
    surfDetector->detect(sceneImageMat, sceneKeypoints);
    surfDetector->detect(objectImageMat1, objectKeypoints1);
    
    surfExtractor.compute(sceneImageMat, sceneKeypoints, sceneDescriptors);
    surfExtractor.compute(objectImageMat1, objectKeypoints1, objectDescriptors1);
    NSLog(@"objectDescriptor is type of : %s", typeid(objectDescriptors1).name());
    NSLog(@"sceneDescriptors is type of : %s", typeid(sceneDescriptors).name());
    if(objectDescriptors1.type() != CV_32F) {
        objectDescriptors1.convertTo(objectDescriptors1, CV_32F);
    }
    
    if(sceneDescriptors.type() != CV_32F) {
        sceneDescriptors.convertTo(sceneDescriptors, CV_32F);
    }
    if ( objectDescriptors1.empty() ){
        return;
    }
    if ( sceneDescriptors.empty() ){
        return;
    }
    flannMatcher.match(objectDescriptors1, sceneDescriptors, matches);
    
    double max_dist = 0; double min_dist = 100;
    
    for( int i = 0; i < objectDescriptors1.rows; i++ )
    {
        double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
    }
    
    cv::vector<cv::DMatch> goodMatches;
    for( int i = 0; i < objectDescriptors1.rows; i++ )
    {
        if( matches[i].distance < fmax(minDistMultiplier*min_dist, minimumDistance) )
        {
            goodMatches.push_back( matches[i]);
        }
    }
    NSLog(@"Good matches found: %lu", goodMatches.size());
    
    cv::Mat imageMatches;
    cv::drawMatches(objectImageMat1, objectKeypoints1, sceneImageMat, sceneKeypoints, goodMatches, imageMatches, cv::Scalar::all(-1), cv::Scalar::all(-1),
                    cv::vector<char>(), cv::DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS);
    
    std::vector<cv::Point2f> obj;
    std::vector<cv::Point2f> scn;
    
    for( int i = 0; i < goodMatches.size(); i++ )
    {
        //-- Get the keypoints from the good matches
        obj.push_back( objectKeypoints1[ goodMatches[i].queryIdx ].pt );
        scn.push_back( sceneKeypoints[ goodMatches[i].trainIdx ].pt );
    }
    
    cv::vector<uchar> outputMask;
    NSLog(@"Object size: %lu", obj.size());
    NSLog(@"Scene size: %lu", scn.size());
    
    cv::Mat homography = cv::findHomography(obj, scn, CV_RANSAC, 3, outputMask);
    
    int inlierCounter = 0;
    for (int i = 0; i < outputMask.size(); i++) {
        if (outputMask[i] == 1) {
            inlierCounter++;
        }
    }
    NSLog(@"Inlier points %d", inlierCounter);
//    NSLog(@"Inliers percentage: %d", (int)(((float)inlierCounter / (float)outputMask.size()) * 100));
//    NSLog(@"Real percentage: %d", (int)(((float)inlierCounter / (float)goodMatches.size()) * 100));
//    
    cv::vector<cv::Point2f> objCorners(4);
    objCorners[0] = cv::Point(0,0);
    objCorners[1] = cv::Point( objectImageMat1.cols, 0 );
    objCorners[2] = cv::Point( objectImageMat1.cols, objectImageMat1.rows );
    objCorners[3] = cv::Point( 0, objectImageMat1.rows );
    
    cv::vector<cv::Point2f> scnCorners(4);
    
    cv::perspectiveTransform(objCorners, scnCorners, homography);
    
    cv::vector<cv::Point2f> rectCorners(4);
    rectCorners[0] = scnCorners[0] + cv::Point2f( objectImageMat1.cols, 0);
    rectCorners[1] = scnCorners[1] + cv::Point2f( objectImageMat1.cols, 0);
    rectCorners[2] = scnCorners[2] + cv::Point2f( objectImageMat1.cols, 0);
    rectCorners[3] = scnCorners[3] + cv::Point2f( objectImageMat1.cols, 0);
    
    cv::line( imageMatches, rectCorners[0], rectCorners[1], cv::Scalar(0, 255, 0), 4);
    cv::line( imageMatches, rectCorners[1], rectCorners[2], cv::Scalar( 0, 255, 0), 4);
    cv::line( imageMatches, rectCorners[2], rectCorners[3], cv::Scalar( 0, 255, 0), 4);
    cv::line( imageMatches, rectCorners[3], rectCorners[0], cv::Scalar( 0, 255, 0), 4);
    
    CGMutablePathRef path = CGPathCreateMutable();
     NSLog(@"RectPoints: %f, %f", rectCorners[0].x, rectCorners[0].y );
     NSLog(@"RectPoints: %f, %f", rectCorners[1].x, rectCorners[1].y );
     NSLog(@"RectPoints: %f, %f", rectCorners[2].x, rectCorners[2].y );
     NSLog(@"RectPoints: %f, %f", rectCorners[3].x, rectCorners[3].y );
    
    CGPathMoveToPoint(path, nil, rectCorners[0].x, rectCorners[0].y); //start from here
    CGPathAddLineToPoint(path, nil, rectCorners[1].x, rectCorners[1].y);
    CGPathAddLineToPoint(path, nil, rectCorners[2].x, rectCorners[2].y);
    CGPathAddLineToPoint(path, nil, rectCorners[3].x, rectCorners[3].y);
    int inTheRectCounter = 0;
    for( int i = 0; i < scn.size(); i++ )
    {
    
        CGPathContainsPoint(path, NULL, CGPointZero, NO);
        CGPoint point = CGPointMake(float(scn[i].x),float(scn[i].y));
        NSLog(@"Points: %f, %f", point.x, point.y );
        bool isItIn = CGPathContainsPoint(path, NULL, point, NO);
        if( isItIn)
        {
            inTheRectCounter++;
        }
    }
    
    NSLog(@"inTheRectCounter %d", inTheRectCounter);
    float inTheRectfloat = float(inTheRectCounter);
    float goodMatchFloat = float(goodMatches.size());
    float percentage = (inTheRectfloat/goodMatchFloat)*100;
    NSLog(@"Percentage is  %f", percentage);
    

    
    if(percentage > 0.0) {
        [money addCounter];
        
        if([money getCounter] == 2) {
            
            NSLog(@"%@",[money getName]);
            NSLog(@"%d",[money getValue]);
            
            self.moneyFound =[money getValue];
            
        }
        //  ++ else timer  45sec {tell them something}
    }
  
    UIImage *pointImage = [self UIImageFromCVMat:imageMatches];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mainImageView setImage:pointImage];
        
    });
    
}
@end
