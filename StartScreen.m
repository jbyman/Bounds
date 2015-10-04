//
//  StartScreen.m
//  UpstateHacksEntry
//
//  Created by Jake Byman on 10/3/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import "StartScreen.h"
#import "ViewController.h"

@interface StartScreen ()

@end

@implementation StartScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat centerWidth = screenRect.size.width / 2;
    CGFloat centerHeight = screenRect.size.height / 2;
    
    NSLog(@"Start screen");
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setBackgroundImage:[[UIImage imageNamed:@"play.png"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                            forState:UIControlStateNormal];
    customButton.frame = CGRectMake(centerWidth - 153/2, centerHeight - 153/2, 153, 153);
    [customButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) startGame: (id) sender{
    NSLog(@"YESSS");
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainGame"];
    
    [self presentViewController:vc animated:NO completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
