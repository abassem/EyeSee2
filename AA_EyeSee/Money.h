//
//  Money.h
//  bit
//
//  Created by Faris Roslan on 20/05/2016.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Money : NSObject
- (void)setName:(NSString*)name;
- (void)setValue:(int)name;
- (void)setCounter:(int)name;
- (void)setImage:(UIImage*)name;
- (UIImage*)getImage;
- (void)addCounter;
- (int)getCounter;
- (NSString*)getName;
@end
