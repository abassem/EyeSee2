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
    _name = name;
}
-(void)setValue:(int)value {
    _value = value;
}
-(void)setCounter:(int)counter {
    _counter = counter;
}
-(void)setImage:(UIImage*)image {
    _image = image;
}

-(UIImage*)getImage {
    return _image;
}

-(int)getCounter {
    return _counter;
}

-(int)getValue {
    return _value;
}

-(NSString*)getName {
    return _name;
}

-(void)addCounter {
    int newCounter = [self getCounter] + 1;
    _counter = newCounter;
}
@end
