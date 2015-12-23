//
//  LXToolBar.m
//  LXToolBarDemo
//
//  Created by 李新星 on 14-12-26.
//  Copyright © xx-li. All rights reserved.
//

#import "LXToolBar.h"

#define LX_ITEM_START_TAG 1000


@interface LXToolBar() {
    
    UIView * _selectedTagView;
    UIControl *_selectedItem;
    NSLayoutConstraint *_tagViewCenterConstraint;
    BOOL _didLoadUI;
}

@end

@implementation LXToolBar

#pragma mark - LifeCicle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [self reloadAllItems];
}



#pragma mark - Public
- (void) reloadAllItems {
    [self loadCusomUI];
}

- (void) hiddenCurrentSelectedStatus {
    _selectedItem.selected = NO;
    _selectedTagView.hidden = YES;
    _selectedItem = nil;
    _selectedIndex = NSNotFound;
}

- (void)setIsShowSelectedTag:(BOOL)isShowSelectedTag {
    _isShowSelectedTag = isShowSelectedTag;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    //加载完了UI才能调用
    if (_didLoadUI ) {
        [self updateUIWithSelectedAtIndex:_selectedIndex];
    }
}


#pragma  mark - private
- (void) initialize {
    NSLog(@"startinitialize");
    self.backgroundColor = [UIColor whiteColor];
    _selectedIndex = NSNotFound;
    _isDrawBottomSepLine = YES;
    _isShowSelectedTag = YES;
    _isShowItemSeparatorLine = YES;
    _itemSeparatorLineColor = [UIColor lightGrayColor];
    _edgeSeparatorLineColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    
}

- (NSInteger) getItemCount {
    //获得item个数
    if (![self.delegate respondsToSelector:@selector(numberOfItemsInToolBar:)]) {
        NSAssert(false, @"The delegate method  numberOfItemsInToolBar:  not implementation!");
    }
    return [self.delegate numberOfItemsInToolBar:self];
}


/**
 *  加载UI ，Item一般很少，不考虑重用。
 */
- (void) loadCusomUI {
    
    if (!self.delegate) {
        return;
    }
    
    for (UIView * view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    //获得item个数
    NSInteger itemCount = [self getItemCount];
    if (itemCount == 0) {
        return;
    }
    
    //分割线宽度
    CGFloat separatorSize = 1.0f / UIScreen.mainScreen.scale;
    
    for (int i = 0; i < itemCount; i ++) {
        //添加按钮
        UIControl * item = [self.delegate toolBar:self itemForIndex:i];
        if (!item) {
            NSAssert(false, @"The  toolBar:itemForIndex:  index at %d can't return nil", i);
        }
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = LX_ITEM_START_TAG + i;
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:item];
        
        //添加子控件的约束关系， 与父控件等高，宽度等分。
        NSLayoutConstraint * leftConstrint = nil;
        if (i == 0) {
            
            leftConstrint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        } else {
            
            leftConstrint =  [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:[self viewWithTag:LX_ITEM_START_TAG + i - 1] attribute:NSLayoutAttributeRight multiplier:1 constant:separatorSize];
        }
        [self addConstraints:@[
                               leftConstrint,
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:_isDrawTopSepLine ? separatorSize : 0],
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:_isDrawBottomSepLine ? separatorSize : 0],
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 / (CGFloat)itemCount constant:0]
                               ]];
        //-separatorSize *(itemCount - 1) / itemCount
        //添加分割线
        if (_isShowItemSeparatorLine) {
            //添加分割线的约束在Item之间。
            UIImageView * separatorView = [[UIImageView alloc] init];
            if (_itemSeparatorLineColor) {
                separatorView.backgroundColor = _itemSeparatorLineColor;
            }
            if (_separatorImage) {
                separatorView.image = _separatorImage;
            }
            separatorView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:separatorView];
            
            [self addConstraints:@[
                                   [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:item attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                   [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:_separatorLineInsets.top],
                                   [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-_separatorLineInsets.bottom],
                                   //TODO:定制宽度
                                   [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:separatorSize]
                                   ]];
            
        }
        
    }
    
    //Item的选中状态要保持
    if (_selectedIndex != NSNotFound) {
        _selectedItem.selected = NO;
        UIControl * sender = (UIControl *)[self viewWithTag:LX_ITEM_START_TAG + _selectedIndex];
        sender.selected = YES;
        _selectedItem = sender;
    }
    else {
        _selectedItem.selected = NO;
        _selectedItem = nil;
    }
    //添加选择标志视图
    if ([self.delegate respondsToSelector:@selector(selectedTagViewForToolBar:)]) {
        
        _selectedTagView = [self.delegate selectedTagViewForToolBar:self];
        if (_selectedTagView) {
            _selectedTagView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_selectedTagView];
            
            id leftToItem = _selectedItem ? _selectedItem : self;
            _tagViewCenterConstraint = [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:leftToItem attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
            [self addConstraints:@[
                                   _tagViewCenterConstraint,
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual  toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(_selectedTagView.frame)],
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant: -1.0 / [UIScreen mainScreen].scale],
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetWidth(_selectedTagView.frame)]
                                   ]];
        }
    }
    
    //更新状态和位置
    if (_isShowSelectedTag && _selectedItem) {
        _selectedTagView.hidden = NO;
    }
    else {
        _selectedTagView.hidden = YES;
    }
    [self layoutIfNeeded];
    
    _didLoadUI = YES;
}

