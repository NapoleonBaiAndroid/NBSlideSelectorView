//
//  ViewController.m
//  NBSlideSelectorView
//
//  Created by NapoleonBai on 15/12/2.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "ViewController.h"
#import "NBSlideSelector.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NBSlideSelector *selider = [[NBSlideSelector alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    selider.titlesArray = @[@"如果",@"你也喜欢",@"小白杨",@"那",@"就点个",@"赞吧",@"非常感谢",@"感谢所有的一切"];
    selider.backgroundHightLightColor = [UIColor greenColor];
    selider.titleHightLightColor = [UIColor yellowColor];
    selider.titleNormalColor = [UIColor redColor];
    [self.view addSubview:selider];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
