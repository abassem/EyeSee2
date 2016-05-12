//
//  OpenCVWrapper.h
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <opencv2/highgui/highgui_c.h>
@class CvVideoCamera;

@protocol OpenCVWrapperDelegate
@end

@interface OpenCVWrapper : NSObject

@property (nonatomic, assign) id <OpenCVWrapperDelegate> delegate;
+ (NSString *) openCVersionString;
//- (void)createCarName:(NSString*)name withColour(NSString*)colour;
- (void)startCamera:(UIImageView *) imageView;
- (void)stopCamera;
//func 2
//func 3

//func4

@end
