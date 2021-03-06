//
//  NBSliderView.m
//  NBSlideSelectorView
//
//  Created by NapoleonBai on 16/1/13.
//  Copyright © 2016年 NapoleonBai. All rights reserved.
//

#import "NBSliderView.h"

#define VIEW_HEIGHT 30.0f
#define TITLES_FONT 20.0f
#define DURATION 0.25f
#define TITLE_VIEW_PADDING 25.0f
#define TITLE_BASE_TAG  5000

static NSString *contentCellIdentifier = @"contentCellIdentifier";

@interface NBSliderView()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,assign)float viewWidth;
@property(nonatomic,assign)float viewHeight;
/**
 *  是否自动滚动
 */
@property(nonatomic,assign)BOOL isAutoScroll;

@property(nonatomic,strong)NSMutableArray *bottomTitleLabelsArray;

//titleView x坐标,在未设置固定宽度时使用
@property(nonatomic,assign)float titleViewX;

//高亮状态背景
@property(nonatomic,strong)UIView *backgroundHightLightView;

//高亮显示的title视图
@property(nonatomic,strong)UIView *topTitleHeightLightView;

/**
 *  标题滚动视图
 */
@property(nonatomic,strong)UIScrollView *topTitleScrollView;
/**
 *  内容滚动视图,显示界面内容
 */
@property(nonatomic,strong)UICollectionView *bottomCollectionView;

/**
 *  当前选中的
 */
@property(nonatomic,strong)UILabel *currentLabel;

@property(nonatomic,strong)UILabel *nextLabel;

@end

@implementation NBSliderView

- (float)viewWidth{
    if (_viewWidth <=0) {
        _viewWidth = [[UIApplication sharedApplication] delegate].window.frame.size.width;
    }
    return _viewWidth;
}

- (float)viewHeight{
    if (_viewHeight <= 0) {
        _viewHeight = VIEW_HEIGHT;
    }
    return _viewHeight;
}

- (float)titleFont{
    if (_titleFont <= 0) {
        _titleFont = TITLES_FONT;
    }
    return _titleFont;
}

- (UIColor *)titleNormalColor{
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor blackColor];
    }
    return _titleNormalColor;
}

- (UIScrollView *)topTitleScrollView{
    if (!_topTitleScrollView) {
        _topTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth,VIEW_HEIGHT)];
        
        _topTitleScrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        //_topTitleScrollView.delegate = self;
        _topTitleScrollView.backgroundColor = [UIColor clearColor];
        _topTitleScrollView.pagingEnabled = NO;
        _topTitleScrollView.showsHorizontalScrollIndicator = NO;
        _topTitleScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_topTitleScrollView];
    }
    return _topTitleScrollView;
}


- (NSMutableArray *)bottomTitleLabelsArray{
    if (!_bottomTitleLabelsArray) {
        _bottomTitleLabelsArray = @[].mutableCopy;
    }
    return _bottomTitleLabelsArray;
}

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.viewHeight = frame.size.height;
        self.viewWidth = frame.size.width;
    }
    return self;
}

- (void)layoutSubviews{
    [self initBottomTitles];
    [self createTopLables];
    [self createContentView];
    
    if (self.scrollToPageBlock && self.currentLabel) {
        self.scrollToPageBlock(self.currentLabel.tag - TITLE_BASE_TAG);
    }
}
/**
 *  初始化bottomtitles
 */
- (void)initBottomTitles{
    for (int i = 0; i < self.titlesArray.count; i ++) {
        UILabel *bottomLabel = [self createLabelWithTitlesIndex:i textColor:self.titleNormalColor];
        if (!self.currentLabel) {
            self.currentLabel = bottomLabel;
        }
        bottomLabel.userInteractionEnabled = YES;
        [bottomLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleButton:)]];
        bottomLabel.tag = TITLE_BASE_TAG + i;
        [self.topTitleScrollView addSubview:bottomLabel];
        [self.bottomTitleLabelsArray addObject:bottomLabel];
    }
    if (self.titleViewWidth <= 0) {
        self.topTitleScrollView.contentSize = CGSizeMake(self.titleViewX, VIEW_HEIGHT);
    }else{
        self.topTitleScrollView.contentSize = CGSizeMake(self.titleViewWidth * self.titlesArray.count, VIEW_HEIGHT);
    }
}


/**
 *  点击Title时执行
 *
 *  @param tap tap
 */
- (void)clickTitleButton:(UITapGestureRecognizer *)tap{
    UILabel *label = (UILabel *)tap.view;
    [self updateTitleLabel:label];
    self.isAutoScroll = YES;
    [self.bottomCollectionView scrollRectToVisible:CGRectMake((label.tag - TITLE_BASE_TAG) * self.bottomCollectionView.bounds.size.width, 0, self.bottomCollectionView.bounds.size.width, self.bottomCollectionView.bounds.size.height) animated:YES];
    if (self.scrollToPageBlock) {
        self.scrollToPageBlock(label.tag - TITLE_BASE_TAG);
    }
}

