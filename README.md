# QFToolBar
使用AutoLayout实现的工具条，比较适合用于自定义Tabbar等。
等比例布局它上面的各个Item，并支持AutoLayout。为了保持灵活性，使用了Delegate。

``
#pragma mark - QFToolBarDelegate
- (NSInteger)numberOfItemsInToolBar:(QFToolBar *)toolBar {
    
    return _itemNames.count;
}

- (UIControl *)toolBar:(QFToolBar *)toolBar itemForIndex:(NSInteger)index {
    
    LXLayoutButton * button = [LXLayoutButton buttonWithType:UIButtonTypeCustom];
    button.subMargin = 5.0;
    [button setImage:[UIImage imageNamed:@"down_tag"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"up_tag"] forState:UIControlStateSelected];
    [button setTitle:_itemNames[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    return button;
}
`` 
