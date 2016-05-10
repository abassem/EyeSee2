//
//  OpenCVWrapper.m
//  AA_EyeSee
//
//  Created by Abdo Assem on 5/10/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
@implementation OpenCVWrapper


+(NSString *) openCVersionString{
    
    return [NSString stringWithFormat:@"openCV Version %s", CV_VERSION];
}

@end
