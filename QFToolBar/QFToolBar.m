//
//  QFToolBar.m
//  TestCodeAutoLayout
//
//  Created by 李新星 on 14-12-26.
//  Copyright (c) 2014年 深圳市开心房网网络科技有限公司. All rights reserved.
//

#import "QFToolBar.h"

#define QF_ITEM_START_TAG 1000


@interface QFToolBar() {
    
    UIView * _selectedTagView;
    UIControl *_selectedItem;
    NSLayoutConstraint * _tagViewLeftConstraint;
}

@end

@implementation QFToolBar 


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
    
    if (_isDrawBottomSepLine || _isDrawTopSepLine)  {
        
        CGFloat offsetY = 1.0f/UIScreen.mainScreen.scale;
        
        if (_isDrawTopSepLine) {
            offsetY = 0 - offsetY;
        }
        
        [self.layer setShadowOffset:CGSizeMake(0, offsetY)];
        [self.layer setShadowRadius:0];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.25f];
    }
    
    [self reloadData];
    
}

#pragma mark - Public
- (void) reloadData {
    
    [self loadCusomUI];
    
}

- (void)setIsShowSelectedTag:(BOOL)isShowSelectedTag {
    
    if (_isShowSelectedTag == isShowSelectedTag) {
        return;
    }
    
    _isShowSelectedTag = isShowSelectedTag;
    
    if (_isShowSelectedTag && _selectedItem) {
        _selectedTagView.hidden = NO;
    } else {
        _selectedTagView.hidden = YES;
    }
}

- (void)setIsDrawBottomSepLine:(BOOL)isDrawBottomSepLine {
    _isDrawBottomSepLine = isDrawBottomSepLine;
    if (_isDrawBottomSepLine) {
        _isDrawTopSepLine = NO;
    }
}

- (void)setIsDrawTopSepLine:(BOOL)isDrawTopSepLine {
    _isDrawTopSepLine = isDrawTopSepLine;
    if (_isDrawTopSepLine) {
        _isDrawBottomSepLine = NO;
    }
}

// returns -1 or index
- (NSInteger)indexForSelectedItem {
    if (_selectedItem) {
        return _selectedItem.tag - QF_ITEM_START_TAG;
    }
    return -1;
}

- (void)selectItemAtIndex:(NSUInteger)index {
    UIControl * sender = (UIControl *)[self viewWithTag:QF_ITEM_START_TAG + index];
    [self itemClick:sender];
}

#pragma  mark - private

- (void) initialize {
    
    _isDrawBottomSepLine = YES;
    _isShowSelectedTag = YES;
    _isShowSeparatorLine = YES;
    _separatorLineColor = [UIColor lightGrayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

//支持横竖屏切换
- (void) orientationDidChange {
    if (_selectedTagView && _selectedItem) {
        _tagViewLeftConstraint.constant = CGRectGetMinX(_selectedItem.frame);
    }
}

/**
 *  加载UI ，由于里面的Item一般很少，不考虑重用。
 */
- (void) loadCusomUI {
    
    if (!self.delegate) {
        return;
    }
    
    for (UIView * view in [self subviews]) {
        
        [view removeFromSuperview];
    }
    
    //获得item个数
    NSInteger itemCount = 0;
    if (![self.delegate respondsToSelector:@selector(numberOfItemsInToolBar:)]) {
        NSAssert(false, @"The delegate method  numberOfItemsInToolBar:  not implementation!");
    }
    itemCount = [self.delegate numberOfItemsInToolBar:self];
    
    if (itemCount == 0) {
        return;
    }
    
    //分割线宽度
    CGFloat sepViewWidth = 1.0;
    
    for (int i = 0; i < itemCount; i ++) {
        
        //添加按钮
        UIControl * item = [self.delegate toolBar:self itemForIndex:i];
        
        if (!item) {
            NSAssert(false, @"The  toolBar:itemForIndex:  index at %d can't return nil", i);
        }
        
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = QF_ITEM_START_TAG + i;
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:item];
        
        //添加子控件的约束关系， 与父控件等高，宽度等分。
        NSLayoutConstraint * leftConstrint = nil;
        if (i == 0) {
            
            leftConstrint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        } else {
            
            leftConstrint =  [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:[self viewWithTag:QF_ITEM_START_TAG + i - 1] attribute:NSLayoutAttributeRight multiplier:1 constant:sepViewWidth];
        }
        [self addConstraint:leftConstrint];
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:_isDrawTopSepLine ? 1 : 0],
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:_isDrawBottomSepLine ? 1 : 0],
                               [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 / (CGFloat)itemCount constant:-sepViewWidth *(itemCount - 1) / itemCount]
                               ]];
        
        //添加分割线
        if (_isShowSeparatorLine) {
            
            //添加分割线的约束在Item之间。
            UIImageView * separatorView = [[UIImageView alloc] init];
            if (_separatorLineColor) {
                separatorView.backgroundColor = _separatorLineColor;
            }
            
            if (_separatorImage) {
                separatorView.image = _separatorImage;
            }
            
            if (separatorView) {
                separatorView.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:separatorView];
                
                [self addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:item attribute:NSLayoutAttributeRight multiplier:1 constant:0],
                                       [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:_separatorLineInsets.top],
                                       [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-_separatorLineInsets.bottom],
                                       [NSLayoutConstraint constraintWithItem:separatorView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sepViewWidth]
                                       ]];

            }
            
        }
        
    }
    
    //添加选择标志视图
    if ([self.delegate respondsToSelector:@selector(selectedTagViewForToolBar:)]) {
        
        _selectedTagView = [self.delegate selectedTagViewForToolBar:self];
        if (_selectedTagView) {
            _selectedTagView.hidden = YES;
            _selectedTagView.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:_selectedTagView];
            
            _tagViewLeftConstraint = [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        
            [self addConstraints:@[
                                   _tagViewLeftConstraint,
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual  toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_selectedTagView.frame.size.height],
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual  toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                   [NSLayoutConstraint constraintWithItem:_selectedTagView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 / (CGFloat)itemCount constant:-sepViewWidth *(itemCount - 1) / itemCount]
                                   ]];

        }
    }
    
    [self updateConstraintsIfNeeded];
}

- (void) itemClick:(UIControl *)sender {
    
    if (_isShowSelectedTag && _selectedTagView.hidden) {
        _selectedTagView.hidden = NO;
    }
    
    _selectedItem.selected = NO;
    if ([self.delegate respondsToSelector:@selector(toolBar:didDeselectItemAtIndex:)]) {
        [self.delegate toolBar:self didDeselectItemAtIndex:_selectedItem.tag - QF_ITEM_START_TAG];
    }
    
    CGRect tagRect = _selectedTagView.frame;
    tagRect.origin.x = sender.frame.origin.x;
    _tagViewLeftConstraint.constant = sender.frame.origin.x;
    [UIView animateWithDuration:0.3 animations:^{
        _selectedTagView.frame = tagRect;
    } completion:^(BOOL finished) {
        
        sender.selected = YES;
        _selectedItem = sender;
        if ([self.delegate respondsToSelector:@selector(toolBar:didSelectItemAtIndex:)]) {
            [self.delegate toolBar:self didSelectItemAtIndex:sender.tag - QF_ITEM_START_TAG];
        }

    }];
    
}



@end
