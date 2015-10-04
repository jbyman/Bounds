//
//  SpaceShip.h
//  Bounds
//
//  Created by Jake Byman on 10/4/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceShip: NSObject{
    
}

@property float spawn_percentage;
@property float shoot_frequency;
@property float activation_chance;
@property BOOL is_activated;
@property BOOL is_alive;
@property UIImage *body_image;
@property UIImage *laser_image;
@property UIImageView *imgView;
@property UIImageView *laser_imgView;
@property int xPos;
@property int yPos;
@property BOOL direction_right;

+(id) initWithImage:(NSString*) body andLaser: (NSString*) laser;
-(void) moveSpaceShip;

@end
