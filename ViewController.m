//
//  ViewController.m
//  UpstateHacksEntry
//
//  Created by Jake Byman on 10/3/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import "ViewController.h"
#import "SpaceShip.h"
#import "GameOver.h"
#import <Foundation/Foundation.h>

@interface ViewController ()

@end

@implementation ViewController

CAShapeLayer *circle;                   //Red circle
CAShapeLayer *backgroundCircle;         //Green circle
CAShapeLayer *threshold;                //White circle
int radius;
int radius_threshold;
int green_radius;
int level;
int difficult_factor;
int seconds_remaining;
int lives_remaining;
int shake_percentage;
int blue_starting_threshold;
int blue_starting_green;
BOOL has_started_timer;
BOOL shake_enabled;
NSTimer *touchTimer;
NSTimer *greenZoneTimer;
CGRect screenRect;
CGFloat centerWidth;
CGFloat centerHeight;
NSMutableArray<SpaceShip*> *spaceShips;


- (void)viewDidLoad {
    [super viewDidLoad];
    spaceShips = [[NSMutableArray alloc] init];

    [self drawSpaceShip];
    
    
    lives_remaining = 0;
    shake_percentage = 50;
    level = 15;
    difficult_factor = 15;
    shake_enabled = NO;
    [self reset];
    
}

-(void) reset {
    [circle removeFromSuperlayer];
    [threshold removeFromSuperlayer];
    [backgroundCircle removeFromSuperlayer];
    
    radius = 10;
    radius_threshold = 100;
    
    seconds_remaining = 3;
    has_started_timer = NO;
    screenRect = [[UIScreen mainScreen] bounds];
    centerWidth = screenRect.size.width / 2;
    centerHeight = screenRect.size.height / 2;
    
    green_radius = screenRect.size.width;
    
    NSLog(@"RESET");
    
    self.levelLabel.text = [@"Level: " stringByAppendingString:[@(level) stringValue]];
    self.levelLabel.center = CGPointMake(100, 30);
    
    self.timerLabel.text = [@(seconds_remaining) stringValue];
    self.timerLabel.center = CGPointMake(centerWidth + 50, 50);
    
    self.livesLabel.text = [@(lives_remaining) stringValue];
    self.livesLabel.center = CGPointMake(screenRect.size.width + 50, 30);
    
    backgroundCircle = [CAShapeLayer layer];
    threshold = [CAShapeLayer layer];
    circle = [CAShapeLayer layer];
    
    if(level <= 5){
        [backgroundCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - screenRect.size.width/2, centerHeight - screenRect.size.width/2, screenRect.size.width, screenRect.size.width)] CGPath]];
        [backgroundCircle setFillColor:[[UIColor greenColor] CGColor]];
        
        
        radius_threshold = radius_threshold + 20*difficult_factor;
        [threshold setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius_threshold/2, centerHeight - radius_threshold/2, radius_threshold, radius_threshold)] CGPath]];
        [threshold setFillColor:[[UIColor whiteColor] CGColor]];
        [threshold setStrokeColor:[[UIColor whiteColor] CGColor]];
        
        threshold.opacity = 0.5;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkForGreen) userInfo:nil repeats:YES];
    }
    else if(level >= 6 && level < 15){
        green_radius = green_radius - 5*difficult_factor;
        [backgroundCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - green_radius/2, centerHeight - green_radius/2, screenRect.size.width - 5*difficult_factor, screenRect.size.width - 5*difficult_factor)] CGPath]];
        [backgroundCircle setFillColor:[[UIColor greenColor] CGColor]];
        
        radius_threshold = radius_threshold + 5*difficult_factor;
        
        [threshold setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - (radius_threshold)/2,
                                                                              centerHeight - (radius_threshold)/2,radius_threshold, radius_threshold)] CGPath]];
        [threshold setFillColor:[[UIColor whiteColor] CGColor]];
        [threshold setStrokeColor:[[UIColor whiteColor] CGColor]];
        
        threshold.opacity = 0.5;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkForGreen) userInfo:nil repeats:YES];
    }
    else if(level >= 15){
        shake_enabled = YES;
        
        if (level == 15){
            difficult_factor = 6;
        }
        
        green_radius = green_radius - 5*difficult_factor;
        [backgroundCircle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - green_radius/2, centerHeight - green_radius/2, screenRect.size.width - 5*difficult_factor, screenRect.size.width - 5*difficult_factor)] CGPath]];
        [backgroundCircle setFillColor:[[UIColor greenColor] CGColor]];
        
        radius_threshold = radius_threshold + 5*difficult_factor;
        
        [threshold setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - (radius_threshold)/2,
                                                                              centerHeight - (radius_threshold)/2,radius_threshold, radius_threshold)] CGPath]];
        [threshold setFillColor:[[UIColor whiteColor] CGColor]];
        [threshold setStrokeColor:[[UIColor whiteColor] CGColor]];
        
        threshold.opacity = 0.5;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkForGreen) userInfo:nil repeats:YES];
    }
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(centerWidth - radius/2, centerHeight - radius/2, radius, radius)] CGPath]];
    [circle setFillColor:[[UIColor redColor] CGColor]];
    
    [self.view.layer addSublayer:backgroundCircle];
    [self.view.layer addSublayer:circle];
    [self.view.layer addSublayer:threshold];
    
   
}

