//
//  CustomTextField.m

#import "CustomTextField.h"

@implementation CustomTextField
{
    UIImageView *backgroundImage;
    CustomTextField *activeField;
}
@synthesize tField;
@synthesize textDownImage;
@synthesize textOutImage;
@synthesize maxLength;
- (id)init
{
    if (self = [super init]) {
        self.maxLength = INT16_MAX;
        
        backgroundImage = [UIImageView new];
        [self addSubview:backgroundImage];
        
        tField = [[UITextField alloc] init];
        tField.delegate = self;
        tField.borderStyle = UITextBorderStyleNone;
        tField.leftViewMode = UITextFieldViewModeAlways;
        tField.clearButtonMode = UITextFieldViewModeWhileEditing;
        tField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:tField];
        [self registerForKeyboardNotifications];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect;
    rect.origin = CGPointZero;
    rect.size = frame.size;
    backgroundImage.frame = rect;
    tField.frame = rect;
}

-(void)setLeftOffset:(CGFloat)leftOffset
{
    CGRect rect;
    rect.origin = CGPointMake(leftOffset, 0);
    CGFloat width = tField.frame.size.width-leftOffset;
    CGFloat height = tField.frame.size.height;
    rect.size = CGSizeMake(width, height);
    tField.frame = rect;
}

-(void)setRightOffset:(CGFloat)rightOffset
{
    CGRect rect;
    rect.origin = tField.frame.origin;
    CGFloat width = tField.frame.size.width-rightOffset;
    CGFloat height = tField.frame.size.height;
    rect.size = CGSizeMake(width, height);
    tField.frame = rect;
}

-(void)setTextOutImage:(UIImage *)outImage
{
    textOutImage = outImage;
    backgroundImage.image = outImage;
}

#pragma mark - delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESIGN_PICKER"
                                                        object:nil
                                                      userInfo:nil];
    activeField = self;
    if (self.textDownImage) {
        backgroundImage.image = self.textDownImage;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    if (self.textOutImage) {
        backgroundImage.image = self.textOutImage;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //login
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= self.maxLength) {
        return NO;
    }
    return YES;
}

#pragma mark -adjust keyboard
- (void)registerForKeyboardNotifications
{    
    [[NSNotificationCenter defaultCenter] addObserver:self     
                                             selector:@selector(keyboardWasShown:)     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self     
                                             selector:@selector(keyboardWillBeHidden:)     
                                                 name:UIKeyboardWillHideNotification object:nil];
}



// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (activeField) {
        if ([activeField.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)activeField.superview;
            NSDictionary* info = [aNotification userInfo];            
            CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
            scrollView.contentInset = contentInsets;
            scrollView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible            
            // Your application might not need or want this behavior.
            
            CGRect aRect = scrollView.frame;            
            aRect.size.height -= kbSize.height;            
            if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
                CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y - aRect.size.height/4);
                [scrollView setContentOffset:scrollPoint animated:YES];
                
            }
        }
    }
}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (activeField) {
        if ([activeField.superview isKindOfClass:[UIScrollView class]]) {
            [UIView animateWithDuration:0.3f animations:^{
                UIScrollView *scrollView = (UIScrollView *)activeField.superview;
                UIEdgeInsets contentInsets = UIEdgeInsetsZero;
                scrollView.contentInset = contentInsets;
                scrollView.scrollIndicatorInsets = contentInsets;
            } completion:nil];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
