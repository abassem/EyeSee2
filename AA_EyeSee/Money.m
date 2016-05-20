//
//  Money.m
//  bit
//
//  Created by Faris Roslan on 20/05/2016.
//  Copyright © 2016 abdoassem. All rights reserved.
//

#import "Money.h"
#import <UIKit/UIKit.h>
@implementation Money
{
    
    int _value;
    NSString *_name;
    UIImage *_image;
    int _counter;
    
}

-(void)setName:(NSString *)name {
    self.name = name;
}
-(void)setValue:(int)value {
    self.value = value;
}
-(void)setCounter:(int)counter {
    self.counter = counter;
}
-(void)setImage:(UIImage*)image {
    self.image = image;
}

@end
