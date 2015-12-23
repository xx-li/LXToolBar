//
//  LXToolBar.h
//  LXToolBarDemo
//
//  Created by 李新星 on 14-12-26.
//  Copyright © xx-li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXToolBar;


@protocol LXToolBarDelegate<NSObject>

@required

- (NSInteger)numberOfItemsInToolBar:(LXToolBar *)toolBar;
/**
 *  创建Item的方法
 *
 *  @param toolBar LXToolBar 实例
 *  @param index Item的下标
 *
 *  @return 创建一个UIControl或者它的子类Item，点击后会将其的Status设为Selected
 */
- (UIControl *)toolBar:(LXToolBar *)toolBar itemForIndex:(NSInteger)index;

@optional

/**
 *  点击Item之后的回调Delegate方法
 *
 *  @param toolBar       LXToolBar 实例
 *  @param index         当前点中的item的下标
 *  @param previousIndex 上一次选中的item的下标，如果没有则返回NSNotFound
 */
- (void)toolBar:(LXToolBar *)toolBar didSelectItemAtIndex:(NSInteger)currentIndex previousSeleectedItemIndex:(NSInteger)previousIndex;

/**
 *  创建一个贴着ToolBar底部，点击后会滑动的滑块
 *
 *  @param toolBar  LXToolBar 实例
 *
 *  @return 滑块实例，它的Size决定它的最终大小
 */
- (UIView *)selectedTagViewForToolBar:(LXToolBar *)toolBar;

@end

/**
 *  自定义工具条，会等比例布局它上面的各个Item，并支持AutoLayout。
 */
@interface LXToolBar : UIView

@property (weak, nonatomic) IBOutlet id <LXToolBarDelegate> delegate;

/*! 是否画一根下部的分割线 */
@property (assign, nonatomic) BOOL isDrawBottomSepLine;

/*! 是否画一根上部的分割线若设为Yes */
@property (assign, nonatomic) BOOL isDrawTopSepLine;

/*! 是否显示每个item之间的分割线 */
@property (assign, nonatomic) BOOL isShowItemSeparatorLine;

/*! 是否隐藏滑块 */
@property (assign, nonatomic) BOOL isShowSelectedTag;

/*! 分割线的EdgeInsets,只有上下的值会生效 */
@property (assign, nonatomic) UIEdgeInsets separatorLineInsets;

/*! item直接的分割线的颜色 */
@property (strong, nonatomic) UIColor *itemSeparatorLineColor;

/*! 上下分割线的颜色，默认为alpha值为0.25的黑色 */
@property (strong, nonatomic) UIColor *edgeSeparatorLineColor;

@property (strong, nonatomic) UIImage *separatorImage;

/*! 选中的下标 */
@property (assign, nonatomic) NSInteger selectedIndex;

/*! 隐藏当前选中状态 */
- (void) hiddenCurrentSelectedStatus;

/*! 重新加载所有的Items */
- (void) reloadAllItems;

@end