-(BOOL) inGreenZone{
    if(radius >=  radius_threshold && radius <= green_radius){
        return YES;
    }
    return NO;
}

-(void) showGameOver{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *myVC = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"GameOver"];
    NSLog(@"%@", myVC);
    [self presentViewController:myVC animated:NO completion:nil];
}

-(void) checkForGreen{
    if([self inGreenZone]){
        if (!has_started_timer){        //Start timer because in green zone
            greenZoneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementTime) userInfo:nil repeats:YES];
            has_started_timer = YES;
        }
        
    }
    else{
        if(has_started_timer){      //Life lost
            if(lives_remaining <= 1){
                NSLog(@"LKSDJFLKDSJFLKSJDFDKSJFLSKDFJ");
                [greenZoneTimer invalidate];
                [self performSelector:@selector(showGameOver) withObject:nil afterDelay:0.0];
                [self dismissViewControllerAnimated:NO completion:nil];
                
            }
            else{
                lives_remaining--;
                [self reset];
            }
        }
    }
}

-(void) touchesBegan:(NSSet*) touches withEvent:(UIEvent *)event{
    if(shake_enabled){
        [self shakeScreen];
    }
    
    
    NSDictionary *params;
    for(int i = 0; i < [spaceShips count]; i++){
        [spaceShips[i] moveSpaceShip];
        if(spaceShips[i].is_activated){
            params = [NSDictionary dictionaryWithObjectsAndKeys:spaceShips[i], @"spaceship", nil];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(shootAtCenter:) userInfo:params repeats:YES];
        }
    }
    [touchTimer invalidate];
    touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(incrementImage) userInfo: nil repeats:YES];
}

-(void) touchesEnded:(NSSet*) touches withEvent:(UIEvent *)event{
    [touchTimer invalidate];
    touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(decrementImage) userInfo: nil repeats:YES];
}

-(void) shakeScreen{
    int r = arc4random_uniform(100);
    int num_shakes = arc4random_uniform(7);
    
    if (r <= shake_percentage){
        CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
        anim.values = @[ [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-20.0f, 5.3f, 1.0f) ], [ NSValue valueWithCATransform3D:CATransform3DMakeTranslation(6.0f, 1.0f, -3.0f) ] ] ;
        anim.autoreverses = YES ;
        anim.repeatCount = num_shakes;
        anim.duration = 0.07f ;
        
        [self.view.layer addAnimation:anim forKey:nil ];
    }
}

-(SpaceShip*) drawSpaceShip{
    SpaceShip *s = [SpaceShip initWithImage:@"spaceship.png" andLaser:@"lasers.png"];
    
    s.imgView = [[UIImageView alloc] initWithImage:s.body_image];
    s.imgView.frame = CGRectMake(s.xPos, s.yPos, s.imgView.frame.size.width, s.imgView.frame.size.height);
    
    [self.view addSubview:s.imgView];
    [spaceShips addObject:s];
    return s;
}

-(void) shootAtCenter:(NSTimer*) t{
    SpaceShip *s = [[t userInfo] objectForKey:@"spaceship"];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGPoint p = CGPointMake(screenWidth, screenHeight);
    
    
    s.laser_imgView = [[UIImageView alloc] initWithImage:s.laser_image];
    s.laser_imgView.frame = CGRectMake(s.xPos, s.yPos, s.laser_imgView.frame.size.width, s.laser_imgView.frame.size.height);
    [self.view addSubview:s.laser_imgView];
    
    [UIView animateWithDuration:1.0f animations:^{
        s.laser_imgView.frame = CGRectMake(centerWidth, centerHeight, s.laser_imgView.frame.size.width, s.laser_imgView.frame.size.height);
    }];
    //[s.laser_imgView removeFromSuperview];
    
    if(p.y > centerHeight){
        NSLog(@"Intersection");
        radius += 5;
    }
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
    if (seconds_remaining <= 0){        //Next level
        level++;
        difficult_factor++;
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
