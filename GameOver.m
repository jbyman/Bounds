//
//  GameOver.m
//  Bounds
//
//  Created by Jake Byman on 10/4/15.
//  Copyright © 2015 Jake Byman. All rights reserved.
//

#import "GameOver.h"

@interface GameOver ()

@end

@implementation GameOver

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat centerWidth = screenRect.size.width / 2;
    CGFloat centerHeight = screenRect.size.height / 2;
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [customButton setBackgroundImage:[[UIImage imageNamed:@"try_again.png"]
                                      resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                            forState:UIControlStateNormal];
    customButton.frame = CGRectMake(centerWidth, centerHeight, 302, 104);
    [customButton addTarget:self action:@selector(tryAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customButton];
}

-(void) tryAgain{
    [self dismissViewControllerAnimated:NO completion:nil];
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainGame"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
