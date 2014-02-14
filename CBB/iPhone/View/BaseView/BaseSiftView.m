//
//  BaseSiftView.m
//  CBB
//
//  Created by 卡宝宝 on 13-9-16.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseSiftView.h"

#pragma mark - PickerCell


@implementation PickerCell
@synthesize pickerView;
@synthesize dataSource, delegate;
@synthesize selectedItem, showGlass, peekInset;
@synthesize currentIndexPath = _currentIndexPath;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        CPPickerView *newPickerView = [[CPPickerView alloc] initWithFrame:CGRectMake(10, 5, 200, 40)];
        [self addSubview:newPickerView];
        self.pickerView = newPickerView;
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.itemFont = [UIFont boldSystemFontOfSize:14];
        self.pickerView.itemColor = [UIColor blackColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (NSIndexPath *)currentIndexPath {
    if (_currentIndexPath == nil) {
        _currentIndexPath = [(UITableView *)self.superview indexPathForCell:self];
    }
    return _currentIndexPath;
}

- (void)reloadData {
    [self.pickerView reloadData];
}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.pickerView selectItemAtIndex:index animated:animated];
}

- (NSInteger)selectedItem {
    return [self.pickerView selectedItem];
}

- (void)setShowGlass:(BOOL)doShowGlass {
    self.pickerView.showGlass = doShowGlass;
}

- (BOOL)showGlass {
    return self.pickerView.showGlass;
}

- (void)setPeekInset:(UIEdgeInsets)aPeekInset {
    self.pickerView.peekInset = aPeekInset;
}

- (UIEdgeInsets)peekInset {
    return self.pickerView.peekInset;
}

#pragma mark CPPickerView Delegate

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item {
    if ([self.delegate respondsToSelector:@selector(pickerViewAtIndexPath:didSelectItem:)]) {
        [self.delegate pickerViewAtIndexPath:self.currentIndexPath didSelectItem:item];
    }
}

#pragma mark CPPickerView Datasource

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView {
    NSInteger numberOfItems = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInPickerViewAtIndexPath:)]) {
        numberOfItems = [self.dataSource numberOfItemsInPickerViewAtIndexPath:self.currentIndexPath];
    }
    
    return numberOfItems;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item {
    NSString *title = nil;
    if ([self.dataSource respondsToSelector:@selector(pickerViewAtIndexPath:titleForItem:)]) {
        title = [self.dataSource pickerViewAtIndexPath:self.currentIndexPath titleForItem:item];
    }
    
    return title;
}
@end

#pragma mark - SelectorCell
@implementation SelectorCell
@synthesize button;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setBackgroundImage:[UIImage imageNamed:@"box1_out.png"] forState:0];
        btn.frame = CGRectMake(0, 0, 301, 45);
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.contentView addSubview:btn];
        self.button = btn;
    }
    return self;
}
@end

#pragma mark - DoubleTextCell
@implementation DoubleTextCell
{
    
}
@synthesize firLabel;
@synthesize secLabel;
@synthesize firText;
@synthesize secText;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        
        self.firLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 55, 35)];
        firLabel.text = @"最低：";
        firLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:firLabel];
        
        self.firText = [[UITextField alloc] initWithFrame:CGRectMake(70, 0, 50, 35)];
        firText.borderStyle = UITextBorderStyleRoundedRect;
        firText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        firText.keyboardType = UIKeyboardTypeNumberPad;
        firText.placeholder = @"18";
        firText.delegate = self;
        [self.contentView addSubview:firText];
        
        self.secLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 0, 55, 35)];
        secLabel.text = @"最高：";
        secLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:secLabel];
        
        self.secText = [[UITextField alloc] initWithFrame:CGRectMake(190, 0, 50, 35)];
        secText.borderStyle = UITextBorderStyleRoundedRect;
        secText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        secText.keyboardType = UIKeyboardTypeNumberPad;
        secText.placeholder = @"60";
        secText.delegate = self;
        [self.contentView addSubview:secText];
    
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESIGN_PICKER"
                                                        object:nil
                                                      userInfo:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //login
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 2) {
        return NO;
    }
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        
        CGRect aRect = scrollView.frame;        
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, self.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, self.frame.origin.y - aRect.size.height + 55);
            [scrollView setContentOffset:scrollPoint animated:YES];            
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [UIView animateWithDuration:0.3f animations:^{
            UIScrollView *scrollView = (UIScrollView *)self.superview;
            UIEdgeInsets contentInsets = UIEdgeInsetsZero;
            scrollView.contentInset = contentInsets;
            scrollView.scrollIndicatorInsets = contentInsets;
        } completion:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
#pragma mark - View
@interface BaseSiftView ()
@end

@implementation BaseSiftView
@synthesize tableView;
@synthesize delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(void)loadView
{
    [super loadView];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
#endif  // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //返回按钮
    UIButton *backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarButton.frame = CGRectMake(0, 0, 51, 33);
    [backBarButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBarButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    //筛选按钮
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setBackgroundImage:[UIImage imageNamed:@"right_btn.png"] forState:0];
    [barButton setTitle:@"筛选" forState:0];
    barButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
    [barButton sizeToFit];
    [barButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    CGRect rect;
    rect = self.view.bounds;
    rect.size.height -= 64;
    
    
	self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.tableView addGestureRecognizer:tap];
}

//返回
-(void)popAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//提交
-(void)submit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESIGN_PICKER"
                                                        object:nil
                                                      userInfo:nil];
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESIGN_PICKER"
                                                        object:nil
                                                      userInfo:nil];
    [self.view endEditing:YES];
}

-(void)resignKeyboard
{
    [self.view endEditing:YES];
}
@end
