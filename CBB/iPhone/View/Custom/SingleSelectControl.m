//
//  SingleSelectControl.m

#import "SingleSelectControl.h"

@implementation SingleSelectControl
{
    UIButton *selectedButton;
}
@synthesize selectArray;
@synthesize selectIndex;

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        self.selectArray = array;
        
        UIImage *selectedImage = [UIImage imageNamed:@"Checkbox_down.png"];
        UIImage *deselectImage = [UIImage imageNamed:@"Checkbox_out.png"];
        
        for (int i = 0; i < array.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 2000+i;
            [btn setImage:selectedImage forState:UIControlStateSelected];
            [btn setImage:deselectImage forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            UILabel *label = [UILabel new];
            label.tag = 2500+i;
            label.text = [array objectAtIndex:i];
            label.backgroundColor = [UIColor clearColor];
            [self addSubview:label];
        }
        UIButton *button = (UIButton *)[self viewWithTag:2000];
        selectedButton = button;
        button.selected = YES;
        self.selectIndex = 0;        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat width = frame.size.width/self.selectArray.count;
    CGFloat x = 0;
    CGFloat y = frame.size.height/2 - 11.25f;
    for (int i = 0; i < self.selectArray.count; i++) {
        x = width*i + 15;
        UIButton *btn = (UIButton *)[self viewWithTag:2000+i];
        btn.frame = CGRectMake(x, y, 22.5f, 22.5f);
        x += 30;
        UILabel *label = (UILabel *)[self viewWithTag:2500+i];
        label.frame = CGRectMake(x, y, width-35, 22.5f);
    }
}

- (void)selectAction:(UIButton *)sender
{
    if (selectedButton == sender || !selectedButton) {
        return;
    }
    selectedButton.selected = NO;
    selectedButton = (UIButton *)sender;
    selectedButton.selected = YES;
    self.selectIndex = sender.tag-2000;
}
@end