- (void) updateUIWithSelectedAtIndex:(NSInteger)selectedIndex {
    //之前选择的复原
    _selectedItem.selected = NO;
    
    //未选择Item，全部复原
    if (selectedIndex == NSNotFound) {
        _selectedItem = nil;
        _selectedTagView.hidden = YES;
    }
    else {
        NSInteger previousIndex = NSNotFound;
        if (_selectedItem) {
            previousIndex = _selectedItem.tag - LX_ITEM_START_TAG;
        }
        
        UIControl * curItem = (UIControl *)[self viewWithTag:LX_ITEM_START_TAG + selectedIndex];
        _selectedItem = curItem;
        curItem.selected = YES;
        
        if ([self.delegate respondsToSelector:@selector(toolBar:didSelectItemAtIndex:previousSeleectedItemIndex:)]) {
            [self.delegate toolBar:self didSelectItemAtIndex:selectedIndex previousSeleectedItemIndex:previousIndex];
        }
        
        _selectedTagView.hidden = !_isShowSelectedTag;
        
        //约束关系更新
        [self removeConstraint:_tagViewCenterConstraint];
        _tagViewCenterConstraint = [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_selectedItem attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        [self addConstraint:_tagViewCenterConstraint];
        
        //显示的时候展示选中滑动动画
        if (_isShowSelectedTag) {
            [UIView animateWithDuration:0.25 animations:^{
                [self layoutIfNeeded];
                
            }];
        }
        
    }
    
}

- (void) itemClick:(UIControl *)sender {
    NSInteger curIndex = sender.tag - LX_ITEM_START_TAG;
    self.selectedIndex = curIndex;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!_isDrawTopSepLine && !_isDrawBottomSepLine) {
        return;
    }
    
    CGFloat scale = 1.0 / [UIScreen mainScreen].scale;
    CGFloat pointY = 0;
    
    CGContextRef contexRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contexRef, _edgeSeparatorLineColor.CGColor);
    CGContextSetLineWidth(contexRef, scale);
    
    if (_isDrawBottomSepLine) {
        pointY = CGRectGetHeight(self.bounds) - scale / 2.0;
        CGContextMoveToPoint(contexRef, 0, pointY);
        CGContextAddLineToPoint(contexRef, CGRectGetWidth(self.bounds), pointY);
    }
    
    if (_isDrawTopSepLine) {
        pointY = scale / 2.0;
        CGContextMoveToPoint(contexRef, 0, pointY);
        CGContextAddLineToPoint(contexRef, CGRectGetWidth(self.bounds), pointY);
    }
    
    CGContextDrawPath(contexRef, kCGPathFillStroke);
}


@end
