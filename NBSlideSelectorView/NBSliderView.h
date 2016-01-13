//
//  NBSliderView.h
//  NBSlideSelectorView
//
//  Created by NapoleonBai on 16/1/13.
//  Copyright © 2016年 NapoleonBai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  SliderView,支持联动,但目前不支持实时联动
 */
@interface NBSliderView : UIView

/**
 *  每次点击皆会执行,第一次设置会执行
 */
@property(nonatomic,strong)void (^scrollToPageBlock)(NSInteger);

/**
 *  标题数组
 */
@property(nonatomic,strong)NSArray<NSString *> *titlesArray;

/**
 *  内容视图,必须是UIView
 */
@property(nonatomic,strong)NSArray<UIView *> *contentArray;

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
 *  选中背景色
 */
@property(nonatomic,strong)UIColor *backgroundHightLightColor;

/**
 *  标题视图固定宽度(缺省为动态宽度)
 */
@property(nonatomic,assign)float titleViewWidth;


@end