- (void)updateTitleLabel:(UILabel *)label{
    if (label.tag >= TITLE_BASE_TAG && label.tag < self.titlesArray.count + TITLE_BASE_TAG) {
        self.currentLabel = label;
        CGRect frame = label.frame;
        CGRect changeFrame = CGRectMake(-frame.origin.x, 0, frame.size.width, frame.size.height);
        
        [UIView animateWithDuration:DURATION animations:^{
            self.backgroundHightLightView.frame = frame;
            self.topTitleHeightLightView.frame = changeFrame;
        } completion:^(BOOL finished) {
            //动画结束完执行
            
        }];
        
        //始终显示在中间,点击选项后
        if (label.center.x < (self.topTitleScrollView.contentOffset.x + self.frame.size.width*0.5) || label.center.x > self.frame.size.width*0.5) {
            [self.topTitleScrollView scrollRectToVisible:CGRectMake(self.topTitleScrollView.contentOffset.x + label.center.x - (self.topTitleScrollView.contentOffset.x + self.frame.size.width*0.5), 0, self.frame.size.width, self.frame.size.height) animated:YES];
        }
    }
}


- (void)moveOffset:(float)offset direction:(int)direction{
    //左
    if (direction == 0) {
        //此时将右边的作为开始移动View
        
        
    }else{
        //右    此时将左边作为开始移动View
        
        
    }
}


- (void) createTopLables {
    self.titleViewX = 0;
    //默认为第一个视图宽度
    float width;
    if (self.titleViewWidth > 0) {
        width = self.titleViewWidth;
    }else{
        if (self.bottomTitleLabelsArray.count>0) {
            UILabel *label = (UILabel *)self.bottomTitleLabelsArray[0];
            width = label.frame.size.width;
        }
    }
    CGRect heightLightViewFrame = CGRectMake(0, 0, width , VIEW_HEIGHT);
    self.backgroundHightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    self.backgroundHightLightView.clipsToBounds = YES;
    self.backgroundHightLightView.backgroundColor = self.backgroundHightLightColor;
    self.backgroundHightLightView.layer.cornerRadius = 5;
    
    self.topTitleHeightLightView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.topTitleScrollView.contentSize.width, VIEW_HEIGHT)];
    
    for (int i = 0; i < self.titlesArray.count; i ++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textColor:self.titleHightLightColor];
        [self.topTitleHeightLightView addSubview:label];
    }
    
    [self.backgroundHightLightView addSubview:self.topTitleHeightLightView];
    [self.topTitleScrollView addSubview:self.backgroundHightLightView];
}

/**
 *  创建显示视图
 *
 *  @param index     下标
 *  @param textColor 颜色
 *
 *  @return titleLabel
 */
- (UILabel *)createLabelWithTitlesIndex:(NSInteger) index textColor:(UIColor *)textColor {
    CGRect currentLabelFrame = [self currentRectWithIndex:index];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
    titleLabel.textColor = textColor;
    titleLabel.text = self.titlesArray[index];
    titleLabel.font = [UIFont systemFontOfSize:self.titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

/**
 *  得到指定位置视图Frame
 *
 *  @param index 位置
 *
 *  @return frame
 */
- (CGRect)currentRectWithIndex:(NSInteger)index {
    if (self.titleViewWidth==0) {
        //没有设置固定宽度,使用计算宽度值
        NSString *tempTitles = self.titlesArray[index];
        float width = [self widthForTitle:tempTitles];
        _titleViewX += width;
        return CGRectMake(_titleViewX - width, 0, width, VIEW_HEIGHT);
    }else{
        return  CGRectMake(self.titleViewWidth * index, 0, self.titleViewWidth, VIEW_HEIGHT);
    }
}

/**
 *  动态计算指定
 *
 *  @param title 文字字符串
 *
 *  @return 返回宽度
 */
- (CGFloat)widthForTitle:(NSString *)title
{
    return [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleFont]}].width+TITLE_VIEW_PADDING;
}

//*********************以下部分为ContentView实现***********************//

- (UICollectionView *)bottomCollectionView{
    if (!_bottomCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.scrollEnabled = YES;
        _bottomCollectionView.pagingEnabled = YES;
        // _bottomCollectionView.bounces = NO;
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.showsVerticalScrollIndicator = NO;
        [_bottomCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCellIdentifier];
        
    }
    return _bottomCollectionView;
}

- (void)createContentView{
    [self addSubview:self.bottomCollectionView];
    
    NSDictionary *dict = NSDictionaryOfVariableBindings(_bottomCollectionView);
    NSDictionary *metrics = @{@"marginTop":[NSNumber numberWithInteger:VIEW_HEIGHT+5]};
    self.bottomCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *hFormatStr = @"|-0-[_bottomCollectionView]-0-|";
    NSString *vFormatStr = @"V:|-marginTop-[_bottomCollectionView]-0-|";
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hFormatStr options:0 metrics:metrics views:dict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vFormatStr options:0 metrics:metrics views:dict]];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [UICollectionViewCell new];
    }
    [cell addSubview:self.contentArray[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.isAutoScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isAutoScroll) {
        int itemIndex = (scrollView.contentOffset.x + self.bottomCollectionView.frame.size.width * 0.5) / self.bottomCollectionView.frame.size.width;
        if (!self.contentArray.count) return;
        int tagOnTitleView = itemIndex % self.contentArray.count;
        UILabel *label = [self.topTitleScrollView viewWithTag:tagOnTitleView+TITLE_BASE_TAG];
        if (self.currentLabel != label) {
            [self updateTitleLabel:label];
            
            if (self.scrollToPageBlock) {
                self.scrollToPageBlock(itemIndex);
            }
        }
    }
}

@end
