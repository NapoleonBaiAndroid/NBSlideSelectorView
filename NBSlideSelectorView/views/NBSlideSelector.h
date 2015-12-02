//
//  NBSlideSelector.h
//  NBSlideSelectorView
//
//  Created by NapoleonBai on 15/12/2.
//  Copyright © 2015年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSlideSelector : UIView
/**
 *  标题数组
 */
@property(nonatomic,strong)NSArray *titlesArray;
/**
 *  自定义颜色(普通状态下)
 */
@property(nonatomic,strong)UIColor *titleNormalColor;
/**
 *  自定义选中状态下颜色
 */
@property(nonatomic,strong)UIColor *titleHightLightColor;
/**
 *  字体大小
 */
@property(nonatomic,assign)float titleFont;
/**
 *  指示条颜色
 */
@property(nonatomic,strong)UIColor *indicatorColor;
/**
 *  选中背景色
 */
@property(nonatomic,strong)UIColor *backgroundHightLightColor;

/**
 *  标题视图固定宽度(缺省为动态宽度)
 */
@property(nonatomic,assign)float titleViewWidth;



@end
