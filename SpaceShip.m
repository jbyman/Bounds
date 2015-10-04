//
//  SpaceShip.m
//  Bounds
//
//  Created by Jake Byman on 10/4/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceShip.h"

@implementation SpaceShip

@synthesize is_alive;
@synthesize spawn_percentage;
@synthesize shoot_frequency;
@synthesize activation_chance;
@synthesize is_activated;
@synthesize body_image;
@synthesize laser_image;
@synthesize xPos;
@synthesize yPos;
@synthesize imgView;
@synthesize laser_imgView;
@synthesize direction_right;

+(id) initWithImage: (NSString*) body andLaser: (NSString*) laser{
    SpaceShip *s = [[SpaceShip alloc] init];
    s.is_alive = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    int r = arc4random_uniform(100);
    if(r < 80){
        s.is_activated = YES;
    }
    else{
        s.is_activated = NO;
    }

    s.body_image = [UIImage imageNamed:body];
    s.laser_image = [UIImage imageNamed: laser];
    
    
    s.xPos = arc4random_uniform(screenWidth) - 50;
    s.yPos = 60;
    s.direction_right = YES;
    return s;
    
}


-(void) moveSpaceShip{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    
    if(direction_right){
        [UIView animateWithDuration:1.0f animations:^{
            xPos += 100;
            imgView.frame = CGRectMake(xPos, yPos, imgView.frame.size.width, imgView.frame.size.height);
        }];
        if (xPos > screenWidth - 50){
            direction_right = NO;
        }
    }
    else{
        [UIView animateWithDuration:1.0f animations:^{
            xPos -= 100;
            imgView.frame = CGRectMake(xPos, yPos, imgView.frame.size.width, imgView.frame.size.height);
        }];
        if (xPos <= 50){
            direction_right = YES;
        }
    }
    
    
}

@end