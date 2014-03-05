//
//  CustomPicker.m
//  CBB
//
//  Created by 卡宝宝 on 13-8-15.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "CustomPicker.h"
#import "UIColor+TitleColor.h"

@implementation CustomPicker
{
    UIPickerView *picker;
    UIToolbar *toolBar;
    NSString *com_one;
    NSDictionary *citys;
    NSDictionary *_data;
}
@synthesize data = _data;
@synthesize keysInOrder;
@synthesize components;
@synthesize selectItem;
@synthesize userInfo;
@synthesize delegate;
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //创建工具栏
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
        self.text = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 250, 30)];
        self.text.textColor = [UIColor titleColor];
        UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithCustomView: self.text];
        UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPicker)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:textItem];
        [items addObject:flexibleSpaceItem];
        [items addObject:confirmBtn];        
        if (toolBar==nil) {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        }
        toolBar.items = items;
        items = nil;
        [self addSubview:toolBar];
        
        picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
        picker.delegate = self;
        picker.showsSelectionIndicator = YES;
        [self addSubview:picker];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cancelPicker)
                                                     name:@"RESIGN_PICKER"
                                                   object:nil];
    }
    return self;
}

-(void)setData:(NSDictionary *)data
{
    _data = data;
    keysInOrder = [data allKeys];
}

- (void)showPickerInView:(UIView *)view
{
    com_one = [keysInOrder objectAtIndex:0];
    self.selectItem = com_one;
    
    if (self.components == 2) {
        citys = [[self.data objectForKey:self.selectItem] objectAtIndex:1];
    }    
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        for (UIView *v in view.subviews) {
            if ([v isKindOfClass:[UIScrollView class]]) {
                CGRect rect = v.frame;
                rect.size.height -= self.frame.size.height;
                v.frame = rect;
            }
        }
    } completion:^(BOOL finished) {

    }];
}

- (void)cancelPicker
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                         for (UIView *v in self.superview.subviews) {
                             if ([v isKindOfClass:[UIScrollView class]]) {
                                 CGRect rect = v.frame;
                                 rect.size.height += self.frame.size.height;
                                 v.frame = rect;
                             }
                         }
                     }
                     completion:^(BOOL finished){

                         [self removeFromSuperview];
                     }];
}
- (void)confirmPicker
{
    [self cancelPicker];
    [self.delegate confirmAction:self.selectItem WithInfo:self.userInfo];
}

//总列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.components;
}

//显示数量
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return keysInOrder.count;
        case 1:
            return [citys count];
        default:
            return 0;
    }
}

//显示内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [keysInOrder objectAtIndex:row];
        case 1:
            return [[citys allKeys] objectAtIndex:row];
        default:
            return nil;
    }    
}

//选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *key = nil;
    if (component == 0) {
        key = [keysInOrder objectAtIndex:row];
        com_one = key;
        if (self.components == 1) {
            self.selectItem = key;
        }
        if (self.components == 2) {
            citys = [[self.data objectForKey:key] objectAtIndex:1];
            [pickerView reloadComponent:1];
            self.selectItem = [NSString stringWithFormat:@"%@ - %@",key,[[citys allKeys] objectAtIndex:[pickerView selectedRowInComponent:1]]];
        }
    }
    else if (component == 1) {
        key = [[[[self.data objectForKey:com_one] objectAtIndex:1] allKeys] objectAtIndex:row];
        self.selectItem = [NSString stringWithFormat:@"%@ - %@",com_one,key];
    }
    if ([self.delegate respondsToSelector:@selector(selectAction:)]) {
        [self.delegate selectAction:self.selectItem];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"RESIGN_PICKER"
                                                  object:nil];
}
@end
