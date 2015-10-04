//
//  ViewController.m
//  UpstateHacksEntry
//
//  Created by Jake Byman on 10/3/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

CAShapeLayer *circle;                   //Red circle
CAShapeLayer *backgroundCircle;         //Green circle
CAShapeLayer *threshold;                //White circle
int radius;
int radius_threshold;
int level;
int seconds_remaining;
int lives_remaining;
BOOL has_started_timer;
NSTimer *touchTimer;
NSTimer *greenZoneTimer;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    lives_remaining = 3;
    level = 1;
    
    [self reset];
}

-(void) reset{
    radius = 10;
    radius_threshold = 100;
    seconds_remaining = 3;
    has_started_timer = NO;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat centerWidth = screenRect.size.width / 2;
    CGFloat centerHeight = screenRect.size.height / 2;
    
    self.levelLabel.text = [@"Level: " stringByAppendingString:[@(level) stringValue]];
    self.levelLabel.center = CGPointMake(100, 30);
    
    self.timerLabel.text = [@(seconds_remaining) stringValue];
    self.timerLabel.center = CGPointMake(centerWidth + 50, 50);
    
    self.livesLabel.text = [@(lives_remaining) stringValue];
    self.livesLabel.center = CGPointMake(screenRect.size.width + 50, 30);
    
    
    circle = [CAShapeLayer layer];
    backgroundCircle = [CAShapeLayer layer];
    threshold = [CAShapeLayer layer];
    
    [backgroundCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - screenRect.size.width/2, centerHeight - screenRect.size.width/2, screenRect.size.width, screenRect.size.width)] CGPath]];
    [backgroundCircle setFillColor:[[UIColor greenColor] CGColor]];
    [self.view.layer addSublayer:backgroundCircle];
    
    [threshold setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius_threshold/2, centerHeight - radius_threshold/2, radius_threshold, radius_threshold)] CGPath]];
    [threshold setFillColor:[[UIColor whiteColor] CGColor]];
    [threshold setStrokeColor:[[UIColor whiteColor] CGColor]];
    
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius/2, centerHeight - radius/2, radius, radius)] CGPath]];
    [circle setFillColor:[[UIColor redColor] CGColor]];
    [self.view.layer addSublayer:circle];
    
    threshold.opacity = 0.5;
    [self.view.layer addSublayer:threshold];
    [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkForGreen) userInfo:nil repeats:YES];
}

-(BOOL) inGreenZone{
    if(radius >=  radius_threshold){
        return YES;
    }
    return NO;
}

-(void) checkForGreen{
    if([self inGreenZone]){
        if (!has_started_timer){
            greenZoneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTime) userInfo:nil repeats:YES];
            has_started_timer = YES;
        }
        
    }
    else{
        if(has_started_timer){
            [greenZoneTimer invalidate];
            lives_remaining--;
            [self reset];
        }
    }
}

-(void) touchesBegan:(NSSet*) touches withEvent:(UIEvent *)event{
    [touchTimer invalidate];
    touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(incrementImage) userInfo: nil repeats:YES];
}

-(void) touchesEnded:(NSSet*) touches withEvent:(UIEvent *)event{
    [touchTimer invalidate];
    touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(decrementImage) userInfo: nil repeats:YES];
}

-(void) incrementImage{
    radius += 2;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat centerWidth = screenRect.size.width / 2;
    CGFloat centerHeight = screenRect.size.height / 2;
    if (radius >= screenRect.size.width){
        [touchTimer invalidate];

    }
    else{
        [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius/2, centerHeight - radius/2, radius, radius)] CGPath]];
    }
}

-(void) decrementImage{
    radius -= 2;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat centerWidth = screenRect.size.width / 2;
    CGFloat centerHeight = screenRect.size.height / 2;
    
    if (radius <= 10){
        [touchTimer invalidate];
        NSLog(@"Game over!");
    }
    else{
        [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius/2, centerHeight - radius/2, radius, radius)] CGPath]];
    }
}
         
-(void) decrementTime{
    if (seconds_remaining <= 0){
        level++;
        self.levelLabel.text = [@"Level: " stringByAppendingString:[@(level) stringValue]];
        [greenZoneTimer invalidate];
        self.timerLabel.text = @"Good!";
        [self reset];
    }
    else{
        seconds_remaining -= 1;
        self.timerLabel.text = [@(seconds_remaining) stringValue];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
