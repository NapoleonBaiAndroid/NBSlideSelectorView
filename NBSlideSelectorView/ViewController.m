//
//  ViewController.m
//  NBSlideSelectorView
//
//  Created by NapoleonBai on 15/12/2.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import "ViewController.h"
#import "NBSliderView.h"
#import "testViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NBSliderView *sliderView = [[NBSliderView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    sliderView.titlesArray = @[@"如果",@"你也喜欢",@"小白杨",@"那",@"就点个",@"赞吧",@"非常感谢",@"感谢所有的一切"];
    sliderView.backgroundHightLightColor = [UIColor greenColor];
    sliderView.titleHightLightColor = [UIColor yellowColor];
    sliderView.titleNormalColor = [UIColor redColor];
//    sliderView.titleViewWidth = 100;
    NSMutableArray *tempArray = @[].mutableCopy;
    for (int i = 0; i< sliderView.titlesArray.count; i++) {
        testViewController *test = [testViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
        [self addChildViewController:nav];
        [tempArray addObject:nav.view];
    }
    sliderView.contentArray = tempArray;
    
    sliderView.scrollToPageBlock= ^(NSInteger pageIndex){
        NSLog(@"滑动到====>>>%ld",pageIndex);
    };
    [self.view addSubview:sliderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
